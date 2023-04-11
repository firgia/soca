/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'config/config.dart';
import 'core/core.dart';
import 'data/data.dart';
import 'logic/logic.dart';

/// Service locator
final sl = GetIt.instance;

void setupInjection() {
  /* ---------------------------------> CORE <------------------------------- */
  sl.registerSingleton<CallKit>(CallKit());
  sl.registerSingleton<DeviceFeedback>(DeviceFeedbackImpl());
  sl.registerSingleton<DeviceInfo>(DeviceInfoImpl());

  /* --------------------------------> CONFIG <------------------------------ */
  sl.registerSingleton<AppNavigator>(AppNavigator());
  sl.registerSingleton<AppSystemOverlay>(AppSystemOverlayImpl());

  /* ---------------------------------> DATA <------------------------------- */
  sl.registerLazySingleton<AuthProvider>(() => AuthProviderImpl());
  sl.registerLazySingleton<CallingProvider>(() => CallingProviderImpl());
  sl.registerLazySingleton<DatabaseProvider>(() => DatabaseProviderImpl());
  sl.registerLazySingleton<DeviceProvider>(() => DeviceProviderImpl());
  sl.registerLazySingleton<FunctionsProvider>(() => FunctionsProviderImpl());
  sl.registerLazySingleton<LocalLanguageProvider>(
      () => LocalLanguageProviderImpl());
  sl.registerLazySingleton<OneSignalProvider>(() => OneSignalProviderImpl());
  sl.registerLazySingleton<UserProvider>(() => UserProviderImpl());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<CallingRepository>(() => CallingRepositoryImpl());
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl());
  sl.registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl());
  sl.registerLazySingleton<OnesignalRepository>(
      () => OnesignalRepositoryImpl());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  sl.registerFactory<Completer>(() => Completer());
  sl.registerSingleton<DotEnv>(dotenv);
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ));
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseDatabase>(FirebaseDatabase.instance);
  sl.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
  sl.registerSingleton<ImageCropper>(ImageCropper());
  sl.registerSingleton<ImagePicker>(ImagePicker());
  sl.registerSingleton<InternetConnectionChecker>(
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5),
      checkInterval: const Duration(seconds: 5),
    ),
  );
  sl.registerSingleton<OneSignal>(OneSignal.shared);
  sl.registerSingleton<WidgetsBinding>(WidgetsBinding.instance);

  /* --------------------------------> LOGIC <------------------------------- */
  sl.registerFactory<CallActionBloc>(() => CallActionBloc());
  sl.registerFactory<FileBloc>(() => FileBloc());
  sl.registerFactory<LanguageBloc>(() => LanguageBloc());
  sl.registerFactory<SignInBloc>(() => SignInBloc());
  sl.registerFactory<SignUpFormBloc>(() => SignUpFormBloc());
  sl.registerFactory<SignUpBloc>(() => SignUpBloc());
  sl.registerFactory<UserBloc>(() => UserBloc());
  sl.registerFactory<AccountCubit>(() => AccountCubit());
  sl.registerFactory<RouteCubit>(() => RouteCubit());
  sl.registerFactory<SignOutCubit>(() => SignOutCubit());
}
