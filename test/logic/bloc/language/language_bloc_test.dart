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
  late MockLanguageRepository languageRepository;

  setUp(() {
    registerLocator();
    languageRepository = getMockLanguageRepository();
  });

  tearDown(() => unregisterLocator());

  createLanguageBloc() => LanguageBloc();

  group(".add()", () {
    group("LanguageChanged()", () {
      blocTest<LanguageBloc, LanguageState>(
        'Should emits [LanguageLoading, LanguageSelected] when LanguageChanged is added with language.',
        build: () => createLanguageBloc(),
        act: (bloc) =>
            bloc.add(const LanguageChanged(DeviceLanguage.indonesian)),
        expect: () => const <LanguageState>[
          LanguageLoading(),
          LanguageSelected(DeviceLanguage.indonesian),
        ],
      );

      blocTest<LanguageBloc, LanguageState>(
        'Should emits [LanguageLoading, LanguageUnselected] when LanguageChanged is added with empty language.',
        build: () => createLanguageBloc(),
        act: (bloc) => bloc.add(const LanguageChanged()),
        expect: () => const <LanguageState>[
          LanguageLoading(),
          LanguageUnselected(),
        ],
      );
    });

    group("LanguageFetched()", () {
      blocTest<LanguageBloc, LanguageState>(
        'Should emits [LanguageLoading, LanguageLoaded] when LanguageChanged is added',
        build: () => createLanguageBloc(),
        setUp: () {
          when(languageRepository.getLanguages()).thenAnswer(
            (_) => Future.value(
              const [
                Language(
                  code: "id",
                  name: "Indonesian",
                  nativeName: "Bahasa Indonesia",
                ),
                Language(
                  code: "en",
                  name: "English",
                  nativeName: "English",
                ),
              ],
            ),
          );
        },
        act: (bloc) => bloc.add(const LanguageFetched()),
        expect: () => const <LanguageState>[
          LanguageLoading(),
          LanguageLoaded(
            [
              Language(
                code: "id",
                name: "Indonesian",
                nativeName: "Bahasa Indonesia",
              ),
              Language(
                code: "en",
                name: "English",
                nativeName: "English",
              ),
            ],
          ),
        ],
      );
    });
  });
}
