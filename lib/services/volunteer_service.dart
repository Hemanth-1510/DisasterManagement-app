import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/volunteer_task.dart';
import '../models/user_model.dart';

class VolunteerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register as a volunteer
  Future<void> registerVolunteer({
    required String userId,
    required String name,
    required String phone,
    required List<String> skills,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      await _firestore.collection('volunteers').doc(userId).set({
        'userId': userId,
        'name': name,
        'phone': phone,
        'skills': skills,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'isActive': true,
        'registeredAt': DateTime.now().toIso8601String(),
        'lastActive': DateTime.now().toIso8601String(),
        'completedTasks': 0,
        'rating': 0.0,
      });
    } catch (e) {
      print('Error registering volunteer: $e');
      rethrow;
    }
  }

  // Get volunteer profile
  Future<Map<String, dynamic>?> getVolunteerProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('volunteers')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting volunteer profile: $e');
      return null;
    }
  }

  // Update volunteer status
  Future<void> updateVolunteerStatus(String userId, bool isActive) async {
    try {
      await _firestore.collection('volunteers').doc(userId).update({
        'isActive': isActive,
        'lastActive': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating volunteer status: $e');
      rethrow;
    }
  }

  // Get available volunteers
  Future<List<Map<String, dynamic>>> getAvailableVolunteers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('volunteers')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting available volunteers: $e');
      return [];
    }
  }

  // Create a new task
  Future<String> createTask({
    required String title,
    required String description,
    required TaskType type,
    required String incidentReportId,
    required double latitude,
    required double longitude,
    required String address,
    int? priority,
    Map<String, dynamic>? requirements,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection('volunteer_tasks').add({
        'title': title,
        'description': description,
        'type': type.name,
        'incidentReportId': incidentReportId,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'createdAt': DateTime.now().toIso8601String(),
        'status': TaskStatus.pending.name,
        'priority': priority ?? 3,
        'requirements': requirements,
      });

      return docRef.id;
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  // Get tasks for a volunteer
  Future<List<VolunteerTask>> getVolunteerTasks(String volunteerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('volunteer_tasks')
          .where('assignedVolunteerId', isEqualTo: volunteerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VolunteerTask.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting volunteer tasks: $e');
      return [];
    }
  }

  // Get available tasks
  Future<List<VolunteerTask>> getAvailableTasks() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('volunteer_tasks')
          .where('status', isEqualTo: TaskStatus.pending.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VolunteerTask.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting available tasks: $e');
      return [];
    }
  }

  // Assign task to volunteer
  Future<void> assignTaskToVolunteer(
    String taskId,
    String volunteerId,
    String volunteerName,
  ) async {
    try {
      await _firestore.collection('volunteer_tasks').doc(taskId).update({
        'assignedVolunteerId': volunteerId,
        'assignedVolunteerName': volunteerName,
        'assignedAt': DateTime.now().toIso8601String(),
        'status': TaskStatus.assigned.name,
      });
    } catch (e) {
      print('Error assigning task: $e');
      rethrow;
    }
  }

  // Update task status
  Future<void> updateTaskStatus(
    String taskId,
    TaskStatus status, {
    String? notes,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status.name,
      };

      if (status == TaskStatus.inProgress) {
        updateData['startedAt'] = DateTime.now().toIso8601String();
      } else if (status == TaskStatus.completed) {
        updateData['completedAt'] = DateTime.now().toIso8601String();
      }

      if (notes != null) {
        updateData['notes'] = notes;
      }

      await _firestore.collection('volunteer_tasks').doc(taskId).update(updateData);
    } catch (e) {
      print('Error updating task status: $e');
      rethrow;
    }
  }

  // Get nearby volunteers
  Future<List<Map<String, dynamic>>> getNearbyVolunteers(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      List<Map<String, dynamic>> allVolunteers = await getAvailableVolunteers();
      
      return allVolunteers.where((volunteer) {
        double distance = _calculateDistance(
          latitude,
          longitude,
          volunteer['latitude'],
          volunteer['longitude'],
        );
        return distance <= (radiusInKm * 1000); // Convert km to meters
      }).toList();
    } catch (e) {
      print('Error getting nearby volunteers: $e');
      return [];
    }
  }

  // Rate a volunteer
  Future<void> rateVolunteer(
    String volunteerId,
    double rating,
    String feedback,
  ) async {
    try {
      // Get current volunteer data
      DocumentSnapshot doc = await _firestore
          .collection('volunteers')
          .doc(volunteerId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double currentRating = data['rating'] ?? 0.0;
        int totalRatings = data['totalRatings'] ?? 0;

        // Calculate new average rating
        double newRating = ((currentRating * totalRatings) + rating) / (totalRatings + 1);

        await _firestore.collection('volunteers').doc(volunteerId).update({
          'rating': newRating,
          'totalRatings': totalRatings + 1,
        });

        // Add feedback
        await _firestore.collection('volunteer_feedback').add({
          'volunteerId': volunteerId,
          'rating': rating,
          'feedback': feedback,
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error rating volunteer: $e');
      rethrow;
    }
  }

  // Get volunteer statistics
  Future<Map<String, dynamic>> getVolunteerStats(String volunteerId) async {
    try {
      // Get completed tasks count
      QuerySnapshot completedTasks = await _firestore
          .collection('volunteer_tasks')
          .where('assignedVolunteerId', isEqualTo: volunteerId)
          .where('status', isEqualTo: TaskStatus.completed.name)
          .get();

      // Get total tasks count
      QuerySnapshot totalTasks = await _firestore
          .collection('volunteer_tasks')
          .where('assignedVolunteerId', isEqualTo: volunteerId)
          .get();

      // Get volunteer profile
      Map<String, dynamic>? profile = await getVolunteerProfile(volunteerId);

      return {
        'completedTasks': completedTasks.docs.length,
        'totalTasks': totalTasks.docs.length,
        'completionRate': totalTasks.docs.length > 0
            ? (completedTasks.docs.length / totalTasks.docs.length) * 100
            : 0.0,
        'rating': profile?['rating'] ?? 0.0,
        'totalRatings': profile?['totalRatings'] ?? 0,
        'isActive': profile?['isActive'] ?? false,
      };
    } catch (e) {
      print('Error getting volunteer stats: $e');
      return {};
    }
  }

  // Calculate distance between two points
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(_degreesToRadians(lat1)) * sin(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
} 