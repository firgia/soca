/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

class SoftShadow extends BoxShadow {
  SoftShadow({Offset offset = Offset.zero})
      : super(
          color: Colors.black.withOpacity(.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: offset,
        );
}
