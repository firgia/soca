/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Jan 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => unregisterLocator());

  group("Platform", () {
    testWidgets("Should render CupertinoActivityIndicator if platform is iOS",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const AdaptiveLoading(platform: AdaptivePlatform.ios),
        );

        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    testWidgets(
        "Should render CircularProgressIndicator if platform is android",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const AdaptiveLoading(platform: AdaptivePlatform.android),
        );

        expect(find.byType(CupertinoActivityIndicator), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets("Should render Automatically by target platform",
        (tester) async {
      MockPlatformInfo platformInfo = getMockPlatformInfo();

      await tester.runAsync(() async {
        // Check is Android
        when(platformInfo.isIOS).thenReturn(false);
        await tester.pumpApp(child: const AdaptiveLoading());
        expect(find.byType(CupertinoActivityIndicator), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Check is IOS
        when(platformInfo.isIOS).thenReturn(true);
        await tester.pumpApp(child: const AdaptiveLoading());
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });
  });

  group("Color", () {
    testWidgets(
        "Should set CircularProgressIndicator color based on parameter color",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const AdaptiveLoading(
            platform: AdaptivePlatform.android,
            color: Color.fromRGBO(20, 20, 20, 1),
          ),
        );

        final indicator = find.byType(CircularProgressIndicator).getWidget()
            as CircularProgressIndicator;

        expect(indicator.color, const Color.fromRGBO(20, 20, 20, 1));
      });
    });

    testWidgets(
        "Should set CupertinoActivityIndicator color based on parameter color",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const AdaptiveLoading(
            platform: AdaptivePlatform.ios,
            color: Color.fromRGBO(20, 20, 20, 1),
          ),
        );

        final indicator = find.byType(CupertinoActivityIndicator).getWidget()
            as CupertinoActivityIndicator;

        expect(indicator.color, const Color.fromRGBO(20, 20, 20, 1));
      });
    });
  });

  group("Radius", () {
    testWidgets(
        "Should set CircularProgressIndicator radius based on parameter",
        (tester) async {
      await tester.runAsync(() async {
        double radius = 12;

        await tester.pumpApp(
          child: const AdaptiveLoading(
            platform: AdaptivePlatform.android,
            color: Color.fromRGBO(20, 20, 20, 1),
          ),
        );

        final indicator =
            find.byKey(const Key("android_indicator")).getWidget() as SizedBox;

        expect(indicator.height, radius * 2);
        expect(indicator.width, radius * 2);
      });
    });

    testWidgets(
        "Should set CupertinoActivityIndicator radius based on parameter",
        (tester) async {
      await tester.runAsync(() async {
        double radius = 12;

        await tester.pumpApp(
          child: const AdaptiveLoading(
            platform: AdaptivePlatform.ios,
            color: Color.fromRGBO(20, 20, 20, 1),
          ),
        );

        final indicator = find.byType(CupertinoActivityIndicator).getWidget()
            as CupertinoActivityIndicator;

        expect(indicator.radius, radius);
      });
    });
  });
}
