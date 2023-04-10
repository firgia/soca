/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:soca/config/config.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'call_action_event.dart';
part 'call_action_state.dart';

class CallActionBloc extends Bloc<CallActionEvent, CallActionState> {
  final CallKit _callKit = sl<CallKit>();
  final CallingRepository _callingRepository = sl<CallingRepository>();
  final UserRepository _userRepository = sl<UserRepository>();
  final Logger _logger = Logger("Call Bloc");

  bool _isOnProcessEndCallDB = false;
  StreamSubscription? _stateSub;

  CallActionBloc() : super(const CallActionInitial()) {
    on<_CallActionSetupFetched>(_onSetupFetched);
    on<_CallActionUnanswered>(_onUnanswered);
    on<CallActionCreated>(_onCreated);
    on<CallActionEnded>(_onEnded);
  }

  void _onCreated(
    CallActionCreated event,
    Emitter<CallActionState> emit,
  ) async {
    emit(const CallActionLoading(CallActionType.created));
    _logger.info("Creating call...");

    try {
      Call call = await _callingRepository.createCall();
      String? callID = call.id;

      emit(CallActionCreatedSuccessfullyWithWaitingAnswer(call));
      _logger.info("Successfully to create call, waiting the answer...");

      if (callID != null) {
        _stateSub =
            _callingRepository.onCallStateUpdated(callID).listen((event) async {
          _logger.info(event.toString());
          if (event == CallState.ongoing) {
            // Volunteer answer the call
            _stateSub?.cancel();
            add(_CallActionSetupFetched(callID));
          } else if (event == CallState.endedWithUnanswered) {
            // Volunteer not answer the call
            _stateSub?.cancel();
            add(const _CallActionUnanswered());
          }
        });
      } else {
        _logger.shout("Call ID not found");
        emit(const CallActionError(CallActionType.created));
      }
    } on CallingFailure catch (e) {
      _logger.shout("Error to create call");
      emit(CallActionError(CallActionType.created, e));
    } catch (e) {
      _logger.shout("Error to create call");
      emit(const CallActionError(CallActionType.created));
    }
  }

  void _onEnded(
    CallActionEnded event,
    Emitter<CallActionState> emit,
  ) async {
    _stateSub?.cancel();
    String callID = event.callID;

    emit(const CallActionLoading(CallActionType.ended));
    _logger.info("End call...");

    if (!_isOnProcessEndCallDB) {
      try {
        _isOnProcessEndCallDB = true;
        await _callingRepository.endCall(callID);

        emit(const CallActionEndedSuccessfully());
      } on CallingFailure catch (e) {
        _logger.shout("Error to end call");
        emit(CallActionError(CallActionType.ended, e));
      } catch (e) {
        _logger.shout("Error to end call");
        emit(const CallActionError(CallActionType.ended));
      } finally {
        _isOnProcessEndCallDB = false;
        _callKit.endAllCalls();
      }
    }
  }

  void _onSetupFetched(
    _CallActionSetupFetched event,
    Emitter<CallActionState> emit,
  ) async {
    String callID = event.callID;

    try {
      Call call = await _callingRepository.getCall(callID);

      String? rtcChannelID = call.rtcChannelID;
      String? blindID = call.users?.blindID;
      String? volunteerID = call.users?.volunteerID;

      if (blindID != null && volunteerID != null && rtcChannelID != null) {
        _logger.info("Getting blind user data..");

        final blindUser = await _userRepository.getProfile(uid: blindID);

        _logger.info("Getting volunteer user data..");
        final volunteerUser =
            await _userRepository.getProfile(uid: volunteerID);

        _logger.info("Getting RTC Credential data..");
        final credential = await _callingRepository.getRTCCredential(
          channelName: rtcChannelID,
          role: RTCRole.publisher,
          userType: UserType.blind,
        );

        _logger.finest("Successfully to get data, starting video calling..");

        await _callKit.startCall(
          CallKitParams(
            id: callID,
            nameCaller: volunteerUser.name,
            handle: LocaleKeys.volunteer.tr(),
            type: 1,
          ),
        );

        CallingSetup callingSetup = CallingSetup(
          rtc: RTCIdentity(
            token: credential.token ?? "",
            channelName: credential.channelName ?? "",
            uid: credential.uid ?? 0,
          ),
          localUser: UserCallIdentity(
            name: blindUser.name ?? "",
            uid: blindUser.id ?? "",
            avatar: blindUser.avatar?.small ?? "",
            type: UserType.blind,
          ),
          remoteUser: UserCallIdentity(
            name: volunteerUser.name ?? "",
            uid: volunteerUser.id ?? "",
            avatar: volunteerUser.avatar?.small ?? "",
            type: UserType.volunteer,
          ),
          id: callID,
        );

        emit(CallActionCreatedSuccessfully(callingSetup));
      } else {
        emit(const CallActionError(CallActionType.created));
      }
    } on CallingFailure catch (e) {
      _logger.shout("Error to create call");
      emit(CallActionError(CallActionType.created, e));
    } catch (e) {
      _logger.shout("Error to create call");
      emit(const CallActionError(CallActionType.created));
    }
  }

  void _onUnanswered(
    _CallActionUnanswered event,
    Emitter<CallActionState> emit,
  ) async {
    await _callKit.endAllCalls();
    emit(const CallActionCreatedUnanswered());
  }
}
