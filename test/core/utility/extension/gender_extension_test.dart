/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".getName()", () {
    test("Should return [LocaleKeys.male] when Gender is male", () {
      expect(Gender.male.getName(), LocaleKeys.male.tr());
    });

    test("Should return [LocaleKeys.female] when Gender is female", () {
      expect(Gender.female.getName(), LocaleKeys.female.tr());
    });
  });
}
