import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double containerWidth = context.widthPercentage(60); // 50% of screen width
    double containerHeight = context.heightPercentage(30); // 30% of screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade600,
        centerTitle: true,
        elevation: 4.00,
      ),
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          color: Colors.blue,
          child: const Center(
            child: Text(
              '50% width, 30% height',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
