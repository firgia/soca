/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_action_bloc.dart';

abstract class CallActionState extends Equatable {
  const CallActionState();

  @override
  List<Object?> get props => [];
}

class CallActionInitial extends CallActionState {
  const CallActionInitial();
}

class CallActionLoading extends CallActionState {
  final CallActionType type;
  const CallActionLoading(this.type);

  @override
  List<Object?> get props => [type];
}

class CallActionError extends CallActionState {
  final CallActionType type;
  final CallingFailure? failure;
  const CallActionError(this.type, [this.failure]);

  @override
  List<Object?> get props => [type, failure];
}

class CallActionAnsweredSuccessfullyWithWaitingCaller extends CallActionState {
  final Call data;
  const CallActionAnsweredSuccessfullyWithWaitingCaller(this.data);

  @override
  List<Object?> get props => [data];
}

class CallActionAnsweredSuccessfully extends CallActionState {
  final CallingSetup data;
  const CallActionAnsweredSuccessfully(this.data);

  @override
  List<Object?> get props => [data];
}

/* -------------------------> STATE FOR CREATED <---------------------------- */

class CallActionCreatedSuccessfullyWithWaitingAnswer extends CallActionState {
  final Call data;
  const CallActionCreatedSuccessfullyWithWaitingAnswer(this.data);

  @override
  List<Object?> get props => [data];
}

class CallActionCreatedSuccessfully extends CallActionState {
  final CallingSetup data;
  const CallActionCreatedSuccessfully(this.data);

  @override
  List<Object?> get props => [data];
}

class CallActionCreatedUnanswered extends CallActionState {
  const CallActionCreatedUnanswered();
}

/* --------------------------> STATE FOR ENDED <----------------------------- */

class CallActionDeclinedSuccessfully extends CallActionState {
  const CallActionDeclinedSuccessfully();
}

class CallActionEndedSuccessfully extends CallActionState {
  const CallActionEndedSuccessfully();
}
