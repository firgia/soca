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
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

/// Service locator
final sl = GetIt.instance;

void setupInjection() {
  /* --------------------------------> CONFIG <------------------------------ */
  sl.registerLazySingleton(() => AppNavigator());

  /* ---------------------------------> CORE <------------------------------- */
  sl.registerLazySingleton(
    () => PlatformInfo(
      isIOS: Platform.isIOS,
      isAndroid: Platform.isAndroid,
    ),
  );

  /* ---------------------------------> DATA <------------------------------- */
  sl.registerLazySingleton(
    () => LocalLanguageProvider(),
  );

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

  /* -----------------------------> DEPENDENCIES <---------------------------- */
  sl.registerSingleton<InternetConnectionChecker>(
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5),
      checkInterval: const Duration(seconds: 5),
    ),
  );

  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  /* --------------------------------> LOGIC <------------------------------- */
  sl.registerFactory(
    () => LanguageBloc(
      languageRepository: sl<LanguageRepository>(),
    ),
  );
}
