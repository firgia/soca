/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

// Trim text field value
mixin TrimTextfield {
  void trimTextfield({
    required String currentValue,
    required TextEditingController controller,
    String Function(String newText)? textEditor,
  }) {
    final baseOffset = controller.selection.baseOffset;

    // remove right white space
    currentValue = currentValue.trimRight();
    bool isLastSelection = currentValue.length <= baseOffset;

    // remove left white space
    final temp = currentValue.trimLeft();
    int totalRemoveLeft = currentValue.length - temp.length;

    currentValue = temp;

    int newOffset = baseOffset;
    if (!isLastSelection) newOffset = baseOffset - totalRemoveLeft;

    // remove midle double white space
    final explode = currentValue.split(" ");
    String newText = "";
    bool isFixedPosition = false;

    for (String val in explode) {
      if (val.trim().isNotEmpty) newText += "$val ";

      if (!isFixedPosition) {
        if (newText.trim().length >= newOffset) {
          isFixedPosition = true;
        } else {
          newOffset -= (val.trim().isEmpty) ? 1 : 0;
        }
      }
    }

    currentValue = newText.trim();

    if (textEditor != null) {
      bool isNotSameText =
          textEditor(currentValue).toLowerCase() != currentValue.toLowerCase();

      if (isNotSameText) {
        controller.text = currentValue;
      } else {
        controller.text = textEditor(currentValue);
      }
    } else {
      controller.text = currentValue;
    }

    // set cursor position
    if (isLastSelection) newOffset = currentValue.length;

    // make sure is not error
    if (newOffset > controller.text.length) {
      newOffset = controller.text.length;
    } else if (newOffset < 0) {
      newOffset = 0;
    }

    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: newOffset));
  }
}
