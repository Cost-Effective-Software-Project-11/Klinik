import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../home/home_screen.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) => LoginBloc(authenticationRepository: authenticationRepository),
      child: const _LoginScreen(),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: state.isValid
              ? () {
            context.read<LoginBloc>().add(const LoginSubmitted());
          }
              : null,
          child: const Text('Login'),
        );
      },
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen({Key? key}) : super(key: key);

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
        backgroundColor: Colors.white,  // Set background color as needed
        elevation: 0,  // You can remove or adjust shadow
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),  // Adjust the padding as needed
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),  // Adjust the border radius for rounded edges
              child: Image.asset(
                'assets/images/logo.png',
                height: 40,  // Adjust the size as needed
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSuccess) { // Assuming you have an isSuccess status to check
              Navigator.pushReplacement( // Use pushReplacement to avoid going back to login
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('Login Failed:')), // Customize with actual error
                );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: _loginForm(),
            ),
          ),
        ),

      ),
    );
  }

  Form _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          _usernameTextFormField(),
          const SizedBox(height: 20),
          _passwordTextFormField(),
          const SizedBox(height: 20),
          _forgotPassword(),
          const SizedBox(height: 20),
          _loginButton(),
          const SizedBox(height: 20),
          _signupRow(context),
        ],
      ),
    );
  }

  TextFormField _usernameTextFormField() {
    return TextFormField(
      controller: _usernameController, // Consider renaming this controller to _usernameController
      focusNode: _usernameFocusNode, // Consider renaming this focusNode to _usernameFocusNode
      decoration: const InputDecoration(labelText: 'Username'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }


  TextFormField _passwordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {
        // Navigation to forgot password screen
      },
      child: const Text('Forgot Password?'),
    );
  }

  Widget _loginButton() {
    return _LoginButton();
  }

  Row _signupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            // Navigation to registration screen
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(const LoginSubmitted());
    }
  }
}

