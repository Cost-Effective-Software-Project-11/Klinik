import 'package:flutter/material.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import '../../locale/l10n/app_locale.dart';
import '../../routes/app_routes.dart';

class RegisterAsDialog extends StatelessWidget {
  const RegisterAsDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 7),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black),
                ),
              ),
              child: Text(
                AppLocale.of(context)!.registerAs,
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
            _buildOptionButton(
              context,
              AppLocale.of(context)!.patient,
                  () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.signup, arguments: UserType.patient);
              },
            ),
            const SizedBox(height: 16),
            _buildOptionButton(
              context,
              AppLocale.of(context)!.doctor,
                  () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.signup, arguments: UserType.doctor);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, VoidCallback onPressed) {
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
}
