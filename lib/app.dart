import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soca/config/config.dart';
import 'package:soca/logic/logic.dart';

class App extends StatefulWidget {
  const App({required this.title, super.key});
  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
