/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 18 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shimmer/shimmer.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockWidgetsBinding widgetBinding;

  setUp(() {
    registerLocator();
    widgetBinding = getMockWidgetsBinding();
    MockSingletonFlutterWindow window = MockSingletonFlutterWindow();

    when(window.platformBrightness).thenReturn(Brightness.light);
    when(widgetBinding.window).thenReturn(window);
  });

  tearDown(() => unregisterLocator());

  testWidgets("Should render [Shimmer]", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(child: const CustomShimmer());

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  testWidgets("Should use [BrightnessBuilder]", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(child: const CustomShimmer());

      expect(find.byType(BrightnessBuilder), findsOneWidget);
    });
  });
}
