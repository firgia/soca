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

class UserCall extends Equatable {
  final String? blindID;
  final String? volunteerID;

  const UserCall({
    this.blindID,
    this.volunteerID,
  });

  factory UserCall.fromMap(Map<String, dynamic> map) {
    final blindID = Parser.getString(map["blind_id"]);
    final volunteerID = Parser.getString(map["volunteer_id"]);

    return UserCall(
      blindID: blindID,
      volunteerID: volunteerID,
    );
  }

  @override
  List<Object?> get props => [
        blindID,
        volunteerID,
      ];
}
