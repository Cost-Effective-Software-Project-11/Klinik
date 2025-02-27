import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/config/service_locator.dart';
import 'package:flutter_gp5/design_system/molecules/error_state/error_state_view.dart';
import 'package:flutter_gp5/design_system/atoms/spaces.dart';
import 'package:flutter_gp5/enums/status.dart';
import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/screens/auth/register/widgets/registration_fields.dart';
import 'package:flutter_gp5/services/hospital_service.dart';

import 'bloc/register_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        getIt<AuthenticationRepository>(),
        getIt<HospitalService>(),
      ),
      child: const _RegisterScreen(),
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  const _RegisterScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.navigate_before, size: xl),
        title: const Text('Doctor Sign Up'),
        centerTitle: true,
      ),
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == Status.error) {
            return ErrorStateView(
              title: 'Title',
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
    );
  }
}
