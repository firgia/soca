/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_history_bloc.dart';

abstract class CallHistoryEvent extends Equatable {
  const CallHistoryEvent();

  @override
  List<Object?> get props => [];
}

class CallHistoryFetched extends CallHistoryEvent {
  final Completer? completer;
  const CallHistoryFetched({this.completer});

  @override
  List<Object?> get props => [completer];
}
