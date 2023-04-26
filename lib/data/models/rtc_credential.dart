/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import '../../core/core.dart';

class RTCCredential extends Equatable {
  final String? token;
  final int? uid;
  final String? channelName;
  final int? privilegeExpiredTimeSeconds;

  const RTCCredential({
    this.token,
    this.uid,
    this.channelName,
    this.privilegeExpiredTimeSeconds,
  });

  factory RTCCredential.fromMap(Map<String, dynamic> map) {
    final token = Parser.getString(map["token"]);
    final uid = Parser.getInt(map["uid"]);
    final privilegeExpiredTimeSeconds =
        Parser.getInt(map["privilege_expired_time_seconds"]);
    final channelName = Parser.getString(map["channel_name"]);

    return RTCCredential(
      token: token,
      uid: uid,
      privilegeExpiredTimeSeconds: privilegeExpiredTimeSeconds,
      channelName: channelName,
    );
  }

  @override
  List<Object?> get props => [
        token,
        uid,
        privilegeExpiredTimeSeconds,
        channelName,
      ];
}
