import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../enums/status_enum.dart';
import '../../../repos/authentication/authentication_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/image_utils.dart';
import 'package:iconly/iconly.dart';

import 'bloc/signup_bloc.dart';

class DoctorSignUpScreen extends StatelessWidget {
  const DoctorSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(
        authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: const DoctorSignUpView(),
    );
  }
}

class DoctorSignUpView extends StatefulWidget {
  const DoctorSignUpView({super.key});

  @override
  _DoctorSignUpViewState createState() => _DoctorSignUpViewState();
}

class _DoctorSignUpViewState extends State<DoctorSignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isTermsAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _workplaceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateSubmitButtonState);
    _emailController.addListener(_updateSubmitButtonState);
    _specialtyController.addListener(_updateSubmitButtonState);
    _workplaceController.addListener(_updateSubmitButtonState);
    _phoneController.addListener(_updateSubmitButtonState);
    _passwordController.addListener(_updateSubmitButtonState);
    _confirmPasswordController.addListener(_updateSubmitButtonState);
  }

  void _updateSubmitButtonState() {
    setState(() {
      _isFormFilled = _validateField(_nameController.text, 'Name') == null &&
          _validateField(_emailController.text, 'Email') == null &&
          _validateField(_specialtyController.text, 'Specialty') == null &&
          _validateField(_workplaceController.text, 'Workplace') == null &&
          _validateField(_phoneController.text, 'Phone') == null &&
          _validateField(_passwordController.text, 'Password') == null &&
          _validateField(_confirmPasswordController.text, 'Confirm Password') == null &&
          _isTermsAccepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == StatusEnum.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state.status == StatusEnum.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signup Failed'))
            );
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFEF7FF),
                  Color(0xFFD5EAE9),
                  Color(0xFFA1D2CE)
                ],
                stops: [0.68, 0.85, 1],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 60, bottom: 60),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSignUpForm(context),
                      _termsAndPrivacyPolicy(),
                      _buildSignUpButton(),
                      _buildOrSeparator(),
                      _buildGoogleSignUpButton(),
                      _loginPrompt(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _backButton(context),
          const SizedBox(height: 20),
          _buildInputField(context, 'Name', Icons.account_circle, 'Enter your name', false, _nameController),
          _buildInputField(context, 'Email', IconlyBold.message, 'Enter your email', false, _emailController),
          _buildInputField(context, 'Specialty', IconlyBold.document, 'Enter your specialty', false, _specialtyController),
          _buildInputField(context, 'Workplace', IconlyBold.bag_2, 'Enter your workplace', false, _workplaceController),
          _buildInputField(context, 'Phone', IconlyBold.calling, 'Enter your phone', false, _phoneController),
          _buildInputField(context, 'Password', IconlyBold.lock, 'Enter your password', true, _passwordController, _togglePasswordVisibility),
          _buildInputField(context, 'Confirm Password', IconlyBold.unlock, 'Confirm your password', true, _confirmPasswordController, _toggleConfirmPasswordVisibility),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.navigate_before, color: Color(0xFF1D1B20), size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text(
          'Doctor Sign Up',
          style: TextStyle(
            color: Color(0xFF1D1B20),
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Opacity(
          opacity: 0,
          child: IconButton(
            icon: Icon(Icons.navigate_before, size: 30),
            onPressed: null,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
      BuildContext context,
      String label,
      IconData icon,
      String placeholder,
      bool isPassword,
      TextEditingController controller,
      [VoidCallback? toggleVisibility]
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: 368,
              height: 58,
              margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Color(0xFF79747E)),
                ),
                color: const Color(0xFFFEF7FF),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, color: const Color(0xFF49454F)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: isPassword ? (label == "Password" ? !_passwordVisible : !_confirmPasswordVisible) : false,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: const TextStyle(color: Color(0x6649454F), fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        suffixIcon: isPassword ? IconButton(
                          icon: Icon(
                              (label == "Password" ? _passwordVisible : _confirmPasswordVisible)
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          onPressed: toggleVisibility,
                          color: const Color(0xFF49454F),
                        ) : null,
                      ),
                      textAlign: TextAlign.left,
                      validator: (value) => _validateField(value, label),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 16,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF49454F),
                    fontSize: 12,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5),
          child: Text(
            controller.value.text.isEmpty || _validateField(controller.value.text, label) == null ? "" : _validateField(controller.value.text, label)!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _confirmPasswordVisible = !_confirmPasswordVisible;
    });
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }

    switch (fieldName) {
      case 'Name':
        if (value.length < 2) {
          return 'Name must be at least 2 characters long';
        }
        break;
      case 'Email':
        final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case 'Phone':
        if (value.length != 10) {
          return 'Phone number must be 10 digits long';
        }
        break;
      case 'Password':
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        break;
      case 'Confirm Password':
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }
        break;
      case 'Specialty':
        if (value.length < 3) {
          return 'Specialty must be at least 3 characters long';
        }
        break;
      case 'Workplace':
        if (value.length < 3) {
          return 'Workplace must be at least 3 characters long';
        }
        break;
    }
    return null;
  }

  Widget _termsAndPrivacyPolicy() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              value: _isTermsAccepted,
              onChanged: (bool? value) {
                setState(() {
                  _isTermsAccepted = value ?? false;
                });
              },
              activeColor: const Color(0xFF6750A4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF6750A4),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                    },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF6750A4),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                    },
                  ),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0,
            child: Transform.scale(
              scale: 1.3,
              child: const Checkbox(
                value: false,
                onChanged: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton() {
    Color buttonColor = _isFormFilled ? const Color(0xFF6750A4) : Colors.grey;

    return Container(
      width: 304,
      height: 52,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: _isFormFilled ? _submitForm : null,
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(width: 140, height: 1, color: const Color(0x661D1B20)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'OR',
              style: TextStyle(
                color: Color(0x661D1B20),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(width: 140, height: 1, color: const Color(0x661D1B20)),
        ],
      ),
    );
  }

  Widget _buildGoogleSignUpButton() {
    return Container(
      width: 304,
      height: 52,
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUtils.googleLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Sign up with Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Color(0xFF1D1B20),
            fontSize: 14,
            fontFamily: 'Roboto'
          ),
          children: <TextSpan>[
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: Color(0xFF6750A4),
              ),
              recognizer: TapGestureRecognizer()..onTap = () {
                Navigator.of(context).pushNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateSubmitButtonState);
    _emailController.removeListener(_updateSubmitButtonState);
    _specialtyController.removeListener(_updateSubmitButtonState);
    _workplaceController.removeListener(_updateSubmitButtonState);
    _phoneController.removeListener(_updateSubmitButtonState);
    _passwordController.removeListener(_updateSubmitButtonState);
    _confirmPasswordController.removeListener(_updateSubmitButtonState);

    _nameController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();
    _workplaceController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _isFormFilled) {
      BlocProvider.of<SignupBloc>(context).add(
          SignupSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            phone: _phoneController.text,
            specialty: _specialtyController.text,
            type: 'Doctor',
            workplace: _workplaceController.text,
          )
      );
    }
  }
}