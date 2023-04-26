/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'incoming_call_bloc.dart';

abstract class IncomingCallState extends Equatable {
  const IncomingCallState();

  @override
  List<Object?> get props => [];
}

class IncomingCallInitial extends IncomingCallState {
  const IncomingCallInitial();
}

class IncomingCallLoaded extends IncomingCallState {
  final String id;
  final String blindID;
  final String? name;
  final String? urlImage;

  const IncomingCallLoaded({
    required this.id,
    required this.blindID,
    required this.name,
    required this.urlImage,
  });

  @override
  List<Object?> get props => [
        id,
        blindID,
        name,
        urlImage,
      ];
}

class IncomingCallEmpty extends IncomingCallState {
  const IncomingCallEmpty();
}
