/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import '../../core/core.dart';

class CallSetting extends Equatable {
  final bool? enableFlashlight;
  final bool? enableFlip;

  const CallSetting({
    this.enableFlip,
    this.enableFlashlight,
  });

  factory CallSetting.fromMap(Map<String, dynamic> map) {
    final enableFlashlight = Parser.getBool(map["enable_flashlight"]);
    final enableFlip = Parser.getBool(map["enable_flip"]);

    return CallSetting(
      enableFlashlight: enableFlashlight,
      enableFlip: enableFlip,
    );
  }

  @override
  List<Object?> get props => [
        enableFlip,
        enableFlashlight,
      ];
}
