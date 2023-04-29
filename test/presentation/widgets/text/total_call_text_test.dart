/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  group("Text", () {
    testWidgets("Should show rich text", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const TotalCallText(20),
        );

        expect(
          find.byType(RichText),
          findsOneWidget,
        );
      });
    });
  });
}
