/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  MockSpec<PlatformInfo>(),

  /* ---------------------------------> DATA <------------------------------- */
  MockSpec<LocalLanguageProvider>(),
  MockSpec<LanguageRepository>(),

  /* -----------------------------> DEPENDENCIES <--------------------------- */
  MockSpec<DotEnv>(),
  MockSpec<FunctionsProvider>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<InternetConnectionChecker>(),
  MockSpec<OneSignal>(),

  /* --------------------------------> LOGIC <------------------------------- */
  MockSpec<LanguageBloc>(),
])
main(List<String> args) {}
