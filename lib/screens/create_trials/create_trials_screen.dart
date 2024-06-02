import 'package:flutter/material.dart';

class CreateTrialsScreen extends StatelessWidget {
  const CreateTrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Trials'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade600,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: const Text('Doctor name'),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Trial name'),
                    subtitle: const Text('Trial description'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Generate PDF
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade200,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text('Generate PDF'),
                    ),
                    onTap: () {
                      // Navigate to the trial details screen
                    },
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the create trial screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan.shade200, 
              textStyle: const TextStyle(color: Colors.black),
            ),
            child: const Text('Create a new trial'),
          ),
        ],
      ),
    );
  }
}