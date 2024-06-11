import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:formz/formz.dart';
import '../../home/home_screen.dart';
import 'bloc/signup_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationRepository = RepositoryProvider.of<AuthenticationRepository>(context);
    return BlocProvider(
      create: (context) => SignupBloc(authenticationRepository: authenticationRepository),
      child: const _SignupScreen(),
    );
  }
}

class _SignupScreen extends StatefulWidget {
  const _SignupScreen({Key? key}) : super(key: key);

  @override
  State<_SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<_SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Screen')),
      body: Padding(
        padding: EdgeInsets.all(context.setHeight(2)),
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (state.status == FormzSubmissionStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Signup Failed')));
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(height: context.setHeight(2)),
                      buildTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                        onChanged: (username) => context.read<SignupBloc>().add(SignupUsernameChanged(username)),
                      ),
                      SizedBox(height: context.setHeight(2)),
                      buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        onChanged: (email) => context.read<SignupBloc>().add(SignupEmailChanged(email)),
                      ),
                      SizedBox(height: context.setHeight(2)),
                      buildTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        onChanged: (password) => context.read<SignupBloc>().add(SignupPasswordChanged(password)),
                      ),
                      SizedBox(height: context.setHeight(2)),
                      buildTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        obscureText: true,
                        onChanged: (confirmPassword) => context.read<SignupBloc>().add(SignupConfirmPasswordChanged(confirmPassword)),
                      ),
                      SizedBox(height: context.setHeight(4)),
                      state.status == FormzSubmissionStatus.inProgress
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: state.isValid ? () => _submitForm(context) : null,
                        child: const Text('Signup'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  void _submitForm(BuildContext context) {
    context.read<SignupBloc>().add(SignupSubmitted());
  }
}