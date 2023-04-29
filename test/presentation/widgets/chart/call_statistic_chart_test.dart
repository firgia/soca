/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';
import 'package:soca/presentation/widgets/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../helper/helper.dart';

void main() {
  group("Chart", () {
    testWidgets("Should show SfCartesianChart", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(
          child: const Scaffold(
            body: CallStatisticChart(
              dataSource: [
                CallDataMounthly(
                  total: 99,
                  month: "Jan",
                ),
              ],
            ),
          ),
        );

        expect(find.byType(SfCartesianChart), findsOneWidget);
      });
    });
  });
}
