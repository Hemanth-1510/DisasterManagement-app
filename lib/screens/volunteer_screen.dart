import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/volunteer_task.dart';
import '../services/volunteer_service.dart';

class VolunteerScreen extends ConsumerStatefulWidget {
  const VolunteerScreen({super.key});

  @override
  ConsumerState<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends ConsumerState<VolunteerScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to access volunteer features')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Dashboard'),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Colors.teal.shade700,
            child: TabBar(
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'My Tasks'),
                Tab(text: 'Available Tasks'),
                Tab(text: 'Profile'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildMyTasksTab(user.uid),
                _buildAvailableTasksTab(),
                _buildProfileTab(user.uid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTasksTab(String userId) {
    final tasksAsync = ref.watch(volunteerTasksProvider(userId));
    
    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No tasks assigned yet'),
                Text('Check available tasks to get started'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task, true);
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
            Text('Error loading tasks'),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTasksTab() {
    final tasksAsync = ref.watch(availableTasksProvider);
    
    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('No available tasks'),
                Text('All tasks have been assigned'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task, false);
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
            Text('Error loading tasks'),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab(String userId) {
    final statsAsync = ref.watch(volunteerStatsProvider(userId));
    
    return statsAsync.when(
      data: (stats) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(
                          Icons.volunteer_activism,
                          size: 40,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Volunteer Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Thank you for your service!',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      '${stats['completedTasks'] ?? 0}',
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      '${stats['totalTasks'] ?? 0}',
                      Icons.assignment,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Rating
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${(stats['rating'] ?? 0.0).toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('/5'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (stats['rating'] ?? 0.0).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${stats['totalRatings'] ?? 0} ratings',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Status toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Availability',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                            value: stats['isActive'] ?? false,
                            onChanged: (value) {
                              _updateVolunteerStatus(value);
                            },
                          ),
                        ],
                      ),
                      Text(
                        stats['isActive'] ?? false
                            ? 'Available for new tasks'
                            : 'Currently unavailable',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading profile'),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(VolunteerTask task, bool isAssigned) {
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
                  _getTaskTypeIcon(task.type),
                  color: _getTaskTypeColor(task.type),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(task.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    task.address,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.priority_high, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Priority: ${task.priority}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  _formatTimeAgo(task.createdAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (isAssigned && task.status != TaskStatus.completed) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (task.status == TaskStatus.assigned)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateTaskStatus(task.id, TaskStatus.inProgress),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Start Task'),
                      ),
                    ),
                  if (task.status == TaskStatus.inProgress) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateTaskStatus(task.id, TaskStatus.completed),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Complete Task'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showTaskNotesDialog(task),
                        child: const Text('Add Notes'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            if (!isAssigned) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _acceptTask(task),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept Task'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case TaskStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case TaskStatus.assigned:
        color = Colors.blue;
        text = 'Assigned';
        break;
      case TaskStatus.inProgress:
        color = Colors.purple;
        text = 'In Progress';
        break;
      case TaskStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case TaskStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTaskTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.rescue:
        return Icons.emergency;
      case TaskType.medical:
        return Icons.medical_services;
      case TaskType.distribution:
        return Icons.local_shipping;
      case TaskType.communication:
        return Icons.message;
      case TaskType.coordination:
        return Icons.people;
      case TaskType.other:
        return Icons.work;
    }
  }

  Color _getTaskTypeColor(TaskType type) {
    switch (type) {
      case TaskType.rescue:
        return Colors.red;
      case TaskType.medical:
        return Colors.green;
      case TaskType.distribution:
        return Colors.blue;
      case TaskType.communication:
        return Colors.purple;
      case TaskType.coordination:
        return Colors.orange;
      case TaskType.other:
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

  Future<void> _updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final volunteerService = ref.read(volunteerServiceProvider);
      await volunteerService.updateTaskStatus(taskId, status);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task status updated to ${status.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating task status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _acceptTask(VolunteerTask task) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final volunteerService = ref.read(volunteerServiceProvider);
      await volunteerService.assignTaskToVolunteer(
        task.id,
        user.uid,
        user.displayName ?? user.email ?? 'Anonymous',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task accepted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateVolunteerStatus(bool isActive) async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final volunteerService = ref.read(volunteerServiceProvider);
      await volunteerService.updateVolunteerStatus(user.uid, isActive);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isActive ? 'Now available for tasks' : 'Marked as unavailable'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showTaskNotesDialog(VolunteerTask task) {
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task Notes'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (notesController.text.trim().isNotEmpty) {
                await _updateTaskStatus(task.id, task.status);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// Provider for volunteer stats
final volunteerStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, volunteerId) async {
  final volunteerService = ref.watch(volunteerServiceProvider);
  return await volunteerService.getVolunteerStats(volunteerId);
}); 