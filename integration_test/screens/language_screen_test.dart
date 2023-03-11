/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Feb 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class LanguageScreenTest {
  const LanguageScreenTest(this.tester);
  final WidgetTester tester;

  /// Change language based on the flag button tapped
  Future<void> changeLanguage() async {
    final Finder englishButton =
        find.byKey(const Key("language_screen_flag_button_english"));

    final Finder indonesianButton =
        find.byKey(const Key("language_screen_flag_button_indonesian"));

    // Tap the English language button
    await tester.tap(englishButton);
    await tester.pumpAndSettle();
    expect(find.text("Language"), findsWidgets);
    expect(find.text("Bahasa"), findsNothing);

    // Tap the Indonesian language Button
    await tester.tap(indonesianButton);
    await tester.pumpAndSettle();
    expect(find.text("Bahasa"), findsWidgets);
    expect(find.text("Language"), findsNothing);
  }
}
