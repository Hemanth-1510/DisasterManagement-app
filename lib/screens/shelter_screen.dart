import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers.dart';
import '../models/shelter.dart';
import '../services/location_service.dart';

class ShelterScreen extends ConsumerStatefulWidget {
  const ShelterScreen({super.key});

  @override
  ConsumerState<ShelterScreen> createState() => _ShelterScreenState();
}

class _ShelterScreenState extends ConsumerState<ShelterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _capacityController = TextEditingController();
  final _currentOccupancyController = TextEditingController();
  
  ShelterType _selectedType = ShelterType.emergency;
  ShelterStatus _selectedStatus = ShelterStatus.open;
  Position? _currentPosition;
  String _address = '';
  bool _isLoading = false;
  bool _isAddingShelter = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactNumberController.dispose();
    _contactPersonController.dispose();
    _capacityController.dispose();
    _currentOccupancyController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
      });

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
      print('Error getting location: $e');
    }
  }

  void _showAddShelterDialog() {
    _clearForm();
    setState(() {
      _isAddingShelter = true;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Shelter'),
        content: SizedBox(
          width: double.maxFinite,
          child: _buildShelterForm(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isAddingShelter = false;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitShelter,
            child: const Text('Add Shelter'),
          ),
        ],
      ),
    );
  }

  void _showEditShelterDialog(Shelter shelter) {
    _populateForm(shelter);
    setState(() {
      _isAddingShelter = false;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shelter'),
        content: SizedBox(
          width: double.maxFinite,
          child: _buildShelterForm(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _updateShelter(shelter.id),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildShelterForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Shelter Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter shelter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<ShelterType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Shelter Type',
                border: OutlineInputBorder(),
              ),
              items: ShelterType.values.map((type) {
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
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _capacityController,
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _currentOccupancyController,
                    decoration: const InputDecoration(
                      labelText: 'Current Occupancy',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<ShelterStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ShelterStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _contactPersonController,
              decoration: const InputDecoration(
                labelText: 'Contact Person',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Location section
            Card(
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
                    if (_currentPosition != null) ...[
                      Text('Coordinates: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                      const SizedBox(height: 4),
                      Text('Address: $_address'),
                    ] else
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
            ),
          ],
        ),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _contactNumberController.clear();
    _contactPersonController.clear();
    _capacityController.clear();
    _currentOccupancyController.clear();
    _selectedType = ShelterType.emergency;
    _selectedStatus = ShelterStatus.open;
  }

  void _populateForm(Shelter shelter) {
    _nameController.text = shelter.name;
    _descriptionController.text = shelter.description;
    _contactNumberController.text = shelter.contactNumber ?? '';
    _contactPersonController.text = shelter.contactPerson ?? '';
    _capacityController.text = shelter.capacity.toString();
    _currentOccupancyController.text = shelter.currentOccupancy.toString();
    _selectedType = shelter.type;
    _selectedStatus = shelter.status;
  }

  Future<void> _submitShelter() async {
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
      final shelter = Shelter(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _address,
        status: _selectedStatus,
        capacity: int.parse(_capacityController.text),
        currentOccupancy: int.parse(_currentOccupancyController.text),
        contactNumber: _contactNumberController.text.trim().isEmpty ? null : _contactNumberController.text.trim(),
        contactPerson: _contactPersonController.text.trim().isEmpty ? null : _contactPersonController.text.trim(),
        lastUpdated: DateTime.now(),
      );

      // Add to Firestore
      await FirebaseFirestore.instance.collection('shelters').doc(shelter.id).set(shelter.toJson());

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shelter added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding shelter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _isAddingShelter = false;
      });
    }
  }

  Future<void> _updateShelter(String shelterId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final shelter = Shelter(
        id: shelterId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        latitude: _currentPosition?.latitude ?? 0,
        longitude: _currentPosition?.longitude ?? 0,
        address: _address,
        status: _selectedStatus,
        capacity: int.parse(_capacityController.text),
        currentOccupancy: int.parse(_currentOccupancyController.text),
        contactNumber: _contactNumberController.text.trim().isEmpty ? null : _contactNumberController.text.trim(),
        contactPerson: _contactPersonController.text.trim().isEmpty ? null : _contactPersonController.text.trim(),
        lastUpdated: DateTime.now(),
      );

      // Update in Firestore
      await FirebaseFirestore.instance.collection('shelters').doc(shelter.id).update(shelter.toJson());

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shelter updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating shelter: $e'),
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

  Future<void> _deleteShelter(String shelterId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shelter'),
        content: const Text('Are you sure you want to delete this shelter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('shelters').doc(shelterId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shelter deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting shelter: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheltersAsync = ref.watch(sheltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelter Management'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddShelterDialog,
          ),
        ],
      ),
      body: sheltersAsync.when(
        data: (shelters) {
          if (shelters.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No shelters added yet'),
                  Text('Tap the + button to add a new shelter'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shelters.length,
            itemBuilder: (context, index) {
              final shelter = shelters[index];
              return _buildShelterCard(shelter);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading shelters'),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShelterCard(Shelter shelter) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getShelterTypeIcon(shelter.type),
                  color: _getShelterTypeColor(shelter.type),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    shelter.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(shelter.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(shelter.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    shelter.address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${shelter.currentOccupancy}/${shelter.capacity}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(shelter.lastUpdated ?? DateTime.now()),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (shelter.contactNumber != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    shelter.contactNumber!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showEditShelterDialog(shelter),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _deleteShelter(shelter.id),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ShelterStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ShelterStatus.open:
        color = Colors.green;
        text = 'Open';
        break;
      case ShelterStatus.full:
        color = Colors.orange;
        text = 'Full';
        break;
      case ShelterStatus.closed:
        color = Colors.red;
        text = 'Closed';
        break;
      case ShelterStatus.maintenance:
        color = Colors.grey;
        text = 'Maintenance';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  IconData _getShelterTypeIcon(ShelterType type) {
    switch (type) {
      case ShelterType.emergency:
        return Icons.emergency;
      case ShelterType.relief:
        return Icons.local_hospital;
      case ShelterType.medical:
        return Icons.medical_services;
      case ShelterType.food:
        return Icons.restaurant;
      case ShelterType.temporary:
        return Icons.home;
    }
  }

  Color _getShelterTypeColor(ShelterType type) {
    switch (type) {
      case ShelterType.emergency:
        return Colors.red;
      case ShelterType.relief:
        return Colors.blue;
      case ShelterType.medical:
        return Colors.green;
      case ShelterType.food:
        return Colors.orange;
      case ShelterType.temporary:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 