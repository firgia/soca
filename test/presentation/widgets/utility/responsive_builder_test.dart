/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';
import '../../../helper/helper.dart';

void main() {
  group(".mobileBuilder", () {
    testWidgets(
        "Should call [mobileBuilder] when device is smartphone or mobile",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return const SizedBox(key: Key("mobile"));
              },
              tabletBuilder: (context, constraints) {
                return const SizedBox(key: Key("tablet"));
              },
            ),
          ),
        );

        await tester.setScreenSize(iphone14);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key("mobile")),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key("tablet")),
          findsNothing,
        );
      });
    });
  });

  group(".tabletBuilder", () {
    testWidgets("Should call [tabletBuilder] when device is tablet",
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: Scaffold(
            body: ResponsiveBuilder(
              mobileBuilder: (context, constraints) {
                return const SizedBox(key: Key("mobile"));
              },
              tabletBuilder: (context, constraints) {
                return const SizedBox(key: Key("tablet"));
              },
            ),
          ),
        );

        await tester.setScreenSize(ipad12Pro);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key("mobile")),
          findsNothing,
        );

        expect(
          find.byKey(const Key("tablet")),
          findsOneWidget,
        );
      });
    });
  });
}
