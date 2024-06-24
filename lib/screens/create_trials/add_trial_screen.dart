import 'package:flutter/material.dart';

class AddTrialScreen extends StatelessWidget {
  const AddTrialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add trial'),
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