import 'package:flutter/material.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Precautions'),
        backgroundColor: Colors.green.shade700,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          '1. Check for injuries.\n'
          '2. Call emergency services if needed.\n'
          '3. Apply basic first aid.\n'
          '4. Stay calm and reassure others.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}