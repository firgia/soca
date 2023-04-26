/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("IncomingCallLoaded", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const IncomingCallLoaded incomingCallLoaded = IncomingCallLoaded(
          id: "123",
          blindID: "456",
          name: "test",
          urlImage: "img.jpg",
        );

        expect(incomingCallLoaded.id, "123");
        expect(incomingCallLoaded.blindID, "456");
        expect(incomingCallLoaded.name, "test");
        expect(incomingCallLoaded.urlImage, "img.jpg");
      });
    });
  });
}
