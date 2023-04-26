/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import 'rtc_identity.dart';
import 'user_call_identity.dart';

class CallingSetup extends Equatable {
  final String id;
  final RTCIdentity rtc;
  final UserCallIdentity localUser;
  final UserCallIdentity remoteUser;

  const CallingSetup({
    required this.id,
    required this.rtc,
    required this.localUser,
    required this.remoteUser,
  });

  @override
  List<Object?> get props => [
        id,
        rtc,
        localUser,
        remoteUser,
      ];
}
