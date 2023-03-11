/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_out_cubit.dart';

@immutable
abstract class SignOutState {
  const SignOutState();
}

class SignOutInitial extends SignOutState {
  const SignOutInitial();
}

class SignOutLoading extends SignOutState {
  const SignOutLoading();
}

class SignOutError extends SignOutState {
  const SignOutError();
}

class SignOutSuccessfully extends SignOutState {
  const SignOutSuccessfully();
}
