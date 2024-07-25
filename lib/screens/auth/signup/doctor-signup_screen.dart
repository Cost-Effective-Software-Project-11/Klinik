import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';

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
                padding: EdgeInsets.only(top: context.setHeight(5), bottom: context.setHeight(5)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSignUpForm(context),
                      _termsAndPrivacyPolicy(context),
                      _buildSignUpButton(context),
                      _buildOrSeparator(context),
                      _buildGoogleSignUpButton(context),
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
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(2.5), vertical: context.setHeight(1)),
      child: Column(
        children: [
          _backButton(context),
          SizedBox(height: context.setHeight(4)),
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
          icon: Icon(Icons.navigate_before, color: const Color(0xFF1D1B20), size: context.setWidth(8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          'Doctor Sign Up',
          style: TextStyle(
            color: const Color(0xFF1D1B20),
            fontSize: context.setWidth(6),
            fontWeight: FontWeight.w400,
          ),
        ),
        Opacity(
          opacity: 0,
          child: IconButton(
            icon: Icon(Icons.navigate_before, size: context.setWidth(8)),
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
              width: context.setWidth(90),
              height: 60,
              margin: EdgeInsets.only(top: context.setHeight(1)),
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
                    margin: EdgeInsets.only(left: context.setWidth(3)),
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, color: const Color(0xFF49454F), size: context.setWidth(6)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      obscureText: isPassword ? (label == "Password" ? !_passwordVisible : !_confirmPasswordVisible) : false,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: TextStyle(color: const Color(0x6649454F), fontSize: context.setWidth(4)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: context.setHeight(2), horizontal: context.setWidth(3)),
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
              top: context.setHeight(-1.2),
              left: context.setWidth(4),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(1.6)),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF49454F),
                    fontSize: context.setWidth(3.5),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: context.setWidth(5), top: context.setHeight(0.3)),
          child: Text(
            controller.value.text.isEmpty || _validateField(controller.value.text, label) == null ? "" : _validateField(controller.value.text, label)!,
            style: TextStyle(color: Colors.red, fontSize: context.setWidth(3.5)),
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

  Widget _termsAndPrivacyPolicy(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(10), vertical: context.setHeight(1)),
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
                  _updateSubmitButtonState();
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
                style: TextStyle(color: Colors.black, fontSize: context.setWidth(3.5)),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: const Color(0xFF6750A4),
                      fontSize: context.setWidth(3.5),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      _showTermsDialog(context);
                    },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: const Color(0xFF6750A4),
                      fontSize: context.setWidth(3.5),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      _showPrivacyPolicyDialog(context);
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: Container(
            width: context.setWidth(80),
            height: context.setHeight(25),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 4.0,
              radius: const Radius.circular(10),
              child: Padding(
                padding: EdgeInsets.only(right: context.setWidth(2)),
                child: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('By signing up, you agree to the following terms:'),
                      Text('1. Confidentiality: All personal and medical information is stored securely and will not be shared without your consent.'),
                      Text('2. Service Limitations: While we strive to provide accurate medical information, our services do not replace professional medical advice.'),
                      Text('3. Compliance: You agree to comply with local regulations and not use our services for unlawful purposes.'),
                      Text('4. Consent: You consent to receive occasional emails related to your account and health management.'),
                      Text('Please read our complete Terms of Service to understand your rights and obligations.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6750A4),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: context.setWidth(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF6750A4),
                side: BorderSide(color: const Color(0xFF6750A4), width: context.setWidth(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showPrivacyPolicyDialog(context);
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: Container(
            width: context.setWidth(80),
            height: context.setHeight(25),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 4.0,
              radius: const Radius.circular(10),
              child: Padding(
                padding: EdgeInsets.only(right: context.setWidth(2)),
                child: const SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListBody(
                    children: <Widget>[
                      Text('Your privacy is critically important to us.'),
                      Text('We have a few fundamental principles:'),
                      Text('• We don’t ask you for personal information unless we truly need it.'),
                      Text('• We don’t share your personal information except to comply with the law, develop our products, or protect our rights.'),
                      Text('• We don’t store personal information on our servers unless required for the on-going operation of one of our services.'),
                      Text('Please review our complete Privacy Policy to understand how we handle your data.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6750A4),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: context.setWidth(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF6750A4),
                side: BorderSide(color: const Color(0xFF6750A4), width: context.setWidth(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (!_isTermsAccepted) {
                  setState(() {
                    _isTermsAccepted = true;
                    _updateSubmitButtonState();
                  });
                }
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    Color buttonColor = _isFormFilled ? const Color(0xFF6750A4) : Colors.grey;

    return Container(
      width: context.setWidth(80),
      height: 60,
      margin: EdgeInsets.only(
          top: context.setHeight(2.5),
          bottom: context.setHeight(1.25)
      ),
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
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.setWidth(3.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrSeparator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.setHeight(1.25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: context.setWidth(35),
            height: 1,
            color: const Color(0x661D1B20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.setWidth(2)),
            child: Text(
              'OR',
              style: TextStyle(
                color: const Color(0x661D1B20),
                fontSize: context.setWidth(4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: context.setWidth(35),
            height: 1,
            color: const Color(0x661D1B20),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignUpButton(BuildContext context) {
    return Container(
      width: context.setWidth(80),
      height: 60,
      margin: EdgeInsets.only(top: context.setHeight(1.25), bottom: context.setHeight(2.5)),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4),
        borderRadius: BorderRadius.circular(context.setHeight(6.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: context.setWidth(6),
            height: context.setHeight(3),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageUtils.googleLogo),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: context.setWidth(2.5)),
          Text(
            'Sign up with Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setWidth(3.5),
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
      padding: EdgeInsets.only(top: context.setHeight(2)),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
              color: const Color(0xFF1D1B20),
              fontSize: context.setWidth(3.5),
              fontFamily: 'Roboto'
          ),
          children: <TextSpan>[
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: const Color(0xFF6750A4),
                fontSize: context.setWidth(3.5),
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