import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../enums/status.dart';
import '../../../enums/user_type.dart';
import '../../../locale/l10n/app_locale.dart';
import '../../../repos/authentication/authentication_repository.dart';
import '../../../routes/app_routes.dart';
import 'package:iconly/iconly.dart';

import 'bloc/signup_bloc.dart';

class SignUpScreen extends StatelessWidget {
  final UserType userType;

  const SignUpScreen({required this.userType, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (context) => SignupBloc(
        authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
      ),
      child: SignUpView(userType: userType),
    );
  }
}

class SignUpView extends StatefulWidget {
  final UserType userType;

  const SignUpView({required this.userType, super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isTermsAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _workplaceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isFormFilled = false;

  String _fullPhoneNumber = '';

  List<String> institutionNames = [];
  String? selectedInstitution = 'Test';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateSubmitButtonState);
    _emailController.addListener(_updateSubmitButtonState);
    _phoneController.addListener(_updateSubmitButtonState);
    _passwordController.addListener(_updateSubmitButtonState);
    _confirmPasswordController.addListener(_updateSubmitButtonState);
    loadInstitutions();

    if (widget.userType == UserType.doctor) {
      _workplaceController.addListener(_updateSubmitButtonState);
    }
  }

  Future<void> loadInstitutions() async {
    var institutions = await FirebaseFirestore.instance.collection('institutions').get();
    var fetchedInstitutions = institutions.docs.map((doc) => doc.data()['name'] as String).toList();
    setState(() {
      institutionNames = fetchedInstitutions;
    });
  }

