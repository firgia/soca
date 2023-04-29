/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("CallHistoryError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const error =
            CallHistoryError(CallingFailure(code: CallingFailureCode.unknown));

        expect(error.failure,
            const CallingFailure(code: CallingFailureCode.unknown));
      });
    });
  });

  group("CallHistoryLoaded", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const loaded = CallHistoryLoaded([
          [
            CallHistory(),
          ],
          [
            CallHistory(),
            CallHistory(),
          ]
        ]);

        expect(loaded.data, const [
          [
            CallHistory(),
          ],
          [
            CallHistory(),
            CallHistory(),
          ]
        ]);
      });
    });
  });
}
