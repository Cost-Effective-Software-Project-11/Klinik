import 'package:flutter/material.dart';

import '../../locale/l10n/app_locale.dart';
import '../../routes/app_routes.dart';
import '../../utils/image_utils.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

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
              width: 500,
              height: 230,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageUtils.logo4),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(AppLocale.of(context)!.letsGetStarted,
              style: const TextStyle(
                color: Color(0xFF231F20),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
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
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                child: Center(
                  child: Text(AppLocale.of(context)!.login,
                    style: const TextStyle(
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
                  borderRadius: BorderRadius.circular(100),
                  side: const BorderSide(width: 3, color: Color(0xFF6750A4)),
                ),
              ),
              child: MaterialButton(
                onPressed: () => showRegisterAsDialog(context),
                child: Center(
                  child: Text(AppLocale.of(context)!.signup,
                    style: const TextStyle(
                      color: Color(0xFF6750A4),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                child: Text(AppLocale.of(context)!.registerAs,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1D1B20),
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildOptionButton(context, AppLocale.of(context)!.patient, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.signupPatient);
              }),
              const SizedBox(height: 16),
              buildOptionButton(context, AppLocale.of(context)!.doctor, () {
                Navigator.of(context). pop();
                Navigator.of(context).pushNamed(AppRoutes.signupDoctor);
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