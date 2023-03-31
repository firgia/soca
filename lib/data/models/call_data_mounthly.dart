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

class CallDataMounthly extends Equatable {
  final String? month;
  final int? total;

  const CallDataMounthly({
    this.total,
    this.month,
  });

  factory CallDataMounthly.fromMap(Map<String, dynamic> map) {
    final month = Parser.getString(map["month"]);
    final total = Parser.getInt(map["total"]);

    return CallDataMounthly(
      month: month,
      total: total,
    );
  }

  @override
  List<Object?> get props => [
        total,
        month,
      ];
}
