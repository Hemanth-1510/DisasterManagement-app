import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../alert.dart';
import '../services/disaster_alert_service.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _selectedSeverity = 'all';
  String _selectedType = 'all';
  bool _showOnlyActive = true;

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Alerts'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(alertsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _buildFilterChips(),
          
          // Alerts list
          Expanded(
            child: alertsAsync.when(
              data: (alerts) {
                final filteredAlerts = _filterAlerts(alerts);
                
                if (filteredAlerts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 64, color: Colors.green),
                        SizedBox(height: 16),
                        Text('No alerts to display'),
                        Text('All clear in your area'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = filteredAlerts[index];
                    return _buildAlertCard(alert);
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
                    Text('Error loading alerts'),
                    Text(error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.refresh(alertsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: Text(_selectedSeverity == 'all' ? 'All Severities' : _selectedSeverity.toUpperCase()),
            selected: _selectedSeverity != 'all',
            onSelected: (selected) {
              setState(() {
                _selectedSeverity = selected ? 'critical' : 'all';
              });
            },
          ),
          FilterChip(
            label: Text(_selectedType == 'all' ? 'All Types' : _selectedType.toUpperCase()),
            selected: _selectedType != 'all',
            onSelected: (selected) {
              setState(() {
                _selectedType = selected ? 'weather' : 'all';
              });
            },
          ),
          FilterChip(
            label: Text(_showOnlyActive ? 'Active Only' : 'All Alerts'),
            selected: _showOnlyActive,
            onSelected: (selected) {
              setState(() {
                _showOnlyActive = selected;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(alert.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getAlertIcon(alert.type),
                    color: _getSeverityColor(alert.severity),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getSeverityColor(alert.severity).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _getSeverityColor(alert.severity)),
                            ),
                            child: Text(
                              alert.severity.toUpperCase(),
                              style: TextStyle(
                                color: _getSeverityColor(alert.severity),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              alert.type.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showAlertOptions(alert),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              alert.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${alert.lat.toStringAsFixed(4)}, ${alert.lng.toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(alert.issuedAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewOnMap(alert),
                    icon: const Icon(Icons.map),
                    label: const Text('View on Map'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _getDirections(alert),
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Alert> _filterAlerts(List<Alert> alerts) {
    return alerts.where((alert) {
      // Filter by severity
      if (_selectedSeverity != 'all' && alert.severity != _selectedSeverity) {
        return false;
      }
      
      // Filter by type
      if (_selectedType != 'all' && alert.type != _selectedType) {
        return false;
      }
      
      // Filter by active status (alerts issued in last 24 hours)
      if (_showOnlyActive) {
        final now = DateTime.now();
        final alertTime = alert.issuedAt;
        final difference = now.difference(alertTime);
        if (difference.inHours > 24) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'advisory':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String type) {
    switch (type.toLowerCase()) {
      case 'flood':
        return Icons.water;
      case 'earthquake':
        return Icons.vibration;
      case 'fire':
        return Icons.local_fire_department;
      case 'cyclone':
        return Icons.air;
      case 'weather':
        return Icons.cloud;
      case 'tsunami':
        return Icons.waves;
      case 'landslide':
        return Icons.terrain;
      default:
        return Icons.warning;
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Alerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Severity filter
            DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Severities')),
                const DropdownMenuItem(value: 'critical', child: Text('Critical')),
                const DropdownMenuItem(value: 'warning', child: Text('Warning')),
                const DropdownMenuItem(value: 'advisory', child: Text('Advisory')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Type filter
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Types')),
                const DropdownMenuItem(value: 'weather', child: Text('Weather')),
                const DropdownMenuItem(value: 'flood', child: Text('Flood')),
                const DropdownMenuItem(value: 'earthquake', child: Text('Earthquake')),
                const DropdownMenuItem(value: 'fire', child: Text('Fire')),
                const DropdownMenuItem(value: 'cyclone', child: Text('Cyclone')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Active only toggle
            SwitchListTile(
              title: const Text('Show Active Only'),
              subtitle: const Text('Alerts from last 24 hours'),
              value: _showOnlyActive,
              onChanged: (value) {
                setState(() {
                  _showOnlyActive = value;
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
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showAlertOptions(Alert alert) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Alert'),
              onTap: () {
                Navigator.pop(context);
                _shareAlert(alert);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Set Reminder'),
              onTap: () {
                Navigator.pop(context);
                _setReminder(alert);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('More Information'),
              onTap: () {
                Navigator.pop(context);
                _showAlertDetails(alert);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewOnMap(Alert alert) {
    // Navigate to map screen with alert location
    Navigator.pop(context);
    // You would navigate to map screen here
  }

  void _getDirections(Alert alert) {
    // Open directions in maps app
    // You would implement directions functionality here
  }

  void _shareAlert(Alert alert) {
    // Share alert information
    // You would implement sharing functionality here
  }

  void _setReminder(Alert alert) {
    // Set reminder for alert
    // You would implement reminder functionality here
  }

  void _showAlertDetails(Alert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.description),
            const SizedBox(height: 16),
            Text('Severity: ${alert.severity.toUpperCase()}'),
            Text('Type: ${alert.type.toUpperCase()}'),
            Text('Issued: ${_formatDateTime(alert.issuedAt)}'),
            Text('Location: ${alert.lat.toStringAsFixed(6)}, ${alert.lng.toStringAsFixed(6)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}