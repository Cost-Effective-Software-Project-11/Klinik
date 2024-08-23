import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:iconly/iconly.dart';

import '../../locale/l10n/app_locale.dart';
import '../../repos/authentication/authentication_repository.dart';
import '../../routes/app_routes.dart';
import 'bloc/home_bloc.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) {
        final bloc = HomeBloc();
        bloc.add(const LoadInitialData());
        return bloc;
      },
      child: HomeScreen2View(),
    );
  }
}

class HomeScreen2View extends StatelessWidget {
  HomeScreen2View({super.key});

  final TextEditingController searchController = TextEditingController();

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
                                      // Dispatch ClearFilters event
                                      context.read<HomeBloc>().add(const ClearFilters());
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
                    // Dispatch UpdateSearchText event
                    context.read<HomeBloc>().add(UpdateSearchText(value.trim().toLowerCase()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF49454F)),
                  onPressed: () {
                    // Dispatch UpdateSearchText event
                    context.read<HomeBloc>().add(UpdateSearchText(searchController.text.trim().toLowerCase()));
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButton(
                    context,
                    "Specialization",
                    Icons.add,
                    onTap: () {
                      context.read<HomeBloc>().add(LoadSpecializations()); // Ensure specializations are loaded
                      showSpecializationDialog(context);
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButton(
                    context,
                    "Location",
                    Icons.add,
                    onTap: () {
                      context.read<HomeBloc>().add(LoadCities());
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.setHeight(1)), // Space between buttons and chips
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              specializationChips(context), // Specialization Chips
              locationChips(context),       // Location Chips
            ],
          ),
        ],
      ),
    );
  }

  void showSpecializationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(5)),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8, // Set max height to 80% of the screen height
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: context.setHeight(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                prefixIcon: Icon(Icons.search, color: const Color(0xFF49454F)),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: context.setHeight(1),
                                    horizontal: context.setWidth(4)),
                                hintStyle: TextStyle(
                                  color: const Color(0xFF49454F),
                                  fontSize: context.setWidth(4),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: const Color(0xFF49454F)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(  // Use Expanded to make sure the list of chips is scrollable within the dialog
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: state.specializations.map((specialization) {
                            bool isSelected = state.selectedSpecializations.contains(specialization);
                            return FilterChip(
                              label: Text(
                                specialization,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF6750A4),
                                  fontSize: context.setWidth(3.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                              backgroundColor: const Color(0xFFE8DEF8),
                              selectedColor: const Color(0xFF6750A4),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF6750A4) : const Color(0xFFE8DEF8),
                                ),
                              ),
                              onSelected: (bool selected) {
                                context.read<HomeBloc>().add(ToggleSpecialization(specialization));
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget specializationChips(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.selectedSpecializations.isEmpty) {
          return Container(); // Return an empty container if no specializations are selected
        }
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: state.selectedSpecializations.map((specialization) {
            return Chip(
              label: Text(specialization),
              onDeleted: () {
                context.read<HomeBloc>().add(ToggleSpecialization(specialization));
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget locationChips(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.selectedCities.isEmpty) {
          return Container(); // Return an empty container if no cities are selected
        }
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: state.selectedCities.map((city) {
            return Chip(
              label: Text(city),
              onDeleted: () {
                context.read<HomeBloc>().add(ToggleCity(city));
              },
            );
          }).toList(),
        );
      },
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

  // Widget doctorList(BuildContext context) {
  //   return BlocBuilder<HomeBloc, HomeState>(
  //     builder: (context, state) {
  //       if (state.doctors.isEmpty) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //
  //       return ListView.builder(
  //         itemCount: state.doctors.length,
  //         itemBuilder: (context, index) {
  //           var doc = state.doctors[index];
  //           return Container(
  //             width: MediaQuery.of(context).size.width,
  //             height: MediaQuery.of(context).size.height * 0.15,
  //             decoration: const BoxDecoration(
  //               color: Colors.transparent,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: MediaQuery.of(context).size.height * 0.01,
  //                       horizontal: MediaQuery.of(context).size.width * 0.05,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           width: MediaQuery.of(context).size.width * 0.15,
  //                           height: MediaQuery.of(context).size.width * 0.15,
  //                           decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             image: DecorationImage(
  //                               image: NetworkImage(doc['imageUrl'] ??
  //                                   "https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png"),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: MediaQuery.of(context).size.width * 0.05),
  //                         Expanded(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 doc['name'] ?? 'N/A',
  //                                 style: TextStyle(
  //                                   color: const Color(0xFF6750A4),
  //                                   fontSize: MediaQuery.of(context).size.width * 0.04,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 doc['speciality'] ?? 'N/A',
  //                                 style: TextStyle(
  //                                   fontSize: MediaQuery.of(context).size.width * 0.035,
  //                                   fontWeight: FontWeight.w400,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 'Phone number: ${doc['phone'] ?? 'N/A'}',
  //                                 style: TextStyle(
  //                                   fontSize: MediaQuery.of(context).size.width * 0.03,
  //                                   fontWeight: FontWeight.w400,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
  //                   child: const Divider(
  //                     height: 1,
  //                     thickness: 2,
  //                     color: Color(0xFFCAC4D0),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget doctorList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.filteredDoctors.isEmpty) {
          return const Center(child: Text('No doctors found'));
        }

        return ListView.builder(
          itemCount: state.filteredDoctors.length,
          itemBuilder: (context, index) {
            var doc = state.filteredDoctors[index];
            return doctorCard(context, doc);
          },
        );
      },
    );
  }

  Widget doctorCard(BuildContext context, Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(doctor['imageUrl'] ?? "https://via.placeholder.com/150"),
        ),
        title: Text(doctor['name'] ?? 'Unknown Doctor'),
        subtitle: Text(doctor['speciality'] ?? 'Specialty not available'),
        trailing: Text(doctor['phone'] ?? 'No phone'),
      ),
    );
  }

  // Widget institutionList(BuildContext context) {
  //   return BlocBuilder<HomeBloc, HomeState>(
  //     builder: (context, state) {
  //       if (state.institutions.isEmpty) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //
  //       return ListView.builder(
  //         itemCount: state.institutions.length,
  //         itemBuilder: (context, index) {
  //           var institution = state.institutions[index];
  //           var imageUrl = institution['imageUrl'] ?? "https://png.pngtree.com/png-vector/20231023/ourmid/pngtree-simple-buildings-office-png-image_10312300.png";
  //           var name = institution['name'] ?? "Unknown Institution";
  //           var specialtiesDescription = institution['specialities'] is List
  //               ? (institution['specialities'] as List).join(', ')
  //               : "No Specialties Listed";
  //           var city = institution['city'] ?? "No City Listed";
  //
  //           return Container(
  //             width: MediaQuery.of(context).size.width,
  //             height: MediaQuery.of(context).size.height * 0.15,
  //             decoration: const BoxDecoration(
  //               color: Colors.transparent,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: Padding(
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: MediaQuery.of(context).size.height * 0.01,
  //                       horizontal: MediaQuery.of(context).size.width * 0.05,
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           width: MediaQuery.of(context).size.width * 0.15,
  //                           height: MediaQuery.of(context).size.width * 0.15,
  //                           decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             image: DecorationImage(
  //                               image: NetworkImage(imageUrl),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(width: MediaQuery.of(context).size.width * 0.05),
  //                         Expanded(
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 name,
  //                                 style: TextStyle(
  //                                   color: const Color(0xFF6750A4),
  //                                   fontSize: MediaQuery.of(context).size.width * 0.04,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 city,
  //                                 style: TextStyle(
  //                                   fontSize: MediaQuery.of(context).size.width * 0.035,
  //                                   fontWeight: FontWeight.w400,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 specialtiesDescription,
  //                                 style: TextStyle(
  //                                   fontSize: MediaQuery.of(context).size.width * 0.03,
  //                                   fontWeight: FontWeight.w400,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
  //                   child: const Divider(
  //                     height: 1,
  //                     thickness: 2,
  //                     color: Color(0xFFCAC4D0),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget institutionList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.filteredInstitutions.isEmpty) {
          return const Center(child: Text('No institutions found'));
        }

        return ListView.builder(
          itemCount: state.filteredInstitutions.length,
          itemBuilder: (context, index) {
            var institution = state.filteredInstitutions[index];
            return institutionCard(context, institution);
          },
        );
      },
    );
  }

  Widget institutionCard(BuildContext context, Map<String, dynamic> institution) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(institution['imageUrl'] ?? "https://vfdfdia.placeholder.com/150"),
        ),
        title: Text(institution['name'] ?? 'Unknown Instfditution'),
        subtitle: Text(institution['city'] ?? 'City not available'),
        trailing: Text(institution['specialities']?.join(', ') ?? 'No specialties'),
      ),
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

  void dispose() {
    searchController.dispose();
  }
}