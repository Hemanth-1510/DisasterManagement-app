import 'package:flutter/material.dart';
import '../data/disaster_info.dart';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({super.key});

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  String selectedDisaster = 'flood';

  @override
  Widget build(BuildContext context) {
    final instructions = disasterInstructions[selectedDisaster] ?? [];
    final precautions = disasterPrecautions[selectedDisaster] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedDisaster,
              items: disasterInstructions.keys
                  .map((d) => DropdownMenuItem(value: d, child: Text(d.toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => selectedDisaster = v!),
            ),
            const SizedBox(height: 16),
            Text('Precautions:', style: Theme.of(context).textTheme.titleMedium),
            ...precautions.map((p) => Text('• $p')).toList(),
            const SizedBox(height: 24),
            Text('Instructions:', style: Theme.of(context).textTheme.titleMedium),
            ...instructions.map((i) => Text('• $i')).toList(),
          ],
        ),
      ),
    );
  }
}