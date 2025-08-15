import 'dart:async';
import 'package:flutter/foundation.dart';
import '../alert.dart';
import 'disaster_alert_service.dart';
import 'location_service.dart';
import 'notification_service.dart';

class AlertPollingService {
	AlertPollingService._internal();
	static final AlertPollingService instance = AlertPollingService._internal();

	Timer? _timer;
	final Set<String> _notified = <String>{};

	Duration interval = const Duration(minutes: 15);
	double radiusKm = 50;

	bool get isRunning => _timer != null;

	Future<void> start({Duration? every, double? radiusInKm}) async {
		interval = every ?? interval;
		radiusKm = radiusInKm ?? radiusKm;
		_timer?.cancel();
		await _tick();
		_timer = Timer.periodic(interval, (_) => _tick());
	}

	void stop() {
		_timer?.cancel();
		_timer = null;
	}

	Future<void> _tick() async {
		try {
			final pos = await LocationService.getCurrentLocation();
			if (pos == null) return;

			final service = DisasterAlertService();
			final List<Alert> alerts = await service.fetchAllAlerts(pos.latitude, pos.longitude);

			// Nearby filter
			final List<Alert> nearby = alerts.where((a) {
				final d = LocationService.calculateDistance(pos.latitude, pos.longitude, a.lat, a.lng);
				return d <= radiusKm * 1000.0;
			}).toList();

			if (nearby.isEmpty) return;
			await service.saveAlertsToLocal(nearby);

			for (final a in nearby) {
				final high = a.severity == 'warning' || a.severity == 'critical';
				if (!high) continue;
				if (_notified.contains(a.id)) continue;
				await NotificationService.showAlertNotification(a);
				_notified.add(a.id);
			}

			if (kDebugMode) {
				debugPrint('AlertPollingService: ${nearby.length} nearby alerts processed');
			}
		} catch (e) {
			if (kDebugMode) debugPrint('AlertPollingService error: $e');
		}
	}
} 