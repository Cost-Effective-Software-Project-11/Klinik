import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/config/service_locator.dart';
import 'package:flutter_gp5/design_system/molecules/error_state/error_state_view.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
import 'package:flutter_gp5/design_system/molecules/gradient_background.dart';
import 'package:flutter_gp5/enums/status.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/screens/auth/register/widgets/registration_fields.dart';
import 'package:flutter_gp5/services/hospital_service.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
    required this.userType,
  });

  final UserType userType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        getIt<AuthenticationRepository>(),
        getIt<HospitalService>(),
        userType,
      ),
      child: _RegisterScreen(userType),
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen(this.userType);

  final UserType userType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, size: md),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          '${userType == UserType.doctor ? 'Doctor' : 'Patient'} Sign Up',
        ),
      ),
      body: GradientBackground(
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == Status.error) {
              return ErrorStateView(
                title: 'Error',
                message: state.errorMessage,
                actionLabel: 'Retry',
                onRetry: () {
                  context.read<RegisterBloc>().add(const RegisterEvent.onLoad());
                },
              );
            }

            return RegistrationFields(state: state);
          },
        ),
      ),
    );
  }
}
