import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/user_model.dart';
import '../services/location_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';
  Map<String, bool> _notificationSettings = {
    'alerts': true,
    'incidents': true,
    'tasks': true,
    'shelters': true,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final isDarkMode = ref.read(isDarkModeProvider);
    final language = ref.read(languageProvider);
    final notifications = ref.read(notificationSettingsProvider);
    
    setState(() {
      _isDarkMode = isDarkMode;
      _selectedLanguage = language;
      _notificationSettings = Map.from(notifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final userProfile = ref.watch(userProfileProvider(user?.uid ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Section
            _buildUserProfileSection(userProfile),
            const SizedBox(height: 24),
            
            // Settings Section
            _buildSettingsSection(),
            const SizedBox(height: 24),
            
            // Notification Settings
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            
            // App Information
            _buildAppInfoSection(),
            const SizedBox(height: 24),
            
            // Emergency Contacts
            _buildEmergencyContacts(),
            const SizedBox(height: 24),
            
            // Account Actions
            _buildAccountActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(AsyncValue<UserModel?> userProfile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 16),
            userProfile.when(
              data: (profile) => Column(
                children: [
                  Text(
                    profile?.name ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile?.email ?? 'user@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRoleColor(profile?.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getRoleColor(profile?.role)),
                    ),
                    child: Text(
                      _getRoleDisplayName(profile?.role),
                      style: TextStyle(
                        color: _getRoleColor(profile?.role),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _editProfile(),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                ref.read(isDarkModeProvider.notifier).state = value;
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            
            // Language Selection
            ListTile(
              title: const Text('Language'),
              subtitle: Text(_getLanguageDisplayName(_selectedLanguage)),
              leading: const Icon(Icons.language),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showLanguageDialog,
            ),
            
            // Location Settings
            ListTile(
              title: const Text('Location Settings'),
              subtitle: const Text('Manage location permissions'),
              leading: const Icon(Icons.location_on),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _manageLocationSettings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Disaster Alerts'),
              subtitle: const Text('Receive alerts for disasters'),
              value: _notificationSettings['alerts'] ?? true,
              onChanged: (value) {
                setState(() {
                  _notificationSettings['alerts'] = value;
                });
                ref.read(notificationSettingsProvider.notifier).state = Map.from(_notificationSettings);
              },
              secondary: const Icon(Icons.warning),
            ),
            
            SwitchListTile(
              title: const Text('Incident Reports'),
              subtitle: const Text('Notifications for new incidents'),
              value: _notificationSettings['incidents'] ?? true,
              onChanged: (value) {
                setState(() {
                  _notificationSettings['incidents'] = value;
                });
                ref.read(notificationSettingsProvider.notifier).state = Map.from(_notificationSettings);
              },
              secondary: const Icon(Icons.report),
            ),
            
            SwitchListTile(
              title: const Text('Volunteer Tasks'),
              subtitle: const Text('Task assignments and updates'),
              value: _notificationSettings['tasks'] ?? true,
              onChanged: (value) {
                setState(() {
                  _notificationSettings['tasks'] = value;
                });
                ref.read(notificationSettingsProvider.notifier).state = Map.from(_notificationSettings);
              },
              secondary: const Icon(Icons.volunteer_activism),
            ),
            
            SwitchListTile(
              title: const Text('Shelter Updates'),
              subtitle: const Text('Shelter status changes'),
              value: _notificationSettings['shelters'] ?? true,
              onChanged: (value) {
                setState(() {
                  _notificationSettings['shelters'] = value;
                });
                ref.read(notificationSettingsProvider.notifier).state = Map.from(_notificationSettings);
              },
              secondary: const Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
              leading: const Icon(Icons.info),
            ),
            
            ListTile(
              title: const Text('About'),
              subtitle: const Text('Disaster Guardian - Emergency Management App'),
              leading: const Icon(Icons.description),
              onTap: _showAboutDialog,
            ),
            
            ListTile(
              title: const Text('Privacy Policy'),
              leading: const Icon(Icons.privacy_tip),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showPrivacyPolicy,
            ),
            
            ListTile(
              title: const Text('Terms of Service'),
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showTermsOfService,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Emergency Contacts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addEmergencyContact,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Emergency contact list would go here
            const ListTile(
              title: Text('Police'),
              subtitle: Text('100'),
              leading: Icon(Icons.local_police, color: Colors.blue),
            ),
            const ListTile(
              title: Text('Fire Department'),
              subtitle: Text('101'),
              leading: Icon(Icons.local_fire_department, color: Colors.red),
            ),
            const ListTile(
              title: Text('Ambulance'),
              subtitle: Text('102'),
              leading: Icon(Icons.medical_services, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListTile(
              title: const Text('Change Password'),
              leading: const Icon(Icons.lock),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _changePassword,
            ),
            
            ListTile(
              title: const Text('Export Data'),
              leading: const Icon(Icons.download),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _exportData,
            ),
            
            ListTile(
              title: const Text('Clear Cache'),
              leading: const Icon(Icons.clear_all),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _clearCache,
            ),
            
            const Divider(),
            
            ListTile(
              title: const Text('Delete Account'),
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole? role) {
    switch (role) {
      case UserRole.citizen:
        return Colors.blue;
      case UserRole.volunteer:
        return Colors.green;
      case UserRole.authority:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(UserRole? role) {
    switch (role) {
      case UserRole.citizen:
        return 'Citizen';
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.authority:
        return 'Authority';
      default:
        return 'Unknown';
    }
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'te':
        return 'తెలుగు (Telugu)';
      case 'ta':
        return 'தமிழ் (Tamil)';
      default:
        return 'English';
    }
  }

  void _editProfile() {
    // Navigate to edit profile screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                ref.read(languageProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('हिंदी (Hindi)'),
              value: 'hi',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                ref.read(languageProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('తెలుగు (Telugu)'),
              value: 'te',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                ref.read(languageProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('தமிழ் (Tamil)'),
              value: 'ta',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                ref.read(languageProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _manageLocationSettings() async {
    await LocationService.openLocationSettings();
  }

  void _addEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: const Text('Emergency contact feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Disaster Guardian'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disaster Guardian is a comprehensive emergency management mobile application designed to help communities prepare for and respond to disasters.'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Real-time disaster alerts'),
            Text('• Incident reporting'),
            Text('• Emergency shelter locations'),
            Text('• Volunteer coordination'),
            Text('• First aid instructions'),
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy content will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text('Terms of service content will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Data export feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Cache cleared successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}