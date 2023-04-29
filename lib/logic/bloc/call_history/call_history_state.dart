/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Apr 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_history_bloc.dart';

abstract class CallHistoryState extends Equatable {
  const CallHistoryState();

  @override
  List<Object?> get props => [];
}

class CallHistoryInitial extends CallHistoryState {}

class CallHistoryLoaded extends CallHistoryState {
  final List<List<CallHistory>> data;
  const CallHistoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CallHistoryLoading extends CallHistoryState {
  const CallHistoryLoading();
}

class CallHistoryError extends CallHistoryState {
  final CallingFailure? failure;
  const CallHistoryError([this.failure]);

  @override
  List<Object?> get props => [failure];
}
