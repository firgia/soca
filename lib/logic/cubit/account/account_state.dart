/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountData extends AccountState {
  final String? email;
  final AuthMethod? signInMethod;

  const AccountData({
    required this.email,
    required this.signInMethod,
  });

  @override
  List<Object?> get props => [
        email,
        signInMethod,
      ];
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountEmpty extends AccountState {
  const AccountEmpty();
}
