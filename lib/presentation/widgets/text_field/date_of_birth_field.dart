/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:custom_icons/custom_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class DateOfBirthField extends StatelessWidget {
  DateOfBirthField({
    required this.onChanged,
    required this.controller,
    this.initial,
    Key? key,
  }) : super(key: key);

  final DateTime? initial;
  final Function(DateTime date) onChanged;
  final TextEditingController controller;
  final FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (initial != null) {
      controller.text = initial!.formatdMMMMY();
    }

    return TextField(
      controller: controller,
      readOnly: true,
      focusNode: focus,
      decoration: InputDecoration(
        hintText: LocaleKeys.date_of_birth.tr(),
        icon: const Icon(CustomIcons.calendar),
      ),
      onTap: () => _showDatePicker(context),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  void _showDatePicker(BuildContext context) async {
    focus.unfocus();
    final currentDate = DateTime.now();

    final datePick = await showDatePicker(
      context: context,
      initialDate: currentDate.add(-const Duration(days: 365 * 17)),
      firstDate: currentDate.add(-const Duration(days: 365 * 150)),
      lastDate: currentDate.add(-const Duration(days: 365 * 3)),
    );

    if (datePick != null) {
      onChanged(datePick);
      controller.text = datePick.formatdMMMMY();
    }
  }
}
