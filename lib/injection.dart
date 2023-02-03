/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'config/config.dart';
import 'core/core.dart';
import 'data/data.dart';
import 'logic/logic.dart';

/// Service locator
final sl = GetIt.instance;

void setupInjection() {
  /* --------------------------------> CONFIG <------------------------------ */
  sl.registerLazySingleton<AppNavigator>(() => AppNavigator());

  /* ---------------------------------> CORE <------------------------------- */
  sl.registerLazySingleton<DeviceInfo>(() => DeviceInfo());

  /* ---------------------------------> DATA <------------------------------- */
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider());
  sl.registerLazySingleton<DeviceProvider>(() => DeviceProvider());
  sl.registerLazySingleton<FunctionsProvider>(() => FunctionsProvider());
  sl.registerLazySingleton<LocalLanguageProvider>(
      () => LocalLanguageProvider());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  sl.registerLazySingleton<LanguageRepository>(() => LanguageRepository());
  sl.registerLazySingleton<OnesignalRepository>(() => OnesignalRepository());

  /* -----------------------------> DEPENDENCIES <---------------------------- */
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
  sl.registerSingleton<InternetConnectionChecker>(
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5),
      checkInterval: const Duration(seconds: 5),
    ),
  );
  sl.registerSingleton<OneSignal>(OneSignal.shared);

  /* --------------------------------> LOGIC <------------------------------- */
  sl.registerFactory<LanguageBloc>(() => LanguageBloc());
  sl.registerFactory<SignInBloc>(() => SignInBloc());
  sl.registerFactory<SignOutBloc>(() => SignOutBloc());
}
