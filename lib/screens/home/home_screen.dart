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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/home.png'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight + 16, // Position below the app bar
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Find your doctor',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt, color: Colors.grey),
                        onPressed: () {
                          // Handle filter action
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                    //нещо не  промени дизайна май
                    width: 156,
                    height: 40,
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 24,
                      right: 16,
                      bottom: 10,
                    )), // Space between search bar and chips
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ActionChip(
                      label: const Row(
                        children: [
                          Text(
                            'Specialization',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                              letterSpacing: 0.10,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.add, size: 16, color: Colors.white),
                        ],
                      ),
                      onPressed: () {
                        // Handle action for Location
                      },
                      backgroundColor: Colors.purple,
                      labelStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between chips
                    ActionChip(
                      label: const Row(
                        children: [
                          Text(
                            'Location',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 0.10,
                              letterSpacing: 0.10,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.add, size: 16, color: Colors.white),
                        ],
                      ),
                      onPressed: () {
                        // Handle action for Location
                      },
                      backgroundColor: Colors.purple,
                      labelStyle: const TextStyle(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
