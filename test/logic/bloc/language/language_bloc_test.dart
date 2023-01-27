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

void main() {
  group("LanguageBloc", () {
    group("LanguageChanged", () {
      blocTest<LanguageBloc, LanguageState>(
        'Should emits [LanguageSelected] when LanguageChanged is added with language.',
        build: () => LanguageBloc(),
        act: (bloc) =>
            bloc.add(const LanguageChanged(DeviceLanguage.indonesian)),
        expect: () => const <LanguageState>[
          LanguageSelected(DeviceLanguage.indonesian),
        ],
      );

      blocTest<LanguageBloc, LanguageState>(
        'Should emits [LanguageUnselected] when LanguageChanged is added with empty language.',
        build: () => LanguageBloc(),
        act: (bloc) => bloc.add(const LanguageChanged()),
        expect: () => const <LanguageState>[
          LanguageUnselected(),
        ],
      );
    });
  });
}
