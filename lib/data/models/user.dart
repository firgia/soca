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
import 'url_image.dart';
import 'user_activity.dart';
import 'user_info.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final DateTime? dateOfBirth;
  final URLImage? avatar;
  final UserType? type;
  final Gender? gender;
  final UserActivity? activity;
  final List<String>? language;
  final String? selfIntroduction;
  final UserInfo? info;

  const User({
    this.id,
    this.name,
    this.dateOfBirth,
    this.avatar,
    this.type,
    this.gender,
    this.activity,
    this.language,
    this.selfIntroduction,
    this.info,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    final id = Parser.getString(map["id"]);
    final activity = Parser.getMap(map["activity"]);
    final avatar = Parser.getMap(map["avatar"]);
    final info = Parser.getMap(map["info"]);
    final name = Parser.getString(map["name"]);
    final dateOfBirth = Parser.getString(map["date_of_birth"]);
    final type = Parser.getString(map["type"]);
    final gender = Parser.getString(map["gender"]);
    final language = Parser.getListString(map["language"]);
    final selfIntroduction = Parser.getString(map["self_introduction"]);

    return User(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth == null ? null : DateTime.tryParse(dateOfBirth),
      type: type?.toUserType(),
      avatar: avatar == null ? null : URLImage.fromMap(avatar["url"]),
      activity: activity == null ? null : UserActivity.fromMap(activity),
      gender: gender?.toGender(),
      language: language,
      selfIntroduction: selfIntroduction,
      info: info == null ? null : UserInfo.fromMap(info),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        dateOfBirth,
        avatar,
        type,
        gender,
        activity,
        language,
        selfIntroduction,
        info,
      ];
}
