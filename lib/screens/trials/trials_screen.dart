import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/screens/trials/repository/trials_repository.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;
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

class TrialsScreen extends StatelessWidget {
  const TrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
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
          Positioned.fill(child: backgroundDecoration()),
          BlocBuilder<TrialBloc, TrialState>(
            builder: (context, state) {
              if (state is TrialLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TrialFormError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is TrialsLoaded) {
                final unpublishedTrials = state.trials.where((trial) => !trial.isPublished).toList();
                final publishedTrials = state.trials.where((trial) => trial.isPublished).toList();

                return buildTrialLists(context, unpublishedTrials, publishedTrials);
              }
              return const Center(child: Text('No trials available'));
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
                      print ("publish button clicked");
                    },
                    child: const Text('Publish'),
                  ),
              ],
            ),
          ],
        ),
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
}
