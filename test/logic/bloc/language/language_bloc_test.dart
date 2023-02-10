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
import 'package:soca/core/core.dart';
import 'package:soca/logic/bloc/bloc.dart';

import '../../../helper/helper.dart';

void main() {
  group("LanguageBloc", () {
    setUp(() => registerLocator());
    tearDown(() => unregisterLocator());

    createLanguageBloc() => LanguageBloc();

    group("LanguageChanged", () {
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
  });
}
