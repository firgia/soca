/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'incoming_call_bloc.dart';

abstract class IncomingCallEvent extends Equatable {
  const IncomingCallEvent();

  @override
  List<Object> get props => [];
}

class IncomingCallEventAdded extends IncomingCallEvent {
  final CallEvent data;
  const IncomingCallEventAdded(this.data);

  @override
  List<Object> get props => [data];
}

class IncomingCallEventRemoved extends IncomingCallEvent {
  const IncomingCallEventRemoved();
}

class IncomingCallFetched extends IncomingCallEvent {
  const IncomingCallFetched();
}
