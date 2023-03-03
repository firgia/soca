/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/core.dart';
import '../style/style.dart';
import 'gradient_button.dart';

class GenderButton extends StatelessWidget {
  const GenderButton({
    required this.gender,
    required this.onPressed,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final Gender gender;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return selected ? _buildSelected(context) : _buildUnselected(context);
  }

  Widget _buildSelected(BuildContext context) {
    return GradientButton(
      key: const Key("gender_button_selected"),
      icon: Icon(
        gender == Gender.male ? FontAwesomeIcons.mars : FontAwesomeIcons.venus,
        color: Colors.white,
        size: 20,
      ),
      size: ButtonSize.small,
      onPressed: onPressed,
      label: gender.getName(),
      onPrimary: Colors.white,
      colors: gender == Gender.male
          ? [
              Colors.lightBlue,
              Colors.lightBlue[300]!,
            ]
          : [
              Colors.pink,
              Colors.pink[300]!,
            ],
    );
  }

  Widget _buildUnselected(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key("gender_button_unselected"),
      icon: Icon(
        gender == Gender.male ? FontAwesomeIcons.mars : FontAwesomeIcons.venus,
        color: Theme.of(context).dividerColor,
        size: 20,
      ),
      onPressed: onPressed,
      label: Text(gender.getName()),
      style: OutlinedButtonStyle(
        color: Theme.of(context).dividerColor,
        size: ButtonSize.small,
      ),
    );
  }
}
