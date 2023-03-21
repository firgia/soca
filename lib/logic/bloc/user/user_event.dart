/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserFetched extends UserEvent {
  final String? uid;
  final Completer? completer;
  const UserFetched({this.uid, this.completer});

  @override
  List<Object?> get props => [uid, completer];
}

// class UserSearch extends UserEvent {}
