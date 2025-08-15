import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'alert.dart';
import 'models/incident_report.dart';
import 'models/volunteer_task.dart';
import 'models/shelter.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/location_service.dart';
import 'services/incident_service.dart';
import 'services/volunteer_service.dart';
import 'services/disaster_alert_service.dart';

// Auth providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authState,
);

// Service providers
final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final incidentServiceProvider = Provider<IncidentService>((ref) => IncidentService());

final volunteerServiceProvider = Provider<VolunteerService>((ref) => VolunteerService());

final disasterAlertServiceProvider = Provider<DisasterAlertService>((ref) => DisasterAlertService());

// Alert providers
final alertsProvider = StreamProvider<List<Alert>>((ref) {
  return FirebaseFirestore.instance
      .collection('alerts')
      .orderBy('issuedAt', descending: true)
      .limit(20)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Alert.fromJson(doc.data())).toList());
});

final localAlertsProvider = FutureProvider<List<Alert>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getAlerts();
});

// Incident report providers
final userIncidentsProvider = FutureProvider.family<List<IncidentReport>, String>((ref, userId) async {
  final incidentService = ref.watch(incidentServiceProvider);
  return await incidentService.getUserIncidents(userId);
});

final allIncidentsProvider = FutureProvider<List<IncidentReport>>((ref) async {
  final incidentService = ref.watch(incidentServiceProvider);
  return await incidentService.getAllIncidents();
});

final allIncidentsStreamProvider = StreamProvider<List<IncidentReport>>((ref) {
  return FirebaseFirestore.instance
      .collection('incidents')
      .orderBy('reportedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => IncidentReport.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
});

final pendingIncidentsProvider = FutureProvider<List<IncidentReport>>((ref) async {
  final incidentService = ref.watch(incidentServiceProvider);
  return await incidentService.getIncidentsByStatus(ReportStatus.pending);
});

// Volunteer task providers
final volunteerTasksProvider = FutureProvider.family<List<VolunteerTask>, String>((ref, volunteerId) async {
  final volunteerService = ref.watch(volunteerServiceProvider);
  return await volunteerService.getVolunteerTasks(volunteerId);
});

final availableTasksProvider = FutureProvider<List<VolunteerTask>>((ref) async {
  final volunteerService = ref.watch(volunteerServiceProvider);
  return await volunteerService.getAvailableTasks();
});

final availableVolunteersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final volunteerService = ref.watch(volunteerServiceProvider);
  return await volunteerService.getAvailableVolunteers();
});

// Shelter providers
final sheltersProvider = StreamProvider<List<Shelter>>((ref) {
  return FirebaseFirestore.instance
      .collection('shelters')
      .orderBy('lastUpdated', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Shelter.fromJson(doc.data())).toList());
});

final localSheltersProvider = FutureProvider<List<Shelter>>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getShelters();
});

// Location providers
final currentLocationProvider = FutureProvider<Position?>((ref) async {
  return await LocationService.getCurrentLocation();
});

// User profile provider
final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  } catch (e) {
    print('Error getting user profile: $e');
    return null;
  }
});

// Connectivity provider
final connectivityProvider = StreamProvider<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 5), (_) {
    // In a real app, you'd use connectivity_plus package
    return true; // Mock implementation
  });
});

// Offline sync provider
final offlineSyncProvider = FutureProvider<void>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  final disasterAlertService = ref.watch(disasterAlertServiceProvider);
  
  // Sync alerts
  await disasterAlertService.syncAlerts();
  
  // Sync other data as needed
  // This would include incidents, shelters, etc.
});

// Emergency SOS provider
final emergencySOSProvider = StateProvider<bool>((ref) => false);

// App theme provider
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// Language provider
final languageProvider = StateProvider<String>((ref) => 'en');

// Notification settings provider
final notificationSettingsProvider = StateProvider<Map<String, bool>>((ref) => {
  'alerts': true,
  'incidents': true,
  'tasks': true,
  'shelters': true,
});
