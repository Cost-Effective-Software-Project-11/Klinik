import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // To ensure the body extends behind the app bar
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the app bar shadow
        centerTitle: true, // Center the title
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'), // Path to your image
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            'There are no doctors available yet',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              color: Colors.grey, // Text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
