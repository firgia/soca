/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".formatdMMMMY()", () {
    test("Should return the valid day month year format ", () {
      DateTime date1 = DateTime(2000, 4, 1);
      DateTime date2 = DateTime(1945, 8, 17);

      expect(date1.formatdMMMMY(), "1 April 2000");
      expect(date2.formatdMMMMY(), "17 August 1945");
    });
  });
}
