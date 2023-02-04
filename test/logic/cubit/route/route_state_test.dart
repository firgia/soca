/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("RouteTarget", () {
    group("Fields", () {
      group("path", () {
        test("Should return path value based on constructor", () {
          const routeTarget = RouteTarget("/home");

          expect(routeTarget.path, "/home");
        });
      });
    });
  });
}
