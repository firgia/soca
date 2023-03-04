/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/presentation/presentation.dart';

void main() {
  group("()", () {
    test("Should extend to BoxShadow", () {
      SoftShadow softShadow = SoftShadow();

      expect(softShadow, isA<BoxShadow>());
    });
  });
}
