/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

mixin UIMixin {
  bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  bool isLTR(BuildContext context) {
    return Directionality.of(context) == TextDirection.ltr;
  }

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768;
}
