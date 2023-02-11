/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import '../../core/core.dart';

class Language extends Equatable {
  final String? code;
  final String? name;
  final String? nativeName;

  const Language({
    this.code,
    this.name,
    this.nativeName,
  });

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      code: Parser.getString(map["code"]),
      name: Parser.getString(map["name"]),
      nativeName: Parser.getString(map["nativeName"]),
    );
  }

  @override
  List<Object?> get props => [
        code,
        name,
        nativeName,
      ];
}
