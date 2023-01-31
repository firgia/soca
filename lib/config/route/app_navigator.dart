/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

class AppNavigator {
  void back<T>(BuildContext context, {T? result}) {
    if (canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }

  bool canPop(BuildContext context) => Navigator.of(context).canPop();
}
