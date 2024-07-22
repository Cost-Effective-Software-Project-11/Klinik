import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/routes/app_routes.dart';
import '../../../repos/authentication/authentication_repository.dart';
import 'bloc/login_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) =>
          LoginBloc(authenticationRepository: authenticationRepository),
      child: const _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isForgotPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          centerTitle: true,
          elevation: 0,
          title: Text(AppLocale.of(context)!.login,
              style: const TextStyle(
                color: Color(0xFF1D1B20),
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0.06,
              )),
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.status == StatusEnum.success) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else if (state.status == StatusEnum.failure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Login Failed')));
                  }
                },
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: context.setHeight(2)),
                          _emailTextFormField(),
                          SizedBox(height: context.setHeight(2)),
                          _passwordTextFormField(),
                          _forgotPasswordButton(context),
                          SizedBox(height: context.setHeight(2)),
                          _rememberMeField(),
                          SizedBox(height: context.setHeight(2)),
                          _buildLoginButton(),
                          SizedBox(height: context.setHeight(2)),
                          _lineDivider(),
                          SizedBox(height: context.setHeight(2)),
                          _buildGogleLoginButton(),
                          SizedBox(height: context.setHeight(2)),
                          _signupRow(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _emailTextFormField() {
    return TextFormField(
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
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocale.of(context)!.emailTextError;
        }
        return null;
      },
    );
  }

  Widget _passwordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        hintText: AppLocale.of(context)!.password_placeholder,
        labelText: AppLocale.of(context)!.password,
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
            )),
        suffixIcon: IconButton(
          icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          setState(() {
            _isForgotPasswordVisible = true;
          });
          return AppLocale.of(context)!.passwordTextError;
        }
        return null;
      },
    );
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return Visibility(
        visible: _isForgotPasswordVisible,
        child: Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: SizedBox(
            width: context.setWidth(80),
            child: InkWell(
              onTap: () {
                // Navigate to the ForgotPasswordPage
              },
              child: Text(
                AppLocale.of(context)!.forgotPasswordText,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF6750A4),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status == StatusEnum.inProgress
            ? const CircularProgressIndicator()
            // ignore: sized_box_for_whitespace
            : Container(
                width: context.setWidth(100),
                height: context.setHeight(6),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6750A4),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        letterSpacing: 0.10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: Text(
                    AppLocale.of(context)!.login,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
      },
    );
  }

  Widget _lineDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: context.setWidth(42),
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
          width: context.setWidth(42),
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
    );
  }

  Widget _buildGogleLoginButton() {
    return ElevatedButton(
      iconAlignment: IconAlignment.start,
      onPressed: _submitGoogleForm,
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6750A4),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            height: 1.2,
            letterSpacing: 0.10,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.google,
          ),
          Text(
            AppLocale.of(context)!.login_google,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
          ));
    }
  }

  void _submitGoogleForm() {
    //Google login
  }

  Row _signupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.start);
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Widget _rememberMeField() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Checkbox(
        value: _rememberMe,
        onChanged: (bool? value) {
          setState(() {
            _rememberMe = value!;
          });
        },
      ),
      Text(AppLocale.of(context)!.remember_me,
          style: const TextStyle(
            color: Color(0xFF1D1B20),
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.4,
            letterSpacing: 0.25,
          ))
    ]);
  }
}
