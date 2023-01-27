// service locator
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

/// Service locator
final sl = GetIt.instance;

void setupInjection() {
  // LOGIC
  sl.registerLazySingleton(
    () => LanguageBloc(
      languageRepository: sl<LanguageRepository>(),
    ),
  );

  // PROVIDER
  sl.registerLazySingleton(
    () => LocalLanguageProvider(
      secureStorage: const FlutterSecureStorage(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton(
    () => LanguageRepository(
      localLanguageProvider: sl<LocalLanguageProvider>(),
    ),
  );
}
