/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Feb 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:soca/main_development.dart' as app;
import 'screens/language_screen_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  LanguageScreenTest languageScreenTest;

  group("End-To-End", () {
    testWidgets("whole apps", (tester) async {
      languageScreenTest = LanguageScreenTest(tester);
      await Future.delayed(const Duration(seconds: 1));
      await app.main();
      await tester.pumpAndSettle();

      await languageScreenTest.changeLanguage();
      await tester.pumpAndSettle();
    });
  });
}
