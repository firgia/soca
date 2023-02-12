/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("RouteTarget", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        final routeTarget = RouteTarget(AppPages.home);

        expect(routeTarget.name, AppPages.home);
      });
    });
  });
}
