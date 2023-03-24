/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserEmpty extends UserState {
  const UserEmpty();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User data;
  const UserLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class UserError extends UserState {
  final UserFailure? failure;
  const UserError([this.failure]);

  @override
  List<Object?> get props => [failure];
}
