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
import 'call_setting.dart';
import 'user_call.dart';

class Call extends Equatable {
  final String? id;
  final String? rtcChannelID;
  final DateTime? createdAt;
  final CallState? state;
  final UserCall? users;
  final CallSetting? settings;

  const Call({
    this.id,
    this.rtcChannelID,
    this.createdAt,
    this.state,
    this.settings,
    this.users,
  });

  factory Call.fromMap(Map<String, dynamic> map) {
    final id = Parser.getString(map["id"]);
    final channelID = Parser.getString(map["rtc_channel_id"]);
    final createdAt = Parser.getString(map["created_at"]);
    final videoCallSetting = Parser.getMap(map["settings"]);
    final users = Parser.getMap(map["users"]);
    final state = Parser.getString(map["state"]);

    return Call(
      id: id,
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt),
      rtcChannelID: channelID,
      settings: videoCallSetting == null
          ? null
          : CallSetting.fromMap(videoCallSetting),
      users: users == null ? null : UserCall.fromMap(users),
      state: state == null ? null : CallStateExtension.getFromName(state),
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        rtcChannelID,
        users,
        settings,
        state,
      ];
}
