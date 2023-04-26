/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';
export 'mock.mocks.dart';

@GenerateNiceMocks([
  /* --------------------------------> CONFIG <------------------------------ */
  MockSpec<AppNavigator>(),

  /* ---------------------------------> CORE <------------------------------- */
  MockSpec<CallKit>(),
  MockSpec<DeviceFeedback>(),
  MockSpec<DeviceInfo>(),
  MockSpec<DeviceSettings>(),

  /* ---------------------------------> DATA <------------------------------- */
  MockSpec<AuthProvider>(),
  MockSpec<CallingProvider>(),
  MockSpec<DatabaseProvider>(),
  MockSpec<DeviceProvider>(),
  MockSpec<FunctionsProvider>(),
  MockSpec<LocalLanguageProvider>(),
  MockSpec<OneSignalProvider>(),
  MockSpec<UserProvider>(),
  MockSpec<AuthRepository>(),
  MockSpec<CallingRepository>(),
  MockSpec<FileRepository>(),
  MockSpec<LanguageRepository>(),
  MockSpec<UserRepository>(),

  /* -----------------------------> DEPENDENCIES <--------------------------- */

  MockSpec<Completer>(),
  MockSpec<DatabaseEvent>(),
  MockSpec<DatabaseReference>(),
  MockSpec<DataSnapshot>(),
  MockSpec<DotEnv>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<auth.FirebaseAuth>(),
  MockSpec<FirebaseDatabase>(),
  MockSpec<FirebaseFunctions>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<GoogleSignInAuthentication>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<HttpsCallable>(),
  MockSpec<auth.User>(),
  MockSpec<auth.UserCredential>(),
  MockSpec<ImageCropper>(),
  MockSpec<ImagePicker>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<OneSignal>(),
  MockSpec<agora.RtcEngine>(),
  MockSpec<SingletonFlutterWindow>(),
  MockSpec<WidgetsBinding>(),

  /* --------------------------------> LOGIC <------------------------------- */
  MockSpec<CallActionBloc>(),
  MockSpec<FileBloc>(),
  MockSpec<IncomingCallBloc>(),
  MockSpec<LanguageBloc>(),
  MockSpec<SignInBloc>(),
  MockSpec<SignUpBloc>(),
  MockSpec<SignUpFormBloc>(),
  MockSpec<UserBloc>(),
  MockSpec<VideoCallBloc>(),
  MockSpec<AccountCubit>(),
  MockSpec<RouteCubit>(),
  MockSpec<SignOutCubit>(),
])
main(List<String> args) {}
