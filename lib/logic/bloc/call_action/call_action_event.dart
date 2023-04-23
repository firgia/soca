/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_action_bloc.dart';

abstract class CallActionEvent extends Equatable {
  const CallActionEvent();

  @override
  List<Object> get props => [];
}

class CallActionAnswered extends CallActionEvent {
  final String blindID;
  final String callID;

  const CallActionAnswered({
    required this.blindID,
    required this.callID,
  });

  @override
  List<Object> get props => [blindID, callID];
}

class CallActionCreated extends CallActionEvent {
  const CallActionCreated();
}

/// This event is only called on the CallActionCreated process
class _CallActionSetupFetched extends CallActionEvent {
  final String callID;
  const _CallActionSetupFetched(this.callID);

  @override
  List<Object> get props => [callID];
}

/// This event is only called on the CallActionCreated process
class _CallActionUnanswered extends CallActionEvent {
  const _CallActionUnanswered();
}

class CallActionDeclined extends CallActionEvent {
  const CallActionDeclined();
}

class CallActionEnded extends CallActionEvent {
  final String callID;
  const CallActionEnded(this.callID);

  @override
  List<Object> get props => [callID];
}
