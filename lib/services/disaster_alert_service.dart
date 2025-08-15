import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../alert.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class DisasterAlertService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _databaseService = DatabaseService();
  
  // OpenWeather API key - replace with your actual API key
  static const String _openWeatherApiKey = 'dd9f8a565f2dc9141086e43988b0863a';
  static const String _openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Government disaster API endpoints (example)
  static const String _disasterApiUrl = 'https://api.example.com/disasters';

  // Fetch weather alerts from OpenWeather API
  Future<List<Alert>> fetchWeatherAlerts(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse('$_openWeatherBaseUrl/onecall?lat=$lat&lon=$lng&exclude=current,minutely,hourly,daily&appid=$_openWeatherApiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Alert> alerts = [];

        // Parse weather alerts
        if (data['alerts'] != null) {
          for (var alertData in data['alerts']) {
            Alert alert = Alert(
              id: 'weather_${DateTime.now().millisecondsSinceEpoch}',
              title: alertData['event'] ?? 'Weather Alert',
              description: alertData['description'] ?? 'Weather condition alert',
              issuedAt: DateTime.fromMillisecondsSinceEpoch(alertData['start'] * 1000),
              severity: _mapWeatherSeverity(alertData['severity']),
              type: 'weather',
              lat: lat,
              lng: lng,
            );
            alerts.add(alert);
          }
        }

        return alerts;
      }
      return [];
    } catch (e) {
      print('Error fetching weather alerts: $e');
      return [];
    }
  }

  // Fetch disaster alerts from government API (example)
  Future<List<Alert>> fetchDisasterAlerts() async {
    try {
      // This is a mock implementation
      // Replace with actual government disaster API integration
      List<Alert> mockAlerts = [
        Alert(
          id: 'flood_001',
          title: 'Flood Warning',
          description: 'Heavy rainfall expected in coastal areas. Risk of flooding in low-lying regions.',
          issuedAt: DateTime.now().subtract(const Duration(hours: 2)),
          severity: 'warning',
          type: 'flood',
          lat: 12.9716,
          lng: 77.5946,
        ),
        Alert(
          id: 'earthquake_001',
          title: 'Earthquake Alert',
          description: 'Seismic activity detected in northern region. Stay alert and follow safety guidelines.',
          issuedAt: DateTime.now().subtract(const Duration(hours: 1)),
          severity: 'advisory',
          type: 'earthquake',
          lat: 28.6139,
          lng: 77.2090,
        ),
        Alert(
          id: 'cyclone_001',
          title: 'Cyclone Warning',
          description: 'Cyclone approaching eastern coast. Evacuation orders in effect for coastal districts.',
          issuedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          severity: 'warning',
          type: 'cyclone',
          lat: 22.5726,
          lng: 88.3639,
        ),
      ];

      return mockAlerts;
    } catch (e) {
      print('Error fetching disaster alerts: $e');
      return [];
    }
  }

  // Fetch all alerts (weather + disaster)
  Future<List<Alert>> fetchAllAlerts(double lat, double lng) async {
    try {
      List<Alert> allAlerts = [];
      
      // Fetch weather alerts
      List<Alert> weatherAlerts = await fetchWeatherAlerts(lat, lng);
      allAlerts.addAll(weatherAlerts);
      
      // Fetch disaster alerts
      List<Alert> disasterAlerts = await fetchDisasterAlerts();
      allAlerts.addAll(disasterAlerts);
      
      // Sort by issued time (newest first)
      allAlerts.sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
      
      return allAlerts;
    } catch (e) {
      print('Error fetching all alerts: $e');
      return [];
    }
  }

  // Save alerts to Firestore
  Future<void> saveAlertsToFirestore(List<Alert> alerts) async {
    try {
      for (Alert alert in alerts) {
        await _firestore
            .collection('alerts')
            .doc(alert.id)
            .set(alert.toJson());
      }
    } catch (e) {
      print('Error saving alerts to Firestore: $e');
    }
  }

  // Save alerts to local database
  Future<void> saveAlertsToLocal(List<Alert> alerts) async {
    try {
      for (Alert alert in alerts) {
        await _databaseService.insertAlert(alert);
      }
    } catch (e) {
      print('Error saving alerts to local database: $e');
    }
  }

  // Get alerts from Firestore
  Future<List<Alert>> getAlertsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('alerts')
          .orderBy('issuedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => Alert.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting alerts from Firestore: $e');
      return [];
    }
  }

  // Get alerts from local database
  Future<List<Alert>> getAlertsFromLocal() async {
    try {
      return await _databaseService.getAlerts();
    } catch (e) {
      print('Error getting alerts from local database: $e');
      return [];
    }
  }

  // Sync alerts between Firestore and local database
  Future<void> syncAlerts() async {
    try {
      // Get alerts from Firestore
      List<Alert> firestoreAlerts = await getAlertsFromFirestore();
      
      // Save to local database
      await saveAlertsToLocal(firestoreAlerts);
      
      print('Synced ${firestoreAlerts.length} alerts to local database');
    } catch (e) {
      print('Error syncing alerts: $e');
    }
  }

  // Send notifications for new alerts
  Future<void> sendAlertNotifications(List<Alert> alerts) async {
    try {
      for (Alert alert in alerts) {
        // Only send notifications for high severity alerts
        if (alert.severity == 'warning' || alert.severity == 'critical') {
          await NotificationService.showAlertNotification(alert);
        }
      }
    } catch (e) {
      print('Error sending alert notifications: $e');
    }
  }

  // Create custom alert (for authorities)
  Future<void> createCustomAlert({
    required String title,
    required String description,
    required String severity,
    required String type,
    required double lat,
    required double lng,
  }) async {
    try {
      Alert alert = Alert(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        issuedAt: DateTime.now(),
        severity: severity,
        type: type,
        lat: lat,
        lng: lng,
      );

      // Save to Firestore
      await _firestore
          .collection('alerts')
          .doc(alert.id)
          .set(alert.toJson());

      // Save to local database
      await _databaseService.insertAlert(alert);

      // Send notification
      await NotificationService.showAlertNotification(alert);
    } catch (e) {
      print('Error creating custom alert: $e');
      rethrow;
    }
  }

  // Delete alert (for authorities)
  Future<void> deleteAlert(String alertId) async {
    try {
      await _firestore.collection('alerts').doc(alertId).delete();
      
      // Note: Local database cleanup would need to be implemented
    } catch (e) {
      print('Error deleting alert: $e');
      rethrow;
    }
  }

  // Map weather severity levels
  String _mapWeatherSeverity(String? weatherSeverity) {
    switch (weatherSeverity?.toLowerCase()) {
      case 'extreme':
        return 'critical';
      case 'severe':
        return 'warning';
      case 'moderate':
        return 'advisory';
      default:
        return 'advisory';
    }
  }

  // Get alerts by type
  Future<List<Alert>> getAlertsByType(String type) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('alerts')
          .where('type', isEqualTo: type)
          .orderBy('issuedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Alert.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting alerts by type: $e');
      return [];
    }
  }

  // Get alerts by severity
  Future<List<Alert>> getAlertsBySeverity(String severity) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('alerts')
          .where('severity', isEqualTo: severity)
          .orderBy('issuedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Alert.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting alerts by severity: $e');
      return [];
    }
  }
} 