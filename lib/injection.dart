/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

/// Service locator
final sl = GetIt.instance;

void setupInjection() {
  // LOGIC
  sl.registerFactory(
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

  sl.registerLazySingleton(
    () => OnesignalRepository(
      languageRepository: sl<LanguageRepository>(),
      oneSignal: OneSignal.shared,
    ),
  );

  sl.registerLazySingleton(
    () => PlatformInfo(
      isIOS: Platform.isIOS,
      isAndroid: Platform.isAndroid,
    ),
  );
}
