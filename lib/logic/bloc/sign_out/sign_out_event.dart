/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_out_bloc.dart';

@immutable
abstract class SignOutEvent {
  const SignOutEvent();
}

class SignOutExecute extends SignOutEvent {
  const SignOutExecute();
}
