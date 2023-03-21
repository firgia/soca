/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/bloc/bloc.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockUserRepository userRepository;

  setUp(() {
    registerLocator();
    userRepository = getMockUserRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    group("UserFetched()", () {
      MockCompleter completer = MockCompleter();

      blocTest<UserBloc, UserState>(
        'Should emits [UserLoading, UserLoaded] when Successfully to get user data',
        build: () => UserBloc(),
        setUp: () {
          when(userRepository.getProfile(uid: anyNamed("uid"))).thenAnswer(
            (_) => Future.value(
              const User(
                id: "1234",
                name: "Firgia",
              ),
            ),
          );
        },
        act: (bloc) => bloc.add(const UserFetched()),
        expect: () => const <UserState>[
          UserLoading(),
          UserLoaded(
            User(
              id: "1234",
              name: "Firgia",
            ),
          ),
        ],
      );

      blocTest<UserBloc, UserState>(
        'Should emits [UserLoading, UserError] when Error to get user data',
        build: () => UserBloc(),
        setUp: () {
          when(userRepository.getProfile(uid: anyNamed("uid")))
              .thenThrow(const UserFailure());
        },
        act: (bloc) => bloc.add(const UserFetched()),
        expect: () => const <UserState>[
          UserLoading(),
          UserError(UserFailure()),
        ],
      );

      blocTest<UserBloc, UserState>(
        'Should call complete the completer when available',
        build: () => UserBloc(),
        setUp: () {
          completer = MockCompleter();
          when(userRepository.getProfile(uid: anyNamed("uid")))
              .thenThrow(const UserFailure());
        },
        act: (bloc) => bloc.add(UserFetched(completer: completer)),
        verify: (bloc) {
          verify(completer.complete(any));
        },
      );

      blocTest<UserBloc, UserState>(
        'Should put uid to userRepository when available',
        build: () => UserBloc(),
        setUp: () {
          when(userRepository.getProfile(uid: anyNamed("uid")))
              .thenThrow(const UserFailure());
        },
        act: (bloc) => bloc.add(const UserFetched(uid: "5123")),
        verify: (bloc) {
          verify(userRepository.getProfile(uid: "5123"));
        },
      );

      blocTest<UserBloc, UserState>(
        'Should not put uid to userRepository when unavailable',
        build: () => UserBloc(),
        setUp: () {
          when(userRepository.getProfile(uid: anyNamed("uid")))
              .thenThrow(const UserFailure());
        },
        act: (bloc) => bloc.add(const UserFetched()),
        verify: (bloc) {
          verify(userRepository.getProfile(uid: null));
        },
      );
    });
  });
}
