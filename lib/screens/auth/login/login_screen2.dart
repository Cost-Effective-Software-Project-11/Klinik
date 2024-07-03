import 'package:flutter/material.dart';

import '../../../utils/image_utils.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFD5EAE9), Color(0xFFA1D2CE)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 148,
              height: 148,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageUtils.logo),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Container(
              width: 304,
              height: 52,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF6750A4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: MaterialButton(
                onPressed: () => showRegisterAsDialog(context),
                child: const Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 304,
              height: 52,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 3, color: Color(0xFF6750A4)),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF6750A4),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void showRegisterAsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 304,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                child: const Text(
                  'Register as',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildOptionButton(context, 'Patient', () {
                // Handle Patient Registration
                Navigator.of(context).pop();
              }),
              const SizedBox(height: 16),
              buildOptionButton(context, 'Doctor', () {
                // Handle Doctor Registration
                Navigator.of(context). pop();
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildOptionButton(BuildContext context, String title, VoidCallback onPressed) {
  return Container(
    width: 200,
    height: 52,
    decoration: ShapeDecoration(
      color: const Color(0xFF6750A4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}