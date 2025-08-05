import 'package:flutter/material.dart';

class KitScreen extends StatelessWidget {
  const KitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kit')),
      body: const Center(child: Text('Kit Screen')),
    );
  }
}