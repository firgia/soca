/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpSuccessfully extends SignUpState {
  const SignUpSuccessfully();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpError extends SignUpState {
  final SignUpFailure? failure;
  const SignUpError([this.failure]);

  @override
  List<Object?> get props =>
      super.props +
      [
        failure,
      ];
}
