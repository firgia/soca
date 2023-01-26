/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'config/config.dart';
import 'logic/logic.dart';
import 'core/core.dart';

/// We need to initialize app before start to the main page
///
/// This initialize include
/// * initialize Firebase
/// * Initialize Splash screen
/// * Initialize screen orientation
Future<void> initializeApp() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Paint.enableDithering = true;

  // Load Env file
  //
  // Some third-party are dependent on the env file,
  // so we need to load the env before initializing third party
  late String envFileName;
  switch (Environtment.current) {
    case EnvirontmentType.development:
      envFileName = ".env.development";
      break;
    case EnvirontmentType.staging:
      envFileName = ".env.staging";
      break;
    default:
      envFileName = ".env.production";
      break;
  }
  await dotenv.load(fileName: envFileName);

  // Initialize all asynchronous methods which possible to initialize at the
  // same time to speed up the initialization process
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    Firebase.initializeApp(),
    OneSignal.shared.setAppId(Environtment.onesignalAppID),
    OnesignalHandler.initialize(showLog: Environtment.isDevelopment()),
    EasyLocalization.ensureInitialized(),
  ]);
}

class App extends StatefulWidget {
  const App({required this.title, super.key});
  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => SignOutBloc()),
      ],
      child: MaterialApp.router(
        title: widget.title,

        /* LOCALE SETUP */
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        /* THEMING SETUP */
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        /* ROUTER SETUP */
        routerDelegate: AppRoutes.router.routerDelegate,
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routeInformationProvider: AppRoutes.router.routeInformationProvider,
      ),
    );
  }
}
