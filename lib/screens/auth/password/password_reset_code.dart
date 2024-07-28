import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';

class ResetPasswordCode extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordCode({super.key, required this.email, required this.code});

  @override
  State<ResetPasswordCode> createState() => _ResetPasswordCodeState();
}

class _ResetPasswordCodeState extends State<ResetPasswordCode> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  String get _combinedInput {
    return _controllers.map((controller) => controller.text).join();
  }

  void _handleInputChange() {
    String combined = _combinedInput;
    if (combined.length == 4) {
      print('Complete input: $combined');
    }
  }

  @override
  Widget build(BuildContext context) {
    String passwordReset = AppLocale.of(context)!.password_reset;
    String text1 = AppLocale.of(context)!.code_text_1;
    String text2 = AppLocale.of(context)!.code_text_2;
    String text3 = AppLocale.of(context)!.code_text_3;
    String text4 = AppLocale.of(context)!.code_text_4;
    String text5 = AppLocale.of(context)!.code_text_5;

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
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.34, -0.94),
            end: Alignment(-0.34, 0.94),
            colors: [
              Color(0x7FFEF7FF),
              Color(0xFFD5EAE9),
              Color(0xFFA1D2CE),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: context.setHeight(5),
            ),
            SizedBox(
              width: context.setWidth(80),
              child: Text(
                text1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0.06,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            SizedBox(height: context.setHeight(5)),
            SizedBox(
              width: context.setWidth(80),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: text2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          letterSpacing: 0.25,
                        ),
                      ),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          letterSpacing: 0.25,
                        ),
                      ),
                      TextSpan(
                        text: text3,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: context.setHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: index == 0 ? _focusNode : null,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      }
                      _handleInputChange();
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: context.setHeight(5)),
            _buildButton(),
            SizedBox(height: context.setHeight(5)),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: text4,
                    style: const TextStyle(
                      color: Color(0xFF1D1B20),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0.10,
                      letterSpacing: 0.25,
                    ),
                  ),
                  TextSpan(
                    text: text5,
                    style: const TextStyle(
                      color: Color(0xFF6750A4),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0.10,
                      letterSpacing: 0.25,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
        width: context.setWidth(80),
        height: context.setHeight(6),
        child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: Text(
              AppLocale.of(context)!.sendCode,
              style: const TextStyle(color: Colors.white),
            )));
  }
}
