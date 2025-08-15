import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../alert.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'disaster_alerts',
      'Disaster Alerts',
      channelDescription: 'Notifications for disaster alerts and emergencies',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE53935), // Red color for emergency
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alert_sound.aiff',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  static Future<void> showAlertNotification(Alert alert) async {
    String severity = alert.severity.toUpperCase();
    String title = '🚨 $severity ALERT: ${alert.title}';
    String body = alert.description;
    
    if (body.length > 100) {
      body = '${body.substring(0, 97)}...';
    }

    await showLocalNotification(
      title: title,
      body: body,
      payload: alert.id,
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static Future<void> showSOSNotification({
    required String reporterName,
    required String location,
    required String incidentType,
  }) async {
    const String title = '🚨 SOS EMERGENCY';
    final String body = '$reporterName reported a $incidentType at $location';

    await showLocalNotification(
      title: title,
      body: body,
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static Future<void> showTaskAssignmentNotification({
    required String taskTitle,
    required String location,
  }) async {
    const String title = '📋 New Task Assigned';
    final String body = 'You have been assigned: $taskTitle at $location';

    await showLocalNotification(
      title: title,
      body: body,
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static Future<void> showShelterUpdateNotification({
    required String shelterName,
    required String status,
  }) async {
    const String title = '🏠 Shelter Update';
    final String body = '$shelterName is now $status';

    await showLocalNotification(
      title: title,
      body: body,
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    if (response.payload != null) {
      // Navigate to specific screen based on payload
      print('Notification tapped with payload: ${response.payload}');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');
    
    if (message.notification != null) {
      showLocalNotification(
        title: message.notification!.title ?? 'New Alert',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}');
    // Handle navigation based on message data
  }

  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  
  // Show local notification for background messages
  if (message.notification != null) {
    await NotificationService.showLocalNotification(
      title: message.notification!.title ?? 'New Alert',
      body: message.notification!.body ?? '',
      payload: message.data.toString(),
    );
  }
}

 