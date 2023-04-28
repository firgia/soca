/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class GenderAgeChip extends StatelessWidget {
  const GenderAgeChip({this.gender, this.age, Key? key}) : super(key: key);

  final Gender? gender;
  final int? age;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing / 1.5),
      decoration: BoxDecoration(
        color: gender == Gender.female
            ? AppColors.genderFemaleColor
            : AppColors.genderMaleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (gender != null)
            gender == Gender.male ? _buildMaleIcon() : _buildFemaleIcon(),
          if (gender != null && age != null) const SizedBox(width: 4),
          if (age != null)
            Text(
              age.toString(),
              key: const Key("gender_age_chip_age_text"),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildMaleIcon() {
    return const Icon(
      FontAwesomeIcons.mars,
      key: Key("gender_age_chip_male_icon"),
      size: 12,
      color: Colors.white,
    );
  }

  Widget _buildFemaleIcon() {
    return const Icon(
      FontAwesomeIcons.venus,
      key: Key("gender_age_chip_female_icon"),
      size: 12,
      color: Colors.white,
    );
  }
}
