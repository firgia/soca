/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'call_action_event.dart';
part 'call_action_state.dart';

class CallActionBloc extends Bloc<CallActionEvent, CallActionState> {
  final List answeredCallID = [];
  final CallingRepository _callingRepository = sl<CallingRepository>();
  final UserRepository _userRepository = sl<UserRepository>();
  final Logger _logger = Logger("Call Action Bloc");

  StreamSubscription? _stateSub;

  CallActionBloc() : super(const CallActionInitial()) {
    on<_CallActionSetupFetched>(_onSetupFetched);
    on<_CallActionUnanswered>(_onUnanswered);
    on<CallActionAnswered>(_onAnswered);
    on<CallActionCreated>(_onCreated);
    on<CallActionDeclined>(_onDeclined);
    on<CallActionEnded>(_onEnded);
  }

  void _onAnswered(
    CallActionAnswered event,
    Emitter<CallActionState> emit,
  ) async {
    emit(const CallActionLoading(CallActionType.answered));
    _logger.info("Answer call...");

    try {
      late Call call;

      if (answeredCallID.contains(event.callID)) {
        call = await _callingRepository.getCall(event.callID);
      } else {
        call = await _callingRepository.answerCall(
          blindID: event.blindID,
          callID: event.callID,
        );

        answeredCallID.add(event.callID);
      }

      emit(CallActionAnsweredSuccessfullyWithWaitingCaller(call));
      _logger.info("Successfully to answer call, waiting the caller...");

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
          userType: UserType.volunteer,
        );

        if (state is CallActionAnsweredSuccessfullyWithWaitingCaller) {
          _logger.finest("Successfully to get data, starting video calling..");

          CallingSetup callingSetup = CallingSetup(
            rtc: RTCIdentity(
              token: credential.token ?? "",
              channelName: credential.channelName ?? "",
              uid: credential.uid ?? 0,
            ),
            localUser: UserCallIdentity(
              name: volunteerUser.name ?? "",
              uid: volunteerUser.id ?? "",
              avatar: volunteerUser.avatar?.small ?? "",
              type: UserType.volunteer,
            ),
            remoteUser: UserCallIdentity(
              name: blindUser.name ?? "",
              uid: blindUser.id ?? "",
              avatar: blindUser.avatar?.small ?? "",
              type: UserType.blind,
            ),
            id: event.callID,
          );

          emit(CallActionAnsweredSuccessfully(callingSetup));
        } else {
          _logger.finest("Ignoring to emit CallActionAnsweredSuccessfully");
        }
      } else {
        emit(const CallActionError(CallActionType.answered));
      }
    } on CallingFailure catch (e) {
      _logger.shout("Error to answer call");
      emit(CallActionError(CallActionType.answered, e));
    } catch (e) {
      _logger.shout("Error to answer call");
      emit(const CallActionError(CallActionType.answered));
    }
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
      if (e.code == CallingFailureCode.unavailable) {
        _logger.shout("Volunteer is not available");
        emit(const CallActionCreatedUnanswered());
      } else {
        _logger.shout("Error to create call");
        emit(CallActionError(CallActionType.created, e));
      }
    } catch (e) {
      _logger.shout("Error to create call");
      emit(const CallActionError(CallActionType.created));
    }
  }

  void _onDeclined(
    CallActionDeclined event,
    Emitter<CallActionState> emit,
  ) async {
    String blindID = event.blindID;
    String callID = event.callID;

    emit(const CallActionLoading(CallActionType.declined));
    _logger.info("Decline call...");

    try {
      await _callingRepository.declineCall(
        blindID: blindID,
        callID: callID,
      );

      emit(const CallActionDeclinedSuccessfully());
    } on CallingFailure catch (e) {
      _logger.shout("Error to decline call");
      emit(CallActionError(CallActionType.declined, e));
    } catch (e) {
      _logger.shout("Error to decline call");
      emit(const CallActionError(CallActionType.declined));
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

    try {
      await _callingRepository.endCall(callID);

      emit(const CallActionEndedSuccessfully());
    } on CallingFailure catch (e) {
      _logger.shout("Error to end call");
      emit(CallActionError(CallActionType.ended, e));
    } catch (e) {
      _logger.shout("Error to end call");
      emit(const CallActionError(CallActionType.ended));
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
    emit(const CallActionCreatedUnanswered());
  }
}
