/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AuthRepository authRepository = sl<AuthRepository>();
  AccountCubit() : super(const AccountInitial());

  final Logger _logger = Logger("Account Cubit");

  void getAccountData() async {
    _logger.info("Getting account data...");

    emit(const AccountLoading());
    bool isSignedIn = await authRepository.isSignedIn();

    if (isSignedIn) {
      AuthMethod? signInMethod = await authRepository.getSignInMethod();
      String? email = authRepository.email;

      emit(AccountData(email: email, signInMethod: signInMethod));
      _logger.fine("Successfully to get account data");
    } else {
      emit(const AccountEmpty());

      _logger.warning(
          "Failed to get account data because the user has not signed in.");
    }
  }
}
