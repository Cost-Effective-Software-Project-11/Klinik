import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        email = userDoc['email'] ?? 'no email';
        name = userDoc['name'] ?? 'no name';
        phone = userDoc['phone'] ?? 'no phone';
        profilePicUrl = userDoc['imageUrl'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profile,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 22,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 0.06,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    break;
                  case 'logout':
                    FirebaseAuth.instance.signOut();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Profile'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.34, -0.94),
              end: Alignment(-0.34, 0.94),
              colors: [Color(0x7FFEF7FF), Color(0xFFD5EAE9), Color(0xFFA1D2CE)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: profilePicUrl.isNotEmpty
                          ? NetworkImage(profilePicUrl)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        // Logic to change the language
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/flags/us.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  style: const TextStyle(
                    color: Color(0xFF49454F),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: name),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(
                    color: Color(0xFF49454F),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: email),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(
                    color: Color(0xFF49454F),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.11,
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phone,
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: phone),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 2));
  }
}
