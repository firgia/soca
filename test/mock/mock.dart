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
import 'package:mockito/annotations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

@GenerateNiceMocks([
  MockSpec<DotEnv>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<OneSignal>(),
  MockSpec<PlatformInfo>(),

  // PROVIDER
  MockSpec<LocalLanguageProvider>(),

  // REPOSITORY
  MockSpec<LanguageRepository>(),

  // BLOC
  MockSpec<LanguageBloc>(),
])
main(List<String> args) {}
