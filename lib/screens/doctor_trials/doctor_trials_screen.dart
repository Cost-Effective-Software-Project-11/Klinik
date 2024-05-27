import 'package:flutter/material.dart';

class DoctorTrialsScreen extends StatelessWidget {
  const DoctorTrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Trials'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('First'),
            Text('Second'),
            Text('Third'),
          ],
        ),
      ),
    );
  }
}