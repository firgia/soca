/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'helper.dart';

class ScreenSize {
  const ScreenSize(this.name, this.width, this.height, this.ratio);
  final String name;
  final double width, height, ratio;
}

const iphone14 = ScreenSize("iphone_14", 1170, 2532, 19.5 / 9);
const ipad12Pro = ScreenSize("ipad_12_pro", 2048, 2732, 4 / 3);

class _App extends StatelessWidget {
  const _App({
    Key? key,
    required this.home,
  }) : super(key: key);

  final Widget home;

  @override
  Widget build(BuildContext context) {
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
  }
}

extension ScreenSizeManager on WidgetTester {
  Future<void> setScreenSize(ScreenSize screenSize) async {
    final size = Size(screenSize.width, screenSize.height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = screenSize.ratio;
  }
}

extension GetWidget on Finder {
  /// Return the single of current widget
  Widget getWidget() => evaluate().single.widget;

  /// Return the first of current widget
  Widget getFirstWidget() => evaluate().first.widget;
}
