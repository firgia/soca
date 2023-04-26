/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

class RTCIdentity extends Equatable {
  final String token;
  final String channelName;
  final int uid;

  const RTCIdentity({
    required this.token,
    required this.channelName,
    required this.uid,
  });

  @override
  List<Object?> get props => [
        token,
        channelName,
        uid,
      ];
}
