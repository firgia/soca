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

class UserInfo extends Equatable {
  final DateTime? dateJoined;
  final List<String>? listOfCallYears;
  final int? totalCalls;
  final int? totalFriends;
  final int? totalVisitors;

  const UserInfo({
    this.dateJoined,
    this.listOfCallYears,
    this.totalCalls,
    this.totalFriends,
    this.totalVisitors,
  });

  DateTime? get localDateJoined {
    return dateJoined?.toLocal();
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    final dateJoined = Parser.getString(map["date_joined"]);
    final listOfCallYears = Parser.getListString(map["list_of_call_years"]);
    final totalCalls = Parser.getInt(map["total_calls"]);
    final totalFriends = Parser.getInt(map["total_friends"]);
    final totalVisitors = Parser.getInt(map["total_visitors"]);

    return UserInfo(
      dateJoined: dateJoined == null ? null : DateTime.tryParse(dateJoined),
      listOfCallYears: listOfCallYears,
      totalCalls: totalCalls,
      totalFriends: totalFriends,
      totalVisitors: totalVisitors,
    );
  }

  @override
  List<Object?> get props => [
        dateJoined,
        listOfCallYears,
        totalCalls,
        totalFriends,
        totalVisitors,
      ];
}
