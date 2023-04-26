/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository = sl<UserRepository>();
  final Logger _logger = Logger("User Bloc");

  UserBloc() : super(const UserInitial()) {
    on<UserFetched>(_onFetched);
  }

  void _onFetched(
    UserFetched event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    _logger.info("Getting user data ...");

    try {
      final userData = await userRepository.getProfile(uid: event.uid);

      _logger.fine("Getting user data successfully");
      emit(UserLoaded(userData));
    } on UserFailure catch (e) {
      _logger.shout("Error to get user data");
      emit(UserError(e));
    } catch (e) {
      _logger.shout("Error to get user data");
      emit(const UserError());
    }

    event.completer?.complete();
  }
}
