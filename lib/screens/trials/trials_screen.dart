import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/trials/repository/trials_repository.dart';
import 'package:iconly/iconly.dart';
import '../../locale/l10n/app_locale.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;
import '../Trial_Details/trial_details_screen.dart';
import 'bloc/trials_bloc.dart';
import 'create_trials/create_trials_screen.dart';
import 'models/trial_model.dart';

class TrialsScreenWrapper extends StatelessWidget {
  const TrialsScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrialBloc(TrialRepository())..add(FetchTrials()),
      child: const TrialsScreen(),
    );
  }
}

class TrialsScreen extends StatefulWidget {
  const TrialsScreen({super.key});

  @override
  _TrialsScreenState createState() => _TrialsScreenState();
}

class _TrialsScreenState extends State<TrialsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trials'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          backgroundDecoration(),
          SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1)),
                  child: searchAndFilterSection(context),
                ),
                // Trial list with Tab section
                Expanded(
                  child: BlocBuilder<TrialBloc, TrialState>(
                    builder: (context, state) {
                      if (state is TrialLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TrialFormError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is TrialsLoaded) {
                        final unpublishedTrials = state.trials.where((trial) => !trial.isPublished).toList();
                        final publishedTrials = state.trials.where((trial) => trial.isPublished).toList();
                        final doctorId = getLoggedInDoctorId();
                        final myTrials = state.trials.where((trial) => trial.doctorId == doctorId).toList();

                        return Column(
                          children: [
                            Expanded(
                              child: tabSection(context, unpublishedTrials, publishedTrials, myTrials),
                            ),
                            createNewTrialButton(context), // Custom create button
                          ],
                        );
                      }
                      return const Center(child: Text('No trials available'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 0),
    );
  }

  Widget searchAndFilterSection(BuildContext context) {
    return Container(
      width: context.setWidth(90),
      height: context.setHeight(6),
      margin: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1)),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6F0),
        borderRadius: BorderRadius.circular(context.setWidth(8)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(IconlyBold.filter_2, color: const Color(0xFF49454F), size: context.setWidth(6)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocale.of(context)!.clearFiltersTitle),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocale.of(context)!.clearAll),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocale.of(context)!.confirm),
                                content: Text(AppLocale.of(context)!.clearAllFiltersConfirmation),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocale.of(context)!.yes),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.read<TrialBloc>().add(ClearsFilters());
                                      searchController.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(AppLocale.of(context)!.no),
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
                        child: Text(AppLocale.of(context)!.close),
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
                    hintText: 'Search Trials',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: const Color(0x6649454F),
                      fontSize: context.setWidth(5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<TrialBloc>().add(UpdateTrialSearchQuery(value.trim()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF49454F), size: context.setWidth(6)),
                  onPressed: () {
                    context.read<TrialBloc>().add(UpdateTrialSearchQuery(searchController.text.trim()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Tab section for switching between Browse and My Trials
  Widget tabSection(BuildContext context, List<Trial> unpublishedTrials, List<Trial> publishedTrials, List<Trial> myTrials) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF6750A4),
                  width: context.setWidth(0.7),
                ),
              ),
            ),
            labelColor: const Color(0xFF1D1B20),
            unselectedLabelColor: const Color(0xFF49454F),
            labelStyle: TextStyle(
              fontSize: context.setWidth(5),
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Browse'),
              Tab(text: 'My Trials'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Browse Tab (shows unpublished and published trials)
                buildBrowseView(context, unpublishedTrials, publishedTrials),
                // My Trials Tab (shows only the trials created by the doctor)
                buildMyTrialsView(context, myTrials),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Browse view shows both published and unpublished trials
  Widget buildBrowseView(BuildContext context, List<Trial> unpublishedTrials, List<Trial> publishedTrials) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Unpublished Trials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        for (var trial in unpublishedTrials) buildTrialCard(context, trial, false),
        const SizedBox(height: 16),
        const Text('Published Trials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        for (var trial in publishedTrials) buildTrialCard(context, trial, true),
      ],
    );
  }

  // My Trials view shows only the logged-in doctor's trials
  Widget buildMyTrialsView(BuildContext context, List<Trial> myTrials) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('My Trials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        for (var trial in myTrials) buildTrialCard(context, trial, trial.isPublished),
      ],
    );
  }

  Widget buildTrialCard(BuildContext context, Trial trial, bool isPublished) {
    return GestureDetector(
      onTap : () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TrialDetailsScreen(trial: trial,)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trial.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(trial.description),
              const SizedBox(height: 8),
              if (!isPublished)
                ElevatedButton(
                  onPressed: () {
                    print("Publish button clicked for ${trial.title}");
                  },
                  child: const Text('Publish'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Create New Trial Button
  Widget createNewTrialButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateTrialScreen()));
      },
      child: Container(
        width: 180,
        height: 90,
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 4),
        decoration: const ShapeDecoration(
          color: Color(0xE5FEF7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200),
              topRight: Radius.circular(200),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 8,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: ShapeDecoration(
                color: const Color(0xFF6750A4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Create New Trial',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Background decoration (reused from HomeScreen)
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

  // Mock function to get the logged-in doctor's ID
  String getLoggedInDoctorId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is logged in');
    }
  }
}
