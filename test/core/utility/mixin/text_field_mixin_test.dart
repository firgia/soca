/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

class _TextField with TrimTextfield {}

void main() {
  group(".trimTextfield()", () {
    test("Should remove the whitespace", () {
      TextEditingController controller =
          TextEditingController(text: " hello world ");

      _TextField().trimTextfield(
        currentValue: controller.text,
        controller: controller,
      );

      expect(controller.text, "hello world");
    });

    test("Should remove the whitespace and format based on [textEditor]", () {
      TextEditingController controller =
          TextEditingController(text: " mochamad firgia ");

      _TextField().trimTextfield(
        currentValue: controller.text,
        controller: controller,
        textEditor: (newText) => newText.capitalize,
      );

      expect(controller.text, "Mochamad Firgia");
    });
  });
}
