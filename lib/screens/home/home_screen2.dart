import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:iconly/iconly.dart';

import '../../locale/l10n/app_locale.dart';
import '../../repos/authentication/authentication_repository.dart';
import '../../routes/app_routes.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  List<String> selectedSpecializations = [];
  List<String> selectedCities = [];
  String searchText = '';
  TextEditingController searchController = TextEditingController();

  void toggleSpecialization(String specialization) {
    setState(() {
      if (selectedSpecializations.contains(specialization)) {
        selectedSpecializations.remove(specialization);
      } else {
        selectedSpecializations.add(specialization);
      }
    });
  }

  void toggleCity(String city) {
    setState(() {
      if (selectedCities.contains(city)) {
        selectedCities.remove(city);
      } else {
        selectedCities.add(city);
      }
    });
  }

  Future<List<String>> fetchDistinctCities() async {
    var snapshot = await FirebaseFirestore.instance.collection('institutions').get();
    return snapshot.docs.map((doc) => doc.data()['city'] as String).toSet().toList();
  }

  Future<void> showCityDialog(BuildContext context) async {
    var cities = await fetchDistinctCities();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select City"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: cities.map((city) {
                bool isSelected = selectedCities.contains(city);
                return FilterChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedCities.add(city);
                      } else {
                        selectedCities.remove(city);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.setHeight(7)),
        child: Padding(
          padding: EdgeInsets.only(top: context.setHeight(3)),
          child: AppBar(
            title: Text(
              'Home',
              style: TextStyle(
                color: const Color(0xFF1D1B20),
                fontSize: context.setWidth(5),
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          backgroundDecoration(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: context.setHeight(0)),
              child: Column(
                children: [
                  staticContent(context),
                  Expanded(
                    child: tabSection(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, authRepo),
    );
  }

  Widget staticContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.setHeight(2), horizontal: context.setWidth(2)),
      child: Column(
        children: [
          searchAndFilterSection(context),
          SizedBox(height: context.setHeight(1)),
          buttonRow(context),
        ],
      ),
    );
  }

  Widget backgroundDecoration() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget searchAndFilterSection(BuildContext context) {
    return Container(
      width: context.setWidth(90),
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1)),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6F0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(IconlyBold.filter_2, color: Color(0xFF49454F)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Filter Options"),
                    content: const Text("You can set your filters or clear all existing ones."),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Clear All"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text("Are you sure you want to clear all filters?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        searchText = '';
                                        searchController.clear();
                                        selectedSpecializations.clear();
                                        selectedCities.clear();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      TextButton(
                        child: const Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Find your doctor',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: const Color(0x6649454F),
                      fontSize: context.setWidth(5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      searchText = value.trim().toLowerCase();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF49454F)),
                  onPressed: () {
                    setState(() {
                      searchText = searchController.text.trim().toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButton(context, "Specialization", Icons.add, onTap: () => showSpecializationDialog(context)),
              specializationChips(context), // Chips are displayed right below the button
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButton(context, "Location", Icons.add, onTap: () => showCityDialog(context)),
              locationChips(context), // Chips are displayed right below the button
            ],
          ),
        ],
      ),
    );
  }


  Future<void> showSpecializationDialog(BuildContext context) async {
    final QuerySnapshot specializationSnapshot = await FirebaseFirestore.instance.collection('specialities').get();
    List<DocumentSnapshot> docs = specializationSnapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Specialization"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: docs.map((doc) {
                bool isSelected = selectedSpecializations.contains(doc['name']);
                return FilterChip(
                  label: Text(doc['name']),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedSpecializations.add(doc['name']);
                      } else {
                        selectedSpecializations.remove(doc['name']);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget specializationChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      direction: Axis.vertical, // Ensure chips are arranged vertically
      children: selectedSpecializations.map((specialization) => Chip(
        label: Text(specialization),
        onDeleted: () => toggleSpecialization(specialization),
      )).toList(),
    );
  }

  Widget locationChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      direction: Axis.vertical, // Ensure chips are arranged vertically
      children: selectedCities.map((city) => Chip(
        label: Text(city),
        onDeleted: () => toggleCity(city),
      )).toList(),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6750A4),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1.5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.setWidth(4),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: context.setWidth(1)),
            Icon(icon, size: context.setWidth(5), color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(color: const Color(0xFF6750A4), width: context.setWidth(0.7))),
            ),
            labelColor: const Color(0xFF1D1B20),
            unselectedLabelColor: const Color(0xFF49454F),
            labelStyle: TextStyle(fontSize: context.setWidth(5), fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: 'Doctors'),
              Tab(text: 'Institutions'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                doctorList(context),
                institutionList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget doctorList(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: getFilteredDoctorsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data ?? [];
        docs = docs.where((doc) {
          var name = doc['name']?.toLowerCase() ?? '';
          return name.contains(searchText);
        }).toList();

        if (docs.isEmpty) {
          return const Center(child: Text("No doctors found"));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index].data() as Map<String, dynamic>;
            return Container(
              width: context.setWidth(100),
              height: context.setHeight(15),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: context.setHeight(1),
                        left: context.setWidth(5),
                        right: context.setWidth(1),
                        bottom: context.setHeight(1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: context.setWidth(15),
                            height: context.setHeight(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(doc['imageUrl'] ?? "https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: context.setWidth(5)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['name'] ?? 'N/A',
                                  style: TextStyle(
                                    color: const Color(0xFF6750A4),
                                    fontSize: context.setWidth(4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  doc['speciality'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: context.setWidth(3),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Phone number: ${doc['phone'] ?? 'N/A'}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: context.setWidth(2.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                    child: const Divider(
                      height: 1,
                      thickness: 2,
                      color: Color(0xFFCAC4D0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Stream<List<QueryDocumentSnapshot>> getFilteredDoctorsStream() async* {
    var query = FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 'Doctor');

    if (selectedSpecializations.isNotEmpty) {
      var result = await query.where('speciality', whereIn: selectedSpecializations).get();
      var filteredDocs = result.docs.where((doc) => selectedCities.isEmpty || selectedCities.contains(doc.data()['city'])).toList();
      yield filteredDocs;
    } else if (selectedCities.isNotEmpty) {
      var result = await query.where('city', whereIn: selectedCities).get();
      yield result.docs;
    } else {
      var result = await query.get();
      yield result.docs;
    }
  }

  Stream<List<QueryDocumentSnapshot>> getFilteredInstitutionsStream() async* {
    var query = FirebaseFirestore.instance.collection('institutions');

    if (selectedSpecializations.isNotEmpty) {
      var result = await query.where('specialities', arrayContainsAny: selectedSpecializations).get();
      var filteredDocs = result.docs.where((doc) => selectedCities.isEmpty || selectedCities.contains(doc.data()['city'])).toList();
      yield filteredDocs;
    } else if (selectedCities.isNotEmpty) {
      var result = await query.where('city', whereIn: selectedCities).get();
      yield result.docs;
    } else {
      var result = await query.get();
      yield result.docs;
    }
  }

  Widget institutionList(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: getFilteredInstitutionsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var docs = snapshot.data ?? [];
        docs = docs.where((doc) {
          var name = doc['name']?.toLowerCase() ?? '';
          return name.contains(searchText);
        }).toList();

        if (docs.isEmpty) {
          return const Center(child: Text("No institutions found"));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var institution = docs[index].data() as Map<String, dynamic>;
            var imageUrl = institution['imageUrl'] ?? "https://png.pngtree.com/png-vector/20231023/ourmid/pngtree-simple-buildings-office-png-image_10312300.png";
            var name = institution['name'] ?? "Unknown Institution";
            var specialitiesDescription = institution['specialities'] is List
                ? (institution['specialities'] as List).join(', ')
                : "No Specialities Listed";
            var city = institution['city'] ?? "No City Listed";

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city,
                                  style: TextStyle(
                                    color: const Color(0xFF6750A4),
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: const Color(0xFF1D1B20),
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  specialitiesDescription,
                                  style: TextStyle(
                                    color: const Color(0xFF49454F),
                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                    child: const Divider(
                      height: 1,
                      thickness: 2,
                      color: Color(0xFFCAC4D0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, AuthenticationRepository authRepo) {
    return Container(
      height: context.setHeight(8),
      decoration: const BoxDecoration(color: Color(0xFFECE6F0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(IconlyBold.paper, "Trials", false, context),
          buildNavItem(IconlyBold.activity, "Data", false, context),
          buildNavItem(IconlyBold.home, "Home", true, context),
          buildNavItem(IconlyBold.message, "Messages", false, context),
          buildNavItem(IconlyBold.profile, "Profile", false, context, onTap: () async {
            try {
              await authRepo.logOut();
              Navigator.pushReplacementNamed(context, AppRoutes.start);
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logout failed: $error")));
            }
          }),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, bool isActive, BuildContext context, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: context.setWidth(7), color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F)),
          SizedBox(height: context.setWidth(1)),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F),
              fontSize: context.setWidth(3),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}