/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".getFromName()", () {
    test('Should return [CallRole.answerer] when name is answerer', () {
      expect(CallRoleExtension.getFromName("answerer"), CallRole.answerer);
    });

    test('Should return [CallRole.caller] when name is caller', () {
      expect(CallRoleExtension.getFromName("caller"), CallRole.caller);
    });
  });
}
