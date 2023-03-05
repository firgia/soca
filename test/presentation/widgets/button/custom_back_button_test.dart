/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  Finder findBackTooltip() => find.byTooltip(LocaleKeys.back.tr());
  Finder findIconButton() => find.byType(IconButton);

  group("Visibility", () {
    testWidgets(
        "Should show the [CustomBackButton] when navigator.canPop() is true",
        (tester) async {
      MockAppNavigator appNavigator = getMockAppNavigator();
      when(appNavigator.canPop(any)).thenReturn(true);

      await tester.runAsync(() async {
        await tester.pumpApp(child: const Scaffold(body: CustomBackButton()));
        expect(findIconButton(), findsOneWidget);
      });
    });

    testWidgets(
        "Should hide the [CustomBackButton] when navigator.canPop() is false",
        (tester) async {
      MockAppNavigator appNavigator = getMockAppNavigator();
      when(appNavigator.canPop(any)).thenReturn(false);

      await tester.runAsync(() async {
        await tester.pumpApp(child: const Scaffold(body: CustomBackButton()));
        expect(findIconButton(), findsNothing);
      });
    });
  });

  group("Tooltip", () {
    testWidgets("Should show back text", (tester) async {
      MockAppNavigator appNavigator = getMockAppNavigator();
      when(appNavigator.canPop(any)).thenReturn(true);

      await tester.runAsync(() async {
        await tester.pumpApp(child: const Scaffold(body: CustomBackButton()));
        expect(findBackTooltip(), findsOneWidget);
      });
    });
  });
}
