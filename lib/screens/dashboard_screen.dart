import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers.dart';
import '../models/user_model.dart';
import '../alert.dart';
import 'alerts_screen.dart';
import 'first_aid_screen.dart';
import 'instructions_screen.dart';
import 'map_screen.dart';
import 'incident_report_screen.dart';
import 'volunteer_screen.dart';
import 'profile_screen.dart';
import 'shelter_screen.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import 'incidents_feed_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  Future<void> _handleSOS() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 SOS EMERGENCY'),
        content: const Text(
          'Are you sure you want to send an SOS alert? This will immediately notify emergency services and nearby volunteers.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SEND SOS'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Navigate to incident report screen with SOS mode
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const IncidentReportScreen(isSOSMode: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final userProfile = ref.watch(userProfileProvider(user?.uid ?? ''));
    final alerts = ref.watch(alertsProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Show notification settings or recent notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                await ref.read(authServiceProvider).signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome section
              _buildWelcomeSection(userProfile),
              const SizedBox(height: 24),

              // SOS Emergency Button
              _buildSOSButton(),
              const SizedBox(height: 24),

              // Quick Actions Grid
              _buildQuickActionsGrid(),
              const SizedBox(height: 24),

              // Recent Alerts Section
              _buildRecentAlertsSection(alerts),
              const SizedBox(height: 24),

              // Role-based Features
              _buildRoleBasedFeatures(userProfile),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MapScreen()),
          );
        },
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeSection(AsyncValue<UserModel?> userProfile) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.teal.shade100,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.teal.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      userProfile.when(
                        data: (profile) => Text(
                          profile?.name ?? 'User',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        loading: () => const Text('Loading...'),
                        error: (_, __) => const Text('User'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoadingLocation)
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
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _handleSOS,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(width: 12),
                Text(
                  'SOS EMERGENCY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _DashboardCard(
              icon: Icons.report_problem,
              title: 'Report Incident',
              subtitle: 'Report a disaster or emergency',
              color: Colors.orange.shade100,
              iconColor: Colors.orange.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncidentReportScreen()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.map,
              title: 'Live Map',
              subtitle: 'View affected areas & shelters',
              color: Colors.blue.shade100,
              iconColor: Colors.blue.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapScreen()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.warning_amber_rounded,
              title: 'Alerts',
              subtitle: 'View latest disaster alerts',
              color: Colors.red.shade100,
              iconColor: Colors.red.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AlertsScreen()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.article_outlined,
              title: 'Incidents Feed',
              subtitle: 'View public incident reports',
              color: Colors.teal.shade100,
              iconColor: Colors.teal.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncidentsFeedScreen()),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.medical_services_rounded,
              title: 'First Aid',
              subtitle: 'Learn essential first aid steps',
              color: Colors.green.shade100,
              iconColor: Colors.green.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FirstAidScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentAlertsSection(AsyncValue<List<Alert>> alerts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Alerts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        alerts.when(
          data: (alertsList) {
            if (alertsList.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 48),
                        const SizedBox(height: 8),
                        Text('No active alerts'),
                        Text(
                          'All clear in your area',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Card(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alertsList.take(3).length,
                itemBuilder: (context, index) {
                  final alert = alertsList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getSeverityColor(alert.severity),
                      child: Icon(
                        _getAlertIcon(alert.type),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(alert.title),
                    subtitle: Text(
                      alert.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTimeAgo(alert.issuedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AlertsScreen()),
                      );
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text('Error loading alerts'),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBasedFeatures(AsyncValue<UserModel?> userProfile) {
    return userProfile.when(
      data: (profile) {
        if (profile?.role == UserRole.volunteer) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volunteer Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _DashboardCard(
                icon: Icons.volunteer_activism,
                title: 'My Tasks',
                subtitle: 'View assigned volunteer tasks',
                color: Colors.purple.shade100,
                iconColor: Colors.purple.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VolunteerScreen()),
                  );
                },
              ),
            ],
          );
        } else if (profile?.role == UserRole.authority) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authority Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _DashboardCard(
                icon: Icons.admin_panel_settings,
                title: 'Manage Shelters',
                subtitle: 'Update shelter information',
                color: Colors.indigo.shade100,
                iconColor: Colors.indigo.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShelterScreen()),
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
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
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}