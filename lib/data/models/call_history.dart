/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import '../../core/core.dart';
import 'user.dart';

class CallHistory extends Equatable {
  final String? id;
  final DateTime? endedAt;
  final DateTime? createdAt;
  final CallState? state;
  final CallRole? role;
  final User? remoteUser;

  DateTime? get localCreatedAt {
    return createdAt?.toLocal();
  }

  DateTime? get localEndedAt {
    return endedAt?.toLocal();
  }

  const CallHistory({
    this.id,
    this.endedAt,
    this.createdAt,
    this.state,
    this.role,
    this.remoteUser,
  });

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    final id = Parser.getString(map["id"]);
    final createdAt = Parser.getString(map["created_at"]);
    final endedAt = Parser.getString(map["ended_at"]);
    final remoteUser = Parser.getMap(map["remote_user"]);
    final role = Parser.getString(map["role"]);
    final state = Parser.getString(map["state"]);

    return CallHistory(
      id: id,
      createdAt: createdAt == null ? null : DateTime.tryParse(createdAt),
      endedAt: endedAt == null ? null : DateTime.tryParse(endedAt),
      remoteUser: remoteUser == null ? null : User.fromMap(remoteUser),
      role: role == null ? null : CallRoleExtension.getFromName(role),
      state: state == null ? null : CallStateExtension.getFromName(state),
    );
  }

  @override
  List<Object?> get props => [
        id,
        endedAt,
        createdAt,
        state,
        role,
        remoteUser,
      ];
}
