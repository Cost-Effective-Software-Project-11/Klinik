import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import '../../widgets/bottom_nav_bar.dart' as custom;
import 'create_trials/create_trials_screen.dart';

class TrialsScreenWrapper extends StatefulWidget {
  const TrialsScreenWrapper({super.key});

  @override
  _TrialsScreenWrapperState createState() => _TrialsScreenWrapperState();
}

class _TrialsScreenWrapperState extends State<TrialsScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    return const TrialsScreen();
  }
}

class TrialsScreen extends StatelessWidget {
  const TrialsScreen({super.key});

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
