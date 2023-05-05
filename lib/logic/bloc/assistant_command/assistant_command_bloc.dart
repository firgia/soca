/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'assistant_command_event.dart';
part 'assistant_command_state.dart';

class AssistantCommandBloc
    extends Bloc<AssistantCommandEvent, AssistantCommandState> {
  final DeviceInfo deviceInfo = sl<DeviceInfo>();
  final UserRepository userRepository = sl<UserRepository>();
  final Logger _logger = Logger("Assistant Command Bloc");

  AssistantCommandBloc() : super(AssistantCommandInitial()) {
    on<AssistantCommandEventRemoved>((_onEventRemoved));
    on<AssistantCommandEventAdded>(_onEventAdded);
    on<AssistantCommandFetched>(_onFetched);
  }

  AssistantCommandType? tempCommand;

  Future<void> _onEventAdded(
    AssistantCommandEventAdded event,
    Emitter<AssistantCommandState> emit,
  ) async {
    tempCommand = event.data;
    await _fetch(emit);
  }

  Future<void> _onFetched(
    AssistantCommandFetched event,
    Emitter<AssistantCommandState> emit,
  ) async {
    await _fetch(emit);
  }

  void _onEventRemoved(
    AssistantCommandEventRemoved event,
    Emitter<AssistantCommandState> emit,
  ) {
    tempCommand = null;
    emit(const AssistantCommandEmpty());
  }

  Future<void> _fetch(Emitter<AssistantCommandState> emit) async {
    final command = tempCommand;

    if (command == AssistantCommandType.callVolunteer) {
      _logger.info("Getting user data ...");

      try {
        final userData = await userRepository.getProfile();

        _logger.fine("Getting user data successfully");

        if (userData.type == UserType.blind) {
          emit(AssistantCommandCallVolunteerLoaded(
              userData, deviceInfo.localTime));
        } else {
          _logger.fine("Ignoring call volunteer becuase is not blind user");
          tempCommand = null;
          emit(const AssistantCommandEmpty());
        }
      } catch (e) {
        _logger.shout("Error to get user data");
        tempCommand = null;
        emit(const AssistantCommandEmpty());
      }
    } else {
      emit(const AssistantCommandEmpty());
    }
  }
}
