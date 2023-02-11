/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

@GenerateNiceMocks([
  /* --------------------------------> CONFIG <------------------------------ */
  MockSpec<AppNavigator>(),

  /* ---------------------------------> CORE <------------------------------- */
  MockSpec<DeviceInfo>(),

  /* ---------------------------------> DATA <------------------------------- */
  MockSpec<AuthProvider>(),
  MockSpec<DeviceProvider>(),
  MockSpec<FunctionsProvider>(),
  MockSpec<LocalLanguageProvider>(),
  MockSpec<UserProvider>(),
  MockSpec<AuthRepository>(),
  MockSpec<LanguageRepository>(),

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  MockSpec<DotEnv>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<auth.FirebaseAuth>(),
  MockSpec<FirebaseFunctions>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<GoogleSignInAuthentication>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<HttpsCallable>(),
  MockSpec<auth.User>(),
  MockSpec<auth.UserCredential>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<OneSignal>(),
  MockSpec<SingletonFlutterWindow>(),
  MockSpec<WidgetsBinding>(),

  /* --------------------------------> LOGIC <------------------------------- */
  MockSpec<LanguageBloc>(),
  MockSpec<SignInBloc>(),
  MockSpec<SignOutBloc>(),
  MockSpec<RouteCubit>(),
])
main(List<String> args) {}
