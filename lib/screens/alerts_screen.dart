import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../alert.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.red.shade700,
      ),
      body: alertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alerts) => alerts.isEmpty
            ? const Center(child: Text('No alerts at this time.'))
            : ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, i) {
                  final alert = alerts[i];
                  return Card(
                    color: Colors.red.shade50,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(alert.description),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(alert.severity.toUpperCase(), style: TextStyle(color: Colors.red.shade700)),
                          Text(alert.type),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}