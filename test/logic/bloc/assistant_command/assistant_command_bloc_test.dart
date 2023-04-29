/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.dart';

void main() {
  late MockUserRepository userRepository;

  setUp(() {
    registerLocator();
    userRepository = getMockUserRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add", () {
    group("AssistantCommandEventAdded", () {
      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandLoaded] when successfully to add event '
        'with userType is blind',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              const User(type: UserType.blind),
            ),
          );
        },
        act: (bloc) => bloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer),
        ),
        expect: () => const <AssistantCommandState>[
          AssistantCommandCallVolunteerLoaded(
            User(type: UserType.blind),
          )
        ],
        verify: (bloc) {
          verify(userRepository.getProfile());
          expect(bloc.tempCommand, AssistantCommandType.callVolunteer);
        },
      );

      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when successfully to add event '
        'but userType is not blind',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              const User(type: UserType.volunteer),
            ),
          );
        },
        act: (bloc) => bloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer),
        ),
        expect: () => const <AssistantCommandState>[AssistantCommandEmpty()],
        verify: (bloc) {
          verify(userRepository.getProfile());
          expect(bloc.tempCommand, isNull);
        },
      );

      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when failed to get user data',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenThrow(const UserFailure());
        },
        act: (bloc) => bloc.add(
          const AssistantCommandEventAdded(AssistantCommandType.callVolunteer),
        ),
        expect: () => const <AssistantCommandState>[AssistantCommandEmpty()],
        verify: (bloc) {
          verify(userRepository.getProfile());
          expect(bloc.tempCommand, isNull);
        },
      );
    });

    group("AssistantCommandEventRemoved", () {
      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when successfully to remove event',
        build: () => AssistantCommandBloc(),
        act: (bloc) {
          bloc.tempCommand = AssistantCommandType.callVolunteer;

          bloc.add(const AssistantCommandEventRemoved());
        },
        expect: () => const <AssistantCommandState>[
          AssistantCommandEmpty(),
        ],
        verify: (bloc) {
          expect(bloc.tempCommand, null);
        },
      );
    });

    group("AssistantCommandFetched", () {
      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandLoaded] when successfully to add event '
        'with userType is blind',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              const User(type: UserType.blind),
            ),
          );
        },
        act: (bloc) {
          bloc.tempCommand = AssistantCommandType.callVolunteer;
          bloc.add(
            const AssistantCommandFetched(),
          );
        },
        expect: () => const <AssistantCommandState>[
          AssistantCommandCallVolunteerLoaded(
            User(type: UserType.blind),
          )
        ],
        verify: (bloc) {
          verify(userRepository.getProfile());
        },
      );

      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when successfully to add event '
        'but userType is not blind',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenAnswer(
            (_) => Future.value(
              const User(type: UserType.volunteer),
            ),
          );
        },
        act: (bloc) {
          bloc.tempCommand = AssistantCommandType.callVolunteer;
          bloc.add(const AssistantCommandFetched());
        },
        expect: () => const <AssistantCommandState>[AssistantCommandEmpty()],
        verify: (bloc) {
          verify(userRepository.getProfile());
          expect(bloc.tempCommand, isNull);
        },
      );

      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when failed to get user data',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenThrow(const UserFailure());
        },
        act: (bloc) {
          bloc.tempCommand = AssistantCommandType.callVolunteer;

          bloc.add(const AssistantCommandFetched());
        },
        expect: () => const <AssistantCommandState>[AssistantCommandEmpty()],
        verify: (bloc) {
          verify(userRepository.getProfile());
          expect(bloc.tempCommand, isNull);
        },
      );

      blocTest<AssistantCommandBloc, AssistantCommandState>(
        'Should emits [AssistantCommandEmpty] when tempCommand is null',
        build: () => AssistantCommandBloc(),
        setUp: () {
          when(userRepository.getProfile()).thenThrow(const UserFailure());
        },
        act: (bloc) {
          bloc.add(const AssistantCommandFetched());
        },
        expect: () => const <AssistantCommandState>[AssistantCommandEmpty()],
        verify: (bloc) {
          expect(bloc.tempCommand, isNull);
        },
      );
    });
  });
}
