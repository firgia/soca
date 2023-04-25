/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  AppState appState = AppStateImpl();

  group(".setUserAlreadyToHomePage()", () {
    test("Should change [userAlreadyToHomePage]", () {
      appState.setUserAlreadyToHomePage(true);
      expect(appState.userAlreadyToHomePage, true);
    });
  });
}
