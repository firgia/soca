/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import '../../core/core.dart';

class UserActivity extends Equatable {
  final bool? online;
  final DateTime? lastSeen;

  const UserActivity({
    this.online,
    this.lastSeen,
  });

  factory UserActivity.fromMap(Map<String, dynamic> map) {
    final online = Parser.getBool(map["online"]);
    final lastSeen = Parser.getString(map["last_seen"]);

    return UserActivity(
      online: online,
      lastSeen: lastSeen == null ? null : DateTime.tryParse(lastSeen),
    );
  }

  @override
  List<Object?> get props => [
        online,
        lastSeen,
      ];
}
