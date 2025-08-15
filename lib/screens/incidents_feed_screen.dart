import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/incident_report.dart';

class IncidentsFeedScreen extends ConsumerStatefulWidget {
  const IncidentsFeedScreen({super.key});

  @override
  ConsumerState<IncidentsFeedScreen> createState() => _IncidentsFeedScreenState();
}

class _IncidentsFeedScreenState extends ConsumerState<IncidentsFeedScreen> {
  String _query = '';
  IncidentType? _typeFilter;
  ReportStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final asyncIncidents = ref.watch(allIncidentsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Incidents'),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by title or description',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: asyncIncidents.when(
              data: (items) {
                final filtered = items.where((i) {
                  final matchesQuery = _query.isEmpty ||
                      i.title.toLowerCase().contains(_query) ||
                      i.description.toLowerCase().contains(_query);
                  final matchesType = _typeFilter == null || i.type == _typeFilter;
                  final matchesStatus = _statusFilter == null || i.status == _statusFilter;
                  return matchesQuery && matchesType && matchesStatus;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No incidents found'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) => _buildIncidentTile(filtered[idx]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentTile(IncidentReport r) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(_typeIcon(r.type), color: _statusColor(r.status)),
        title: Text(r.title),
        subtitle: Text('${r.type.name.toUpperCase()} • ${r.status.name} • ${r.address}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showIncidentDetails(r),
      ),
    );
  }

  void _showIncidentDetails(IncidentReport r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  Icon(_typeIcon(r.type), color: _statusColor(r.status)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(r.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(r.description),
              const SizedBox(height: 8),
              Text('Status: ${r.status.name}'),
              Text('Severity: ${r.severity ?? 0}'),
              Text('Reported: ${r.reportedAt}'),
              Text('Location: ${r.latitude.toStringAsFixed(5)}, ${r.longitude.toStringAsFixed(5)}'),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilters() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<IncidentType?>
              (
              value: _typeFilter,
              items: [
                const DropdownMenuItem(value: null, child: Text('All types')),
                ...IncidentType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase())))
              ],
              onChanged: (v) => setState(() => _typeFilter = v),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Type'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ReportStatus?>
              (
              value: _statusFilter,
              items: [
                const DropdownMenuItem(value: null, child: Text('All status')),
                ...ReportStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
              ],
              onChanged: (v) => setState(() => _statusFilter = v),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  IconData _typeIcon(IncidentType t) {
    switch (t) {
      case IncidentType.flood: return Icons.water;
      case IncidentType.earthquake: return Icons.vibration;
      case IncidentType.fire: return Icons.local_fire_department;
      case IncidentType.cyclone: return Icons.air;
      case IncidentType.medical: return Icons.medical_services;
      case IncidentType.accident: return Icons.car_crash;
      case IncidentType.landslide: return Icons.terrain;
      case IncidentType.other: return Icons.report_problem;
    }
  }

  Color _statusColor(ReportStatus s) {
    switch (s) {
      case ReportStatus.pending: return Colors.orange;
      case ReportStatus.inProgress: return Colors.blue;
      case ReportStatus.verified: return Colors.purple;
      case ReportStatus.resolved: return Colors.green;
      case ReportStatus.falseAlarm: return Colors.grey;
    }
  }
} 