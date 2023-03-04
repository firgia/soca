/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fixed", () {
    test("Should return small, medium, large, or original when available", () {
      const case1 = URLImage(
        small: "small.png",
        medium: "medium.png",
        large: "large.png",
        original: "original.png",
      );

      const case2 = URLImage(
        small: null,
        medium: "medium.png",
        large: "large.png",
        original: "original.png",
      );
      const case3 = URLImage(
        small: null,
        medium: null,
        large: "large.png",
        original: "original.png",
      );

      const case4 = URLImage(
        small: null,
        medium: null,
        large: null,
        original: "original.png",
      );

      const case5 = URLImage(
        small: null,
        medium: null,
        large: null,
        original: null,
      );

      expect(case1.fixed, "small.png");
      expect(case2.fixed, "medium.png");
      expect(case3.fixed, "large.png");
      expect(case4.fixed, "original.png");
      expect(case5.fixed, null);
    });
  });

  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = URLImage.fromMap(
        const {
          "small": "small.png",
          "medium": "medium.png",
          "large": "large.png",
          "original": "original.png",
        },
      );

      const expected = URLImage(
        small: "small.png",
        medium: "medium.png",
        large: "large.png",
        original: "original.png",
      );

      expect(actual, expected);
    });
  });
}
