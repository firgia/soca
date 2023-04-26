/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:swipe_refresh/utills/platform_wrapper.dart';

import '../../../injection.dart';
import '../../core.dart';

class CustomPlatformWrapper extends PlatformWrapper {
  @override
  bool get isIOS => sl<DeviceInfo>().isIOS();

  @override
  bool get isAndroid => sl<DeviceInfo>().isAndroid();
}
