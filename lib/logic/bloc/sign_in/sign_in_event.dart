/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithApple extends SignInEvent {
  const SignInWithApple();

  @override
  List<Object?> get props => [];
}

class SignInWithGoogle extends SignInEvent {
  const SignInWithGoogle();

  @override
  List<Object?> get props => [];
}
