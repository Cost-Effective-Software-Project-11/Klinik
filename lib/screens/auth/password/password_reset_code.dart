import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';

class ResetPasswordCode extends StatefulWidget {
  const ResetPasswordCode({super.key});

  @override
  State<ResetPasswordCode> createState() => _ResetPasswordCodeState();
}

class _ResetPasswordCodeState extends State<ResetPasswordCode> {
  @override
  Widget build(BuildContext context) {
    String passwordReset = AppLocale.of(context)!.password_reset;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          centerTitle: true,
          elevation: 0,
          title: Text(
            passwordReset,
            style: const TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 22,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
        body: Container(
            width: context.setWidth(100),
            height: context.setHeight(100),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.34, -0.94),
                end: Alignment(-0.34, 0.94),
                colors: [
                  Color(0x7FFEF7FF),
                  Color(0xFFD5EAE9),
                  Color(0xFFA1D2CE)
                ],
              ),
            ),
            child: const Column()));
  }
}
