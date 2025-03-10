import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/design_system/atoms/dimensions.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
import 'package:flutter_gp5/design_system/field_validators.dart';
import 'package:flutter_gp5/design_system/molecules/button/primary_button/primary_button.dart';
import 'package:flutter_gp5/design_system/molecules/dialogs.dart';
import 'package:flutter_gp5/design_system/molecules/fields.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'package:flutter_gp5/screens/auth/login/login_screen.dart';
import 'package:flutter_gp5/screens/auth/register/bloc/register_bloc.dart';
import 'package:flutter_gp5/screens/auth/register/widgets/privacy_policy_agreement.dart';
import 'package:flutter_gp5/services/text_file_loader_service.dart';

class RegistrationFields extends StatefulWidget {
  const RegistrationFields({
    super.key,
    required this.state,
  });

  final RegisterState state;

  @override
  State<RegistrationFields> createState() => _RegistrationFieldsState();
}

class _RegistrationFieldsState extends State<RegistrationFields> {
  final _formKey = GlobalKey<FormState>();

  void _validateAndSubmit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<RegisterBloc>().add(const RegisterEvent.onSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextFormField(
              padding: dimen.horizontal.sm + dimen.vertical.xxs,
              labelText: 'Name',
              hintText: 'Enter your name',
              keyboardType: TextInputType.name,
              prefixIcon: Icons.account_circle,
              borderRadius: lg,
              validator: FieldValidators.notEmpty(),
              onSaved: (value) {
                if (value == null || value.isEmpty) return;
                bloc.add(RegisterEvent.onNameChanged(value));
              },
            ),
            CustomTextFormField(
              padding: dimen.horizontal.sm + dimen.vertical.xxs,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_rounded,
              borderRadius: lg,
              validator: FieldValidators.combine([
                FieldValidators.notEmpty(),
                FieldValidators.email(),
              ]),
              onSaved: (value) {
                if (value == null || value.isEmpty) return;
                bloc.add(RegisterEvent.onEmailChanged(value));
              },
            ),
            if (widget.state.userType == UserType.doctor)
              CustomDropdownFormField(
                padding: dimen.horizontal.sm + dimen.vertical.xxs,
                borderRadius: lg,
                isExpanded: true,
                prefixIcon: Icons.medical_services,
                hintText: 'Workplace',
                items: widget.state.workplaces,
                dropdownValues: (Workplace workplace) =>
                    '${workplace.name}, ${workplace.city}',
                onSaved: (value) {
                  if (value == null) return;
                  bloc.add(RegisterEvent.onWorkplaceChanged(value));
                },
              ),
            CustomTextFormField(
              padding: dimen.horizontal.sm + dimen.vertical.xxs,
              labelText: 'Phone',
              hintText: 'Enter your phone',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.phone,
              borderRadius: lg,
              validator: FieldValidators.combine([
                FieldValidators.notEmpty(),
                FieldValidators.phone(),
              ]),
              onSaved: (value) {
                if (value == null || value.isEmpty) return;
                bloc.add(RegisterEvent.onPhoneChanged(value));
              },
            ),
            CustomTextFormField(
                padding: dimen.horizontal.sm + dimen.vertical.xxs,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                prefixIcon: Icons.lock_open,
                borderRadius: lg,
                validator: FieldValidators.combine([
                  FieldValidators.notEmpty(),
                  FieldValidators.password(),
                ]),
                onChanged: (value) {
                  bloc.add(RegisterEvent.onPasswordChanged(value));
                }),
            CustomTextFormField(
              padding: dimen.horizontal.sm + dimen.vertical.xxs,
              labelText: 'Repeat password',
              hintText: 'Repeat your password',
              prefixIcon: Icons.lock_open,
              obscureText: true,
              borderRadius: lg,
              validator: (value) => FieldValidators.combine([
                FieldValidators.notEmpty(),
                FieldValidators.password(),
                FieldValidators.confirmPassword(widget.state.password),
              ])(value),
              onSaved: (value) {
                if (value == null || value.isEmpty) return;
                bloc.add(RegisterEvent.onRepeatPasswordChanged(value));
              },
            ),
            PrivacyPolicyAgreement(
              onShowTermsOfServiceDialog: () => showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  scrollable: true,
                  title: const Text('Terms of Service'),
                  content: Text(TextFileLoaderService().getTermsOfService()),
                  actions: [
                    PrimaryButton.small(
                      title: 'Close',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              onShowPrivacyPolicyDialog: (context) => showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: const Text('Privacy Policy'),
                  content: Text(TextFileLoaderService().getPrivacyPolicy()),
                  actions: [
                    PrimaryButton.small(
                      title: 'Close',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: dimen.horizontal.sm + dimen.vertical.xxs,
              child: PrimaryButton.blocked(
                title: 'Sign Up',
                onPressed: () => _validateAndSubmit(context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: xxsPlus),
                ),
                const SizedBox(width: nano),
                GestureDetector(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: xxsPlus,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    context.pushReplacement(const LoginScreen());
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
