import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:soca/config/config.dart';
import 'package:soca/logic/logic.dart';

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

  // Initialize all asynchronous method
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    Firebase.initializeApp(),
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

        /* THEMING SETUP */
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        /* ROUTER SETUP */
        routerDelegate: AppRoutes().router.routerDelegate,
        routeInformationParser: AppRoutes().router.routeInformationParser,
        routeInformationProvider: AppRoutes().router.routeInformationProvider,
      ),
    );
  }
}
