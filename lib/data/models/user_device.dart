/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import '../../core/core.dart';

class UserDevice extends Equatable {
  final String? id;
  final String? playerID;
  final String? language;

  const UserDevice({
    this.id,
    this.playerID,
    this.language,
  });

  factory UserDevice.fromMap(Map<String, dynamic> map) {
    final id = Parser.getString(map["id"]);
    final playerID = Parser.getString(map["player_id"]);
    final language = Parser.getString(map["language"]);

    return UserDevice(
      id: id,
      playerID: playerID,
      language: language,
    );
  }

  @override
  List<Object?> get props => [
        id,
        playerID,
        language,
      ];
}