  void _updateSubmitButtonState() {
    setState(() {
      _isFormFilled = _validateField(_nameController.text, 'Name') == null &&
          _validateField(_emailController.text, 'Email') == null &&
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
          if (state.status == Status.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocale.of(context)!.signupfailure))
            );
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(context.setHeight(7)),
            child: Padding(
              padding: EdgeInsets.only(top: context.setHeight(1), bottom: context.setHeight(1)),
              child: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.navigate_before, color: const Color(0xFF1D1B20), size: context.setWidth(8)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  widget.userType == UserType.doctor
                      ? AppLocale.of(context)!.doctorSignUpTitle
                      : AppLocale.of(context)!.patientSignUpTitle,
                  style: TextStyle(
                    color: const Color(0xFF1D1B20),
                    fontSize: context.setWidth(5),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                actions: <Widget>[
                  Opacity(
                    opacity: 0,
                    child: IconButton(
                      icon: Icon(Icons.navigate_before, size: context.setWidth(8)),
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          _buildInputField(
              context,
              AppLocale.of(context)!.name,
              Icons.account_circle,
              AppLocale.of(context)!.enterYourName,
              false,
              _nameController,
              keyboardType: TextInputType.name
          ),
          _buildInputField(
              context, AppLocale.of(context)!.email,
              IconlyBold.message,
              AppLocale.of(context)!.email_placeholder,
              false,
              _emailController,
              keyboardType: TextInputType.emailAddress
          ),
          if (widget.userType == UserType.doctor) ...[
            _buildInstitutionDropdown(context),
          ],
          _buildPhoneField(context),
          _buildInputField(
              context,
              AppLocale.of(context)!.password,
              IconlyBold.lock,
              AppLocale.of(context)!.password_placeholder,
              true, _passwordController,
              toggleVisibility: _togglePasswordVisibility
          ),
          _buildInputField(
              context,
              AppLocale.of(context)!.confirm_password,
              IconlyBold.unlock,
              AppLocale.of(context)!.confirmYourPassword,
              true,
              _confirmPasswordController,
              toggleVisibility: _toggleConfirmPasswordVisibility),
        ],
      ),
    );
  }

  Widget _buildInputField(
      BuildContext context,
      String label,
      IconData icon,
      String placeholder,
      bool isPassword,
      TextEditingController controller, {
        VoidCallback? toggleVisibility,
        TextInputType keyboardType = TextInputType.text,
      }
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
                      obscureText: isPassword ? (label == AppLocale.of(context)!.password ? !_passwordVisible : !_confirmPasswordVisible) : false,
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: TextStyle(color: const Color(0x6649454F), fontSize: context.setWidth(4)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: context.setHeight(2), horizontal: context.setWidth(3)),
                        suffixIcon: isPassword ? IconButton(
                          icon: Icon(
                              (label == AppLocale.of(context)!.password ? _passwordVisible : _confirmPasswordVisible)
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          onPressed: toggleVisibility,
                          color: const Color(0xFF49454F),
                        ) : null,
                      ),
                      textAlign: TextAlign.left,
                      validator: (value) => _validateField(value, label),
                      onFieldSubmitted: (value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      keyboardType: keyboardType,
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
        if (value.length > 16) {
          return 'Phone number can be maximum 16 digits long';
        }
        break;
      case 'Password':
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        break;
      case 'Confirm Password':
        if (_passwordController.text != value) {
          return 'Passwords do not match';
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
                  TextSpan(text: '${AppLocale.of(context)!.agreeToTerms} '),
                  TextSpan(
                    text: '${AppLocale.of(context)!.termsOfService} ',
                    style: TextStyle(
                      color: const Color(0xFF6750A4),
                      fontSize: context.setWidth(3.5),
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      _showTermsDialog(context);
                    },
                  ),
                  TextSpan(text: '${AppLocale.of(context)!.and} '),
                  TextSpan(
                    text: '${AppLocale.of(context)!.privacyPolicy} ',
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

  Widget _buildPhoneField(BuildContext context) {
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
                  Expanded(
                    child: IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: AppLocale.of(context)!.enterYourPhone,
                        hintStyle: TextStyle(color: const Color(0x6649454F), fontSize: context.setWidth(4)),
                        border: InputBorder.none,
                        counter: const SizedBox.shrink(),

                      ),
                      initialCountryCode: 'BG',
                      dropdownIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF49454F)),
                      dropdownTextStyle: TextStyle(fontSize: context.setWidth(4), color: const Color(0xFF49454F)),
                      controller: _phoneController,
                      onChanged: (phone) {
                        _fullPhoneNumber = phone.completeNumber;
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        return _validateField(value as String?, 'Phone');
                      },
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
                  'Phone',
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
            _phoneController.value.text.isEmpty || _validateField(_phoneController.value.text, 'Phone') == null ? "" :
            _validateField(_phoneController.value.text, 'Phone')!,
            style: TextStyle(color: Colors.red, fontSize: context.setWidth(3.5)),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocale.of(context)!.termsOfService),
          content: Container(
            width: context.setWidth(80),
            height: context.setHeight(25),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 4.0,
              radius: const Radius.circular(10),
              child: Padding(
                padding: EdgeInsets.only(right: context.setWidth(2)),
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(AppLocale.of(context)!.signupAgreement),
                      Text(AppLocale.of(context)!.termsConfidentiality),
                      Text(AppLocale.of(context)!.termsServiceLimitations),
                      Text(AppLocale.of(context)!.termsCompliance),
                      Text(AppLocale.of(context)!.termsConsent),
                      Text(AppLocale.of(context)!.termsReadComplete),
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
              child: Text(AppLocale.of(context)!.close),
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
              child: Text(AppLocale.of(context)!.next),
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
          title: Text(AppLocale.of(context)!.privacyPolicy),
          content: Container(
            width: context.setWidth(80),
            height: context.setHeight(25),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 4.0,
              radius: const Radius.circular(10),
              child: Padding(
                padding: EdgeInsets.only(right: context.setWidth(2)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListBody(
                    children: <Widget>[
                      Text(AppLocale.of(context)!.privacyIsImportant),
                      Text(AppLocale.of(context)!.privacyPrinciples),
                      Text(AppLocale.of(context)!.privacyNeedInfo),
                      Text(AppLocale.of(context)!.privacyShareInfo),
                      Text(AppLocale.of(context)!.privacyStoreInfo),
                      Text(AppLocale.of(context)!.privacyReview),
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
              child: Text(AppLocale.of(context)!.close),
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
              child: Text(AppLocale.of(context)!.accept),
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
          AppLocale.of(context)!.signup,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.setWidth(3.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInstitutionDropdown(BuildContext context) {
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
              child: InkWell(
                onTap: () => _openInstitutionMenu(context),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: context.setWidth(3)),
                      alignment: Alignment.centerLeft,
                      child: Icon(IconlyBold.bag_2, color: const Color(0xFF49454F), size: context.setWidth(6)),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: context.setWidth(3)),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedInstitution ?? "Select Institution",
                          style: TextStyle(
                            color: selectedInstitution == null ? const Color(0x6649454F) : const Color(0xFF49454F),
                            fontSize: context.setWidth(4),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: context.setHeight(-1.2),
              left: context.setWidth(4),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(1.6)),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  'Workplace',
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
            selectedInstitution == null ? "Workplace is required" : "",
            style: TextStyle(color: Colors.red, fontSize: context.setWidth(3.5)),
          ),
        ),
      ],
    );
  }

  void _openInstitutionMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> filteredInstitutions = List.from(institutionNames);

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.setWidth(8)),
              ),
              child: Container(
                width: context.setWidth(85),
                height: context.setHeight(40),
                padding: EdgeInsets.all(context.setWidth(5)),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DBE9),
                  borderRadius: BorderRadius.circular(context.setWidth(8)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.setWidth(2)),
                      child: Container(
                        height: context.setHeight(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7CFE2),
                          borderRadius: BorderRadius.circular(context.setWidth(6)),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: context.setWidth(2)),
                              child: const Icon(Icons.search, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    filteredInstitutions = institutionNames
                                        .where((institution) => institution.toLowerCase().contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: context.setHeight(1),
                                    horizontal: context.setWidth(2),
                                  ),
                                ),
                                style: TextStyle(fontSize: context.setWidth(4)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: context.setHeight(2)),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 8.0,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          itemCount: filteredInstitutions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: context.setHeight(1)),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedInstitution = filteredInstitutions[index];
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: context.setHeight(1.5),
                                      horizontal: context.setWidth(4),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: context.setWidth(40),
                                      maxWidth: context.setWidth(80),
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4CFE8),
                                      borderRadius: BorderRadius.circular(context.setWidth(6)),
                                    ),
                                    child: Text(
                                      filteredInstitutions[index],
                                      style: TextStyle(
                                        fontSize: context.setWidth(4),
                                        color: const Color(0xFF1D1B20),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
            TextSpan(text: '${AppLocale.of(context)!.alreadyHaveAccount} '),
            TextSpan(
              text: AppLocale.of(context)!.login,
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
    _phoneController.removeListener(_updateSubmitButtonState);
    _passwordController.removeListener(_updateSubmitButtonState);
    _confirmPasswordController.removeListener(_updateSubmitButtonState);

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    if (widget.userType == UserType.doctor) {
      _workplaceController.removeListener(_updateSubmitButtonState);

      _workplaceController.dispose();
    }

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _isFormFilled) {
      BlocProvider.of<SignupBloc>(context).add(
          SignupSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            phone: _fullPhoneNumber,
            specialty: "",
            workplace: widget.userType == UserType.doctor ? selectedInstitution! : '',
            type: widget.userType,
          )
      );
    }
  }
}