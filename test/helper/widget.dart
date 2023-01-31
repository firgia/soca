/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'helper.dart';

late BuildContext _context;

class _App extends StatelessWidget {
  const _App({
    Key? key,
    required this.home,
  }) : super(key: key);

  final Widget home;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return MaterialApp(
      locale: EasyLocalization.of(context)!.locale,
      supportedLocales: EasyLocalization.of(context)!.supportedLocales,
      localizationsDelegates: EasyLocalization.of(context)!.delegates,
      home: home,
    );
  }
}

extension PumpApp on WidgetTester {
  /// Shortcut to pump a widget before testing
  Future<void> pumpApp({
    required Widget child,
    Duration? duration,
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    void Function(BuildContext context)? onCompleted,
  }) async {
    SharedPreferences.setMockInitialValues({});
    EasyLocalization.logger.enableLevels = [];
    await EasyLocalization.ensureInitialized();

    await pumpWidget(
      EasyLocalization(
        path: AppTranslations.path,
        supportedLocales: AppTranslations.supportedLocales,
        fallbackLocale: AppTranslations.fallbackLocale,
        useFallbackTranslations: true,
        useOnlyLangCode: true,
        child: _App(home: child),
      ),
      duration,
      phase,
    );

    await pump();

    if (onCompleted != null) {
      onCompleted(_context);
    }
  }
}

extension GetWidget on Finder {
  /// Return the single of current widget
  Widget getWidget() => evaluate().single.widget;
}
