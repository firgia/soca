/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("CallHistoryFetched", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        final completer = Completer();
        final event1 = CallHistoryFetched(completer: completer);

        expect(event1.completer, completer);

        const event2 = CallHistoryFetched();
        expect(event2.completer, null);
      });
    });
  });
}
