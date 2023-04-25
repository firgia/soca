/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../core/core.dart';
import 'user_caller.dart';

class CallKitData extends Equatable {
  final String? uuid;
  final String? type;
  final UserCaller? userCaller;

  const CallKitData({
    this.uuid,
    this.type,
    this.userCaller,
  });

  static CallKitData? getDataFromEvent(CallEvent event) {
    try {
      Map<String, dynamic> extra = jsonDecode(jsonEncode(event.body["extra"]));
      return CallKitData.fromMap(extra);
    } catch (e) {
      return null;
    }
  }

  static CallKitData? getData(dynamic event) {
    try {
      Map<String, dynamic> extra = jsonDecode(jsonEncode(event["extra"]));
      return CallKitData.fromMap(extra);
    } catch (e) {
      return null;
    }
  }

  factory CallKitData.fromMap(Map<String, dynamic> map) {
    final uuid = Parser.getString(map['uuid']);
    final type = Parser.getString(map['type']);
    final userCaller = Parser.getMap(map['user_caller']);

    return CallKitData(
      uuid: uuid,
      type: type,
      userCaller: userCaller == null ? null : UserCaller.fromMap(userCaller),
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        type,
        userCaller,
      ];
}
