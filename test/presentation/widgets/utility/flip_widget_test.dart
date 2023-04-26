/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';
import 'dart:math' as math;

void main() {
  Finder findTransform() => find.byKey(const Key("flip_widget_transform"));

  group("Flip", () {
    testWidgets("Should flip widget when [flip] is true ", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: FlipWidget(
              flip: true,
              child: SizedBox(),
            ),
          ),
        );

        Transform transform = findTransform().getWidget() as Transform;
        expect(findTransform(), findsOneWidget);

        expect(transform.transform, Matrix4.rotationY(math.pi));
        expect(transform.alignment, Alignment.center);
      });
    });

    testWidgets("Should not flip widget when [flip] is false", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: FlipWidget(
              flip: false,
              child: SizedBox(),
            ),
          ),
        );

        expect(findTransform(), findsNothing);
      });
    });
  });
}
