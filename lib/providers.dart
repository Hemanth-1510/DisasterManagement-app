import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authState,
);

final notificationServiceProvider = Provider<Null>((ref) => null);

final alertsProvider = StreamProvider<List<Alert>>((ref) {
  return FirebaseFirestore.instance
      .collection('alerts')
      .orderBy('issuedAt', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Alert.fromJson(doc.data())).toList());
});
