/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../helper/helper.dart';

void main() {
  setUp(() => registerLocator());
  tearDown(() => registerLocator());

  testWidgets("Should render AdaptiveLoading", (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(child: const LoadingPanel());

      expect(find.byType(AdaptiveLoading), findsOneWidget);
    });
  });

  testWidgets("Should set background color with AppColors.barrier",
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpApp(child: const LoadingPanel());

      final container = find.byType(Container).getFirstWidget() as Container;
      expect(container.color, AppColors.barrier);
    });
  });
}
