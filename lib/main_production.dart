/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'config/config.dart';
import 'core/core.dart';

Future<void> main() async {
  Environtment.setCurrentEnvirontment(EnvirontmentType.production);
  await initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

  runApp(
    EasyLocalization(
      path: AppTranslations.path,
      supportedLocales: AppTranslations.supportedLocales,
      fallbackLocale: AppTranslations.fallbackLocale,
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: const App(title: "Soca"),
    ),
  );
}
