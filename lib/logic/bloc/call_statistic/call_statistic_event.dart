/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_statistic_bloc.dart';

abstract class CallStatisticEvent extends Equatable {
  const CallStatisticEvent();

  @override
  List<Object?> get props => [];
}

class CallStatisticFetched extends CallStatisticEvent {
  final String? locale;
  final Completer? completer;

  const CallStatisticFetched(
    this.locale, {
    this.completer,
  });

  @override
  List<Object?> get props => [locale, completer];
}

class CallStatisticYearChanged extends CallStatisticEvent {
  final String year;
  final String? locale;

  const CallStatisticYearChanged({
    required this.year,
    this.locale,
  });

  @override
  List<Object?> get props => [year, locale];
}
