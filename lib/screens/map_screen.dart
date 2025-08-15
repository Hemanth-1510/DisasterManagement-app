import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../providers.dart';
import '../alert.dart';
import '../models/incident_report.dart';
import '../models/shelter.dart';
import '../services/location_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool _isLoading = true;
  StreamSubscription<Position>? _positionSub;
  
  // Filter options
  bool _showAlerts = true;
  bool _showIncidents = true;
  bool _showShelters = true;
  bool _showUserLocation = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      _syncUserOverlay();
      _startLocationUpdates();
      await _loadMapData();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing map: $e')),
        );
      }
    }
  }

  void _startLocationUpdates() {
    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      _currentPosition = pos;
      if (_showUserLocation) {
        _syncUserOverlay();
      }
    }, onError: (e) {
      debugPrint('Location stream error: $e');
    });
  }

  void _syncUserOverlay() {
    if (_currentPosition == null) return;
    final LatLng me = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    setState(() {
      // Marker
      _markers.removeWhere((m) => m.markerId.value == 'me');
      if (_showUserLocation) {
        _markers.add(
          const Marker(
            markerId: MarkerId('me'),
            // icon default used across platforms; web ignores hue
            position: LatLng(0, 0),
          ),
        );
        // Replace last-added marker's position with current "me"
        _markers = _markers
            .map((m) => m.markerId.value == 'me' ? m.copyWith(positionParam: me) : m)
            .toSet();
      }

      // Accuracy circle
      _circles.removeWhere((c) => c.circleId.value == 'me');
      if (_showUserLocation) {
        _circles.add(
          Circle(
            circleId: const CircleId('me'),
            center: me,
            radius: _currentPosition!.accuracy.isFinite ? _currentPosition!.accuracy : 30,
            fillColor: Colors.blue.withOpacity(0.15),
            strokeColor: Colors.blue.withOpacity(0.4),
            strokeWidth: 1,
          ),
        );
      }
    });
  }

  Future<void> _loadMapData() async {
    await _loadAlerts();
    await _loadIncidents();
    await _loadShelters();
    _updateMarkers();
  }

  Future<void> _loadAlerts() async {
    if (!_showAlerts) return;
    
    try {
      final alerts = await ref.read(disasterAlertServiceProvider).getAlertsFromFirestore();
      for (final alert in alerts) {
        _markers.add(
          Marker(
            markerId: MarkerId('alert_${alert.id}'),
            position: LatLng(alert.lat, alert.lng),
            infoWindow: InfoWindow(
              title: alert.title,
              snippet: alert.description,
            ),
            icon: BitmapDescriptor.defaultMarker,  // Use default on web (hue not supported)
          ),
        );
      }
    } catch (e) {
      print('Error loading alerts: $e');
    }
  }

  Future<void> _loadIncidents() async {
    if (!_showIncidents) return;
    
    try {
      final incidents = await ref.read(incidentServiceProvider).getAllIncidents();
      for (final incident in incidents) {
        _markers.add(
          Marker(
            markerId: MarkerId('incident_${incident.id}'),
            position: LatLng(incident.latitude, incident.longitude),
            infoWindow: InfoWindow(
              title: incident.title,
              snippet: '${incident.type.name} - ${incident.status.name}',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    } catch (e) {
      print('Error loading incidents: $e');
    }
  }

  Future<void> _loadShelters() async {
    if (!_showShelters) return;
    
    try {
      final shelters = await ref.read(sheltersProvider).value ?? [];
      for (final shelter in shelters) {
        _markers.add(
          Marker(
            markerId: MarkerId('shelter_${shelter.id}'),
            position: LatLng(shelter.latitude, shelter.longitude),
            infoWindow: InfoWindow(
              title: shelter.name,
              snippet: '${shelter.type.name} - ${shelter.status.name}',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    } catch (e) {
      print('Error loading shelters: $e');
    }
  }

  void _updateMarkers() {
    setState(() {
      final bool keepUser = _showUserLocation && _currentPosition != null;
      // Save user overlays before clearing
      Marker? userMarker = keepUser
          ? _markers.firstWhere(
              (m) => m.markerId.value == 'me',
              orElse: () => const Marker(markerId: MarkerId('none')),
            )
          : null;
      Circle? userCircle = keepUser
          ? _circles.firstWhere(
              (c) => c.circleId.value == 'me',
              orElse: () => const Circle(circleId: CircleId('none')),
            )
          : null;

      _markers.clear();
      _circles.clear();

      if (keepUser && userMarker != null && userMarker.markerId.value != 'none') {
        _markers.add(userMarker);
      }
      if (keepUser && userCircle != null && userCircle.circleId.value != 'none') {
        _circles.add(userCircle);
      }
    });
    _loadMapData();
  }

  double _getSeverityHue(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return BitmapDescriptor.hueRed;
      case 'warning':
        return BitmapDescriptor.hueOrange;
      case 'advisory':
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 12,
          ),
        ),
      );
    }
  }

  void _goToCurrentLocation() async {
    if (_mapController != null && _currentPosition != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Map'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : const LatLng(20.5937, 78.9629), // India center
              zoom: _currentPosition != null ? 12 : 5,
            ),
            markers: _markers,
            circles: _circles,
            myLocationEnabled: false, // web ignores this; we draw our own
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onTap: (LatLng position) {
              // Handle map tap
            },
          ),
          
          // Current location button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.teal.shade700,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
          
          // Legend
          Positioned(
            top: 16,
            left: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Legend', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_showAlerts) ...[
                      _buildLegendItem('🔴 Critical Alert', Colors.red),
                      _buildLegendItem('🟠 Warning Alert', Colors.orange),
                      _buildLegendItem('🟡 Advisory Alert', Colors.yellow),
                    ],
                    if (_showIncidents) ...[
                      _buildLegendItem('🟠 Incident Report', Colors.orange),
                    ],
                    if (_showShelters) ...[
                      _buildLegendItem('🟢 Shelter', Colors.green),
                    ],
                    if (_showUserLocation) ...[
                      _buildLegendItem('🔵 Your Location', Colors.blue),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Show Alerts'),
              value: _showAlerts,
              onChanged: (value) {
                setState(() {
                  _showAlerts = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Show Incidents'),
              value: _showIncidents,
              onChanged: (value) {
                setState(() {
                  _showIncidents = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Show Shelters'),
              value: _showShelters,
              onChanged: (value) {
                setState(() {
                  _showShelters = value ?? true;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Show My Location'),
              value: _showUserLocation,
              onChanged: (value) {
                setState(() {
                  _showUserLocation = value ?? true;
                  _syncUserOverlay();
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateMarkers();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}