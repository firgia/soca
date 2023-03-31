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
import 'call_data_mounthly.dart';

class CallStatistic extends Equatable {
  final int? total;
  final List<CallDataMounthly>? monthlyStatistics;

  const CallStatistic({
    this.total,
    this.monthlyStatistics,
  });

  factory CallStatistic.fromMap(Map<String, dynamic> map) {
    final total = Parser.getInt(map["total"]);
    final monthlyStatistics = Parser.getListDynamic(map["monthly_statistics"]);

    return CallStatistic(
        total: total,
        monthlyStatistics: monthlyStatistics
            ?.map((e) => CallDataMounthly.fromMap(e))
            .toList());
  }

  @override
  List<Object?> get props => [
        total,
        monthlyStatistics,
      ];
}
