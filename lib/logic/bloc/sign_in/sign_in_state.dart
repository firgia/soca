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
abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInLoading extends SignInState {
  const SignInLoading();
}

class SignInFailed extends SignInState {
  const SignInFailed();
}

class SignInSuccessfully extends SignInState {
  const SignInSuccessfully();
}

class SignInWithAppleError extends SignInState {
  const SignInWithAppleError(this.failure);
  final SignInWithAppleFailure failure;

  @override
  List<Object?> get props => [failure];
}

class SignInWithGoogleError extends SignInState {
  const SignInWithGoogleError(this.failure);
  final SignInWithGoogleFailure failure;

  @override
  List<Object?> get props => [failure];
}

class SignInError extends SignInState {
  const SignInError();
}
