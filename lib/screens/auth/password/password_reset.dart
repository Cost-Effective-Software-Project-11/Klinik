import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/screens/auth/password/password_reset_code.dart';
import 'package:flutter_gp5/utils/code_generator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final Telephony _telephony = Telephony.instance;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _phoneController.addListener(_validateInputs);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _isButtonDisabled =
          _emailController.text.isEmpty && _phoneController.text.isEmpty;
    });
  }

  Future<void> _submitForm() async {
    String userEmail = _emailController.text.trim();
    String userPhone = _phoneController.text.trim();
    String generatedCode = CodeGenerator().generateCode();
    print(generatedCode);
    if (userEmail.isNotEmpty) {
      await _sendCodeToEmail(userEmail, generatedCode);
    }
    if (userPhone.isNotEmpty) {
      await _sendCodeToPhone(userPhone, generatedCode);
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => EnterCodePage(
              phoneNumber: userPhone,
              code: generatedCode,
            )));
  }

  Future<void> _sendCodeToEmail(String email, String code) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _sendCodeToPhone(String phone, String code) async {
    try {
      await _telephony.sendSms(
        to: phone,
        message: 'Your verification code is: $code',
      );
      print("sended");
    } catch (e) {
      // Handle error
      print("not sended");
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
                  textAlign: TextAlign.justify,
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
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: context.setHeight(5)),
              _emailTextFormField(),
              SizedBox(height: context.setHeight(2)),
              _lineDivider(),
              SizedBox(height: context.setHeight(2)),
              _phoneTextFormField(),
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

  Widget _lineDivider() {
    return SizedBox(
      width: context.setWidth(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.setWidth(35),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0x661D1B20),
                ),
              ),
            ),
          ),
          const Text('OR'),
          Container(
            width: context.setWidth(35),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0x661D1B20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneTextFormField() {
    return SizedBox(
      width: context.setWidth(80),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_in_talk),
          hintText: AppLocale.of(context)!.phone_placeholder,
          labelText: AppLocale.of(context)!.phone,
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
        //keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocale.of(context)!.phoneTextError;
          }
          return null;
        },
      ),
    );
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

class EnterCodePage extends StatelessWidget {
  final String phoneNumber;
  final String code;

  EnterCodePage({super.key, required this.phoneNumber, required this.code});

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String enterCode = "Enter code";
    String codePlaceholder = "Code placeholder";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        centerTitle: true,
        elevation: 0,
        title: Text(
          enterCode,
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
                    enterCode,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      letterSpacing: 0.15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: context.setHeight(5)),
                SizedBox(
                  width: context.setWidth(80),
                  child: TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.code),
                      hintText: codePlaceholder,
                      labelText: "Code",
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
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: context.setHeight(5)),
                _buildVerifyButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return SizedBox(
      width: context.setWidth(80),
      height: context.setHeight(6),
      child: ElevatedButton(
        onPressed: () {
          if (_codeController.text.trim() == code) {
            // Code verified successfully, navigate to reset password page
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ResetPasswordCode(
                      email: '',
                      code: code,
                    )));
          } else {
            // Code verification failed, show error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid code"),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6750A4),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          "verify_code",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
