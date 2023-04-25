/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import '../../core/core.dart';

class UserCaller extends Equatable {
  final String? gender;
  final String? name;
  final String? uid;
  final String? type;
  final String? dateOfBirth;
  final String? avatar;

  const UserCaller({
    this.gender,
    this.name,
    this.uid,
    this.type,
    this.dateOfBirth,
    this.avatar,
  });

  factory UserCaller.fromMap(Map<String, dynamic> map) {
    final gender = Parser.getString(map['gender']);
    final name = Parser.getString(map['name']);
    final uid = Parser.getString(map['uid']);
    final type = Parser.getString(map['type']);
    final dateOfBirth = Parser.getString(map['date_of_birth']);
    final avatar = Parser.getString(map['avatar']);

    return UserCaller(
      gender: gender,
      name: name,
      uid: uid,
      type: type,
      dateOfBirth: dateOfBirth,
      avatar: avatar,
    );
  }

  @override
  List<Object?> get props => [
        gender,
        name,
        uid,
        type,
        dateOfBirth,
        avatar,
      ];
}
