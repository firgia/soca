/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatdMMMMY() {
    return DateFormat('d MMMM y').format(this);
  }
}
