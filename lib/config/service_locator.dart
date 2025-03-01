import 'package:flutter_gp5/repos/authentication/authentication_repository.dart';
import 'package:flutter_gp5/services/hospital_service.dart';
import 'package:flutter_gp5/services/text_file_loader_service.dart';
import 'package:get_it/get_it.dart';

import 'log.dart';

final GetIt getIt = GetIt.instance;

void initializeDependencyInjection() {
  Log.info('Initializing dependency injection with GetIt...');

  /// Register repositories
  getIt.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepository());

  /// Register services
  getIt.registerLazySingleton<HospitalService>(() => HospitalService());
  getIt.registerLazySingleton<TextFileLoaderService>(() => TextFileLoaderService());

  Log.info('Dependency injection setup completed successfully!');
}
