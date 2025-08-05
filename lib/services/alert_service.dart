import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/alert.dart';

class AlertService {
  final _fs = FirebaseFirestore.instance;
  final _cache = Hive.box('alerts');   // open in main()

  /// Live stream combining Firestore & local Hive fallback
  Stream<List<Alert>> get alertStream =>
      _fs.collection('alerts')
         .orderBy('issuedAt', descending: true)
         .snapshots()
         .map((snap) => snap.docs.map((d) => Alert.fromJson(d.data())).toList())
         .handleError((_) async* {
           // On error (offline) yield cached alerts
           final cached = _cache.values.cast<Map>().map(Alert.fromJson).toList();
           yield cached;
         });

  /// Called periodically by background fetch
  Future<void> fetchAndSyncFromImd() async {
    final uri = Uri.parse(
      'https://api.imd.gov.in/public/v1/alerts?state=Andhra%20Pradesh');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body) as List<dynamic>;
      final batch = _fs.batch();
      for (final item in decoded) {
        final alert = Alert.fromJson(item);
        batch.set(_fs.collection('alerts').doc(alert.id), alert.toJson());
        _cache.put(alert.id, alert.toJson());      // update cache
      }
      await batch.commit();
    }
  }
}
