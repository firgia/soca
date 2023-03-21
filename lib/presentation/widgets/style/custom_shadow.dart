/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

class CustomShadow extends BoxShadow {
  CustomShadow({Offset offset = Offset.zero})
      : super(
          color: Colors.black.withOpacity(.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: offset,
        );
}
