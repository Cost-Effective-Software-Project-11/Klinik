import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/enums/status_enum.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/routes/app_routes.dart';
import '../../../repos/authentication/authentication_repository.dart';
import 'bloc/login_bloc.dart';

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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
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
                          SizedBox(height: context.setHeight(2)),
                          _buildLoginButton(),
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
      controller: _usernameController,
      focusNode: _usernameFocusNode,
      decoration: InputDecoration(
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
        labelText: 'Password',
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
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status == StatusEnum.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Login'),
              );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginSubmitted(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    }
  }

  Row _signupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.signup);
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
