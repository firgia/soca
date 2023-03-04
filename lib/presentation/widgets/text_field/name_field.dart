/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:custom_icons/custom_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class NameField extends StatefulWidget {
  const NameField({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField>
    with ValidateName, TrimTextfield {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: LocaleKeys.name.tr(),
        icon: const Icon(CustomIcons.profile),
      ),
      validator: validateName,
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 600), () {
          trimTextfield(
            currentValue: value,
            controller: widget.controller,
            textEditor: (newText) => newText.capitalize,
          );
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
      ],
      style: Theme.of(context).textTheme.bodyLarge,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _debounce?.cancel();
  }
}
