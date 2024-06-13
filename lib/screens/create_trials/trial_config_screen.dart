import 'package:flutter/material.dart';

class TrialConfigScreen extends StatelessWidget {
  const TrialConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trial Config'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Trial Config'),
          ],
        ),
      ),
    );
  }
}