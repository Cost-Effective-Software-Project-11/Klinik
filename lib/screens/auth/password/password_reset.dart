import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isButtonDisabled = _emailController.text.isEmpty;
    });
  }

  Future<void> _submitForm() async {
    String userEmail = _emailController.text.trim();
    _sendCodeToEmail(userEmail);
  }

  Future<void> _sendCodeToEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _returnToLoginScreen();
    } catch (e) {
      _showMessage();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    String passwordReset = AppLocale.of(context)!.password_reset;
    String passwordText1 = AppLocale.of(context)!.password_text_1;
    String passwordText2 = AppLocale.of(context)!.password_text_2;

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
        alignment: Alignment.center,
        width: context.setWidth(100),
        height: context.setHeight(100),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.34, -0.94),
            end: Alignment(-0.34, 0.94),
            colors: [Color(0x7FFEF7FF), Color(0xFFD5EAE9), Color(0xFFA1D2CE)],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: context.setHeight(5)),
              SizedBox(
                width: context.setWidth(80),
                child: Text(
                  passwordText1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: 0.15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.setHeight(5)),
              SizedBox(
                width: context.setWidth(80),
                child: Text(
                  passwordText2,
                  maxLines: 3,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    letterSpacing: 0.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.setHeight(5)),
              _emailTextFormField(),
              SizedBox(height: context.setHeight(2)),
              SizedBox(height: context.setHeight(5)),
              _buildSendCodeButton()
            ],
          )),
        ),
      ),
    );
  }

  Widget _emailTextFormField() {
    return SizedBox(
      width: context.setWidth(80),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email_rounded),
          hintText: AppLocale.of(context)!.email_placeholder,
          labelText: AppLocale.of(context)!.email,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocale.of(context)!.emailTextError;
          }
          return null;
        },
      ),
    );
  }

  void _returnToLoginScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _showMessage() {
    final snackBar = SnackBar(
      content: Text(AppLocale.of(context)!.unexpected_error),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildSendCodeButton() {
    return SizedBox(
      width: context.setWidth(80),
      height: context.setHeight(6),
      child: ElevatedButton(
        onPressed: _isButtonDisabled ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isButtonDisabled ? Colors.grey : const Color(0xFF6750A4),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          AppLocale.of(context)!.sendCode,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
