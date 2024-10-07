import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/trials/repository/trials_repository.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;
import 'create_trials/create_trials_screen.dart';
import 'models/trial_model.dart';

class TrialsScreenWrapper extends StatefulWidget {
  const TrialsScreenWrapper({super.key});

  @override
  _TrialsScreenWrapperState createState() => _TrialsScreenWrapperState();
}

class _TrialsScreenWrapperState extends State<TrialsScreenWrapper> {
  List<Trial> unpublishedTrials = [];
  List<Trial> publishedTrials = [];

  @override
  void initState() {
    super.initState();
    fetchTrials();
  }

  Future<void> fetchTrials() async {
    try {
      List<Trial> allTrials = await TrialRepository().fetchTrials(); // Ensure this method exists in your repository
      setState(() {
        unpublishedTrials = allTrials.where((trial) => !trial.isPublished).toList();
        publishedTrials = allTrials.where((trial) => trial.isPublished).toList();
      });
    } catch (e) {
      // Handle error
      print("Error fetching trials: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrialsScreen(
      unpublishedTrials: unpublishedTrials,
      publishedTrials: publishedTrials,
    );
  }
}

class TrialsScreen extends StatelessWidget {
  final List<Trial> unpublishedTrials;
  final List<Trial> publishedTrials;

  const TrialsScreen({super.key, required this.unpublishedTrials, required this.publishedTrials});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.setHeight(7)),
        child: Padding(
          padding: EdgeInsets.only(top: context.setHeight(3)),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1D1B20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Trials',
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
          FutureBuilder<List<Trial>>(
            future: TrialRepository().fetchTrials(),
            builder: (context, snapshot) {
              print('ConnectionState: ${snapshot.connectionState}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('No trials found');
                return const Center(child: Text('No trials available'));
              } else {
                final allTrials = snapshot.data!;
                final unpublishedTrials = allTrials.where((trial) => !trial.isPublished).toList();
                final publishedTrials = allTrials.where((trial) => trial.isPublished).toList();

                return buildTrialLists(context, unpublishedTrials, publishedTrials);
              }
            },
          ),
          Positioned(
            bottom: context.setHeight(0),
            left: MediaQuery.of(context).size.width * 0.5 - 86,
            child: createNewTrialButton(context),
          ),
        ],
      ),
      bottomNavigationBar: const custom.BottomNavigationBar(currentIndex: 0),
    );
  }

  Widget buildTrialLists(BuildContext context, List<Trial> unpublishedTrials, List<Trial> publishedTrials) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unpublished', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var trial in unpublishedTrials) buildTrialCard(context, trial, false),
            const SizedBox(height: 16),
            const Text('Published', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            for (var trial in publishedTrials) buildTrialCard(context, trial, true),
          ],
        ),
      ),
    );
  }

  Widget buildTrialCard(BuildContext context, Trial trial, bool isPublished) {
    return Card(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isPublished)
                  ElevatedButton(
                    onPressed: () async {
                      // Call the publish function
                      await publishTrial(context, trial.id);
                    },
                    child: const Text('Publish'),
                  ),
                if (isPublished)
                  const Text('Published', style: TextStyle(color: Colors.green)),
                ElevatedButton(
                  onPressed: () {
                    // Handle trial preview
                    // e.g. Navigator.of(context).push to trial details page
                  },
                  child: const Text('Preview'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> publishTrial(BuildContext context, String trialId) async {
    try {
      // Call the repository method to publish the trial
      await TrialRepository().publishTrial(trialId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trial published successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to publish trial')),
      );
    }
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
    ));
  }
}
