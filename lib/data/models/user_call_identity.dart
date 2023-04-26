/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';

import '../../core/core.dart';

class UserCallIdentity extends Equatable {
  final String name;
  final String uid;
  final String avatar;
  final UserType type;

  const UserCallIdentity({
    required this.name,
    required this.uid,
    required this.avatar,
    required this.type,
  });

  @override
  List<Object?> get props => [
        name,
        uid,
        avatar,
        type,
      ];
}
