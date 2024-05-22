import 'package:flutter/material.dart';
import 'package:flutter_gp5/screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GP5',
      //Remove the debug symbol in the right corner of the app
      debugShowCheckedModeBanner: false,
      //Default color
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade600),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
