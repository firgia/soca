/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("CallStatisticFetched", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        final completer = Completer();
        final event = CallStatisticFetched("ar", completer: completer);

        expect(event.locale, "ar");
        expect(event.completer, completer);
      });
    });
  });

  group("CallStatisticYearChanged", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const event = CallStatisticYearChanged(year: "2020", locale: "ar");

        expect(event.locale, "ar");
        expect(event.year, "2020");
      });
    });
  });
}
