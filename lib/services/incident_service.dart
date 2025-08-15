import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/incident_report.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';

class IncidentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  // Report an incident
  Future<String> reportIncident({
    required String reporterId,
    required String reporterName,
    required String title,
    required String description,
    required IncidentType type,
    required double latitude,
    required double longitude,
    required String address,
    List<File>? images,
    List<File>? videos,
    File? audio,
    int? severity,
  }) async {
    try {
      String incidentId = _uuid.v4();
      List<String> imageUrls = [];
      List<String> videoUrls = [];
      String? audioUrl;

      // Upload images
      if (images != null && images.isNotEmpty) {
        for (File image in images) {
          String imageUrl = await _uploadFile(image, 'incidents/$incidentId/images');
          imageUrls.add(imageUrl);
        }
      }

      // Upload videos
      if (videos != null && videos.isNotEmpty) {
        for (File video in videos) {
          String videoUrl = await _uploadFile(video, 'incidents/$incidentId/videos');
          videoUrls.add(videoUrl);
        }
      }

      // Upload audio
      if (audio != null) {
        audioUrl = await _uploadFile(audio, 'incidents/$incidentId/audio');
      }

      // Create incident report
      IncidentReport report = IncidentReport(
        id: incidentId,
        reporterId: reporterId,
        reporterName: reporterName,
        title: title,
        description: description,
        type: type,
        latitude: latitude,
        longitude: longitude,
        address: address,
        reportedAt: DateTime.now(),
        status: ReportStatus.pending,
        imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
        videoUrls: videoUrls.isNotEmpty ? videoUrls : null,
        audioUrl: audioUrl,
        severity: severity ?? 3,
      );

      // Save to Firestore
      await _firestore
          .collection('incidents')
          .doc(incidentId)
          .set(report.toJson());

      // Save to local database for offline access
      await _databaseService.insertIncidentReport(report);

      // Send notification to authorities and volunteers
      await _notifyAuthorities(report);

      return incidentId;
    } catch (e) {
      print('Error reporting incident: $e');
      rethrow;
    }
  }

  // Get incidents for a specific user
  Future<List<IncidentReport>> getUserIncidents(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('incidents')
          .where('reporterId', isEqualTo: userId)
          .orderBy('reportedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => IncidentReport.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user incidents: $e');
      return [];
    }
  }

  // Get all incidents (for authorities)
  Future<List<IncidentReport>> getAllIncidents() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('incidents')
          .orderBy('reportedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => IncidentReport.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all incidents: $e');
      return [];
    }
  }

  // Get incidents by status
  Future<List<IncidentReport>> getIncidentsByStatus(ReportStatus status) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('incidents')
          .where('status', isEqualTo: status.name)
          .orderBy('reportedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => IncidentReport.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting incidents by status: $e');
      return [];
    }
  }

  // Update incident status (for authorities)
  Future<void> updateIncidentStatus(
    String incidentId,
    ReportStatus status, {
    String? authorityNotes,
    String? assignedVolunteerId,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status.name,
        'authorityNotes': authorityNotes,
        'assignedVolunteerId': assignedVolunteerId,
      };

      if (status == ReportStatus.resolved) {
        updateData['resolvedAt'] = DateTime.now().toIso8601String();
      }

      await _firestore
          .collection('incidents')
          .doc(incidentId)
          .update(updateData);

      // Update local database
      // Note: In a real app, you'd want to implement proper sync logic
    } catch (e) {
      print('Error updating incident status: $e');
      rethrow;
    }
  }

  // Get nearby incidents
  Future<List<IncidentReport>> getNearbyIncidents(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      // This is a simplified implementation
      // In a real app, you'd use Firestore's GeoPoint and geohashing
      List<IncidentReport> allIncidents = await getAllIncidents();
      
      return allIncidents.where((incident) {
        double distance = LocationService.calculateDistance(
          latitude,
          longitude,
          incident.latitude,
          incident.longitude,
        );
        return distance <= (radiusInKm * 1000); // Convert km to meters
      }).toList();
    } catch (e) {
      print('Error getting nearby incidents: $e');
      return [];
    }
  }

  // Upload file to Firebase Storage
  Future<String> _uploadFile(File file, String path) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      Reference ref = _storage.ref().child('$path/$fileName');
      
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  // Notify authorities about new incident
  Future<void> _notifyAuthorities(IncidentReport report) async {
    try {
      // Send notification to authorities
      await _firestore.collection('notifications').add({
        'type': 'new_incident',
        'incidentId': report.id,
        'title': 'New Incident Reported',
        'body': '${report.reporterName} reported a ${report.type.name} incident',
        'timestamp': DateTime.now().toIso8601String(),
        'recipients': ['authorities'], // In real app, get actual authority IDs
        'data': report.toJson(),
      });
    } catch (e) {
      print('Error notifying authorities: $e');
    }
  }

  // Pick images from gallery or camera
  Future<List<File>> pickImages({bool fromCamera = false}) async {
    try {
      ImagePicker picker = ImagePicker();
      List<XFile> pickedFiles = await picker.pickMultiImage();
      
      if (pickedFiles.isEmpty) return [];
      
      return pickedFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Error picking images: $e');
      return [];
    }
  }

  // Pick video from gallery or camera
  Future<File?> pickVideo({bool fromCamera = false}) async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickVideo(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      
      if (pickedFile == null) return null;
      
      return File(pickedFile.path);
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  // Delete incident (for authorities)
  Future<void> deleteIncident(String incidentId) async {
    try {
      await _firestore.collection('incidents').doc(incidentId).delete();
      
      // Delete associated files from storage
      await _deleteIncidentFiles(incidentId);
    } catch (e) {
      print('Error deleting incident: $e');
      rethrow;
    }
  }

  // Delete incident files from storage
  Future<void> _deleteIncidentFiles(String incidentId) async {
    try {
      Reference folderRef = _storage.ref().child('incidents/$incidentId');
      ListResult result = await folderRef.listAll();
      
      for (Reference ref in result.items) {
        await ref.delete();
      }
      
      for (Reference ref in result.prefixes) {
        await _deleteIncidentFiles('$incidentId/${ref.name}');
      }
    } catch (e) {
      print('Error deleting incident files: $e');
    }
  }
} 