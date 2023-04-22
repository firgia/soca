/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockCallingRepository callingRepository;
  late MockCallKit callKit;
  late MockUserRepository userRepository;

  setUp(() {
    registerLocator();
    callingRepository = getMockCallingRepository();
    callKit = getMockCallKit();
    userRepository = getMockUserRepository();
  });

  tearDown(() => unregisterLocator());

  group("add()", () {
    group("CallActionCreated()", () {
      Call call = const Call(
        id: "1234",
        users: UserCall(
          blindID: "1111111",
          volunteerID: "22222222",
        ),
        state: CallState.ongoing,
        rtcChannelID: "123456",
      );

      User blindUser = const User(
        id: "1111111",
        name: "Blind user",
        type: UserType.blind,
        avatar: URLImage(
          small: "https://www.w3schools.com/w3images/avatar2.png",
        ),
      );

      User volunteerUser = const User(
        id: "22222222",
        name: "Volunteer user",
        type: UserType.volunteer,
        avatar: URLImage(
          small: "https://www.w3schools.com/w3images/avatar2.png",
        ),
      );

      RTCCredential rtcCredential = const RTCCredential(
        channelName: "calling",
        privilegeExpiredTimeSeconds: 50,
        token: "000-123",
        uid: 1,
      );

      blocTest<CallActionBloc, CallActionState>(
        'Should emits [CallActionLoading, '
        'CallActionCreatedSuccessfullyWithWaitingAnswer, '
        'CallActionCreatedSuccessfully] when successfully to create call',
        build: () => CallActionBloc(),
        act: (bloc) => bloc.add(const CallActionCreated()),
        setUp: () {
          when(callingRepository.createCall()).thenAnswer(
            (_) => Future.value(call),
          );

          when(callingRepository.onCallStateUpdated(call.id)).thenAnswer(
            (realInvocation) => Stream.value(CallState.ongoing),
          );

          when(callingRepository.getCall(call.id)).thenAnswer(
            (_) => Future.value(call),
          );

          when(userRepository.getProfile(uid: call.users?.blindID)).thenAnswer(
            (_) => Future.value(blindUser),
          );

          when(userRepository.getProfile(uid: call.users?.volunteerID))
              .thenAnswer(
            (_) => Future.value(volunteerUser),
          );

          when(callingRepository.getRTCCredential(
                  channelName: call.rtcChannelID,
                  role: RTCRole.publisher,
                  userType: UserType.blind))
              .thenAnswer(
            (_) => Future.value(rtcCredential),
          );
        },
        expect: () => <CallActionState>[
          const CallActionLoading(CallActionType.created),
          CallActionCreatedSuccessfullyWithWaitingAnswer(call),
          CallActionCreatedSuccessfully(
            CallingSetup(
              rtc: RTCIdentity(
                token: rtcCredential.token ?? "",
                channelName: rtcCredential.channelName ?? "",
                uid: rtcCredential.uid ?? 0,
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
              id: call.id!,
            ),
          )
        ],
        verify: (_) {
          verifyInOrder([
            callingRepository.createCall(),
            callingRepository.onCallStateUpdated(call.id),
            callingRepository.getCall(call.id),
            userRepository.getProfile(uid: call.users?.blindID),
            userRepository.getProfile(uid: call.users?.volunteerID),
            callingRepository.getRTCCredential(
              channelName: call.rtcChannelID,
              role: RTCRole.publisher,
              userType: UserType.blind,
            ),
            callKit.startCall(CallKitArgument(
              id: call.id,
              nameCaller: volunteerUser.name,
              handle: LocaleKeys.volunteer.tr(),
              type: 1,
            )),
          ]);
        },
      );

      blocTest<CallActionBloc, CallActionState>(
        'Should emits [CallActionLoading, '
        'CallActionCreatedSuccessfullyWithWaitingAnswer, '
        'CallActionCreatedUnanswered] when remote user not answer the call',
        build: () => CallActionBloc(),
        act: (bloc) => bloc.add(const CallActionCreated()),
        setUp: () {
          when(callingRepository.createCall()).thenAnswer(
            (_) => Future.value(call),
          );

          when(callingRepository.onCallStateUpdated(call.id)).thenAnswer(
            (realInvocation) => Stream.value(CallState.endedWithUnanswered),
          );
        },
        expect: () => <CallActionState>[
          const CallActionLoading(CallActionType.created),
          CallActionCreatedSuccessfullyWithWaitingAnswer(call),
          const CallActionCreatedUnanswered()
        ],
        verify: (_) {
          verifyInOrder([
            callingRepository.createCall(),
            callingRepository.onCallStateUpdated(call.id),
          ]);
        },
      );

      blocTest<CallActionBloc, CallActionState>(
        'Should emits [CallActionLoading, CallActionError] when error to '
        'create call',
        build: () => CallActionBloc(),
        act: (bloc) => bloc.add(const CallActionCreated()),
        setUp: () {
          when(callingRepository.createCall())
              .thenThrow(const CallingFailure());
        },
        expect: () => <CallActionState>[
          const CallActionLoading(CallActionType.created),
          const CallActionError(CallActionType.created, CallingFailure()),
        ],
      );
    });

    group("CallActionEnded()", () {
      blocTest<CallActionBloc, CallActionState>(
        'Should emits [CallActionLoading, CallActionEndedSuccessfully] when '
        'successfully to ended call',
        build: () => CallActionBloc(),
        act: (bloc) => bloc.add(const CallActionEnded("123")),
        expect: () => <CallActionState>[
          const CallActionLoading(CallActionType.ended),
          const CallActionEndedSuccessfully(),
        ],
      );

      blocTest<CallActionBloc, CallActionState>(
        'Should emits [CallActionLoading, CallActionError] when error to '
        'ended the call',
        build: () => CallActionBloc(),
        act: (bloc) => bloc.add(const CallActionEnded("123")),
        setUp: () {
          when(callingRepository.endCall("123"))
              .thenThrow(const CallingFailure());
        },
        expect: () => <CallActionState>[
          const CallActionLoading(CallActionType.ended),
          const CallActionError(CallActionType.ended, CallingFailure()),
        ],
      );
    });
  });
}