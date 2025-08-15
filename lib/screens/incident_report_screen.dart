import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../providers.dart';
import '../models/incident_report.dart';
import '../services/location_service.dart';
import '../services/incident_service.dart';
import '../services/notification_service.dart';

class IncidentReportScreen extends ConsumerStatefulWidget {
  final bool isSOSMode;

  const IncidentReportScreen({super.key, this.isSOSMode = false});

  @override
  ConsumerState<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends ConsumerState<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  IncidentType _selectedType = IncidentType.other;
  int _severity = 3;
  Position? _currentPosition;
  String _address = '';
  bool _isLoading = false;
  bool _isGettingLocation = false;
  
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  File? _selectedAudio;

  @override
  void initState() {
    super.initState();
    if (widget.isSOSMode) {
      _titleController.text = 'SOS Emergency';
      _severity = 5;
    }
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _isGettingLocation = false;
      });

      // Get address from coordinates
      if (position != null) {
        final address = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        setState(() {
          _address = address ?? 'Unknown location';
        });
      }
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _pickVideos() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideos.add(video);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _pickAudio() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? audio = await picker.pickVideo(source: ImageSource.gallery);
      if (audio != null) {
        setState(() {
          _selectedAudio = audio;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking audio: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeVideo(int index) {
    setState(() {
      _selectedVideos.removeAt(index);
    });
  }

  void _removeAudio() {
    setState(() {
      _selectedAudio = null;
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for location to be determined')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not authenticated');

      final incidentService = ref.read(incidentServiceProvider);
      
      final incidentId = await incidentService.reportIncident(
        reporterId: user.uid,
        reporterName: user.displayName ?? user.email ?? 'Anonymous',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _address,
        images: _selectedImages.isNotEmpty ? _selectedImages : null,
        videos: _selectedVideos.isNotEmpty ? _selectedVideos : null,
        audio: _selectedAudio,
        severity: _severity,
      );

      // Send SOS notification if in SOS mode
      if (widget.isSOSMode) {
        await NotificationService.showSOSNotification(
          reporterName: user.displayName ?? user.email ?? 'Anonymous',
          location: _address,
          incidentType: _selectedType.name,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isSOSMode 
              ? 'SOS alert sent successfully!' 
              : 'Incident reported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSOSMode ? 'SOS Emergency' : 'Report Incident'),
        backgroundColor: widget.isSOSMode ? Colors.red.shade700 : Colors.teal.shade700,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isSOSMode) _buildSOSWarning(),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Incident Type
              DropdownButtonFormField<IncidentType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Incident Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: IncidentType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Severity Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Severity Level: $_severity'),
                  Slider(
                    value: _severity.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _severity.toString(),
                    onChanged: (value) {
                      setState(() {
                        _severity = value.round();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Section
              _buildLocationSection(),
              const SizedBox(height: 16),

              // Media Section
              _buildMediaSection(),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isSOSMode ? Colors.red : Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.isSOSMode ? 'SEND SOS ALERT' : 'Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is an SOS emergency alert. It will immediately notify emergency services and nearby volunteers.',
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (_isGettingLocation)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Getting your location...'),
                ],
              )
            else if (_currentPosition != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coordinates: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                  const SizedBox(height: 4),
                  Text('Address: $_address'),
                ],
              )
            else
              const Text('Location not available'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_library, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                const Text('Media', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            
            // Images
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.photo),
                    label: const Text('Add Photos'),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_selectedImages.length} selected'),
              ],
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          // Thumbnail placeholder for web
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.photo, size: 32),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImages.removeAt(index)),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Videos
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickVideos,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Add Videos'),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_selectedVideos.length} selected'),
              ],
            ),
            if (_selectedVideos.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedVideos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.videocam, size: 32),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedVideos.removeAt(index)),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Audio
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectedAudio == null ? _pickAudio : null,
                    icon: const Icon(Icons.mic),
                    label: Text(_selectedAudio == null ? 'Add Audio' : 'Audio Added'),
                  ),
                ),
                if (_selectedAudio != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _removeAudio,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
} 