/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Jan 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late MockLanguageRepository languageRepository;
  late OnesignalRepository onesignalRepository;
  late MockOneSignal onesignal;

  setUp(() {
    languageRepository = MockLanguageRepository();
    onesignal = MockOneSignal();
    onesignalRepository = OnesignalRepository(
      languageRepository: languageRepository,
      oneSignal: onesignal,
    );
  });

  group("Functions", () {
    group("updateLanguage", () {
      test(
        "Should update the onesignal language only when last selected language is different with onesignal language",
        () async {
          const deviceLanguage = DeviceLanguage.indonesian;
          const onesignalLanguage = DeviceLanguage.english;

          when(languageRepository.getLastChanged())
              .thenAnswer((_) => Future.value(deviceLanguage));
          when(languageRepository.getLastChangedOnesignal())
              .thenAnswer((_) => Future.value(onesignalLanguage));

          when(onesignal.setLanguage(deviceLanguage.toLocale().languageCode))
              .thenAnswer((_) => Future.value({}));

          final result = await onesignalRepository.updateLanguage();

          expect(result, true);

          verify(languageRepository.getLastChanged()).called(1);
          verify(languageRepository.getLastChangedOnesignal()).called(1);
          verify(onesignal.setLanguage(deviceLanguage.toLocale().languageCode))
              .called(1);
          verify(languageRepository.updateLastChangedOnesignal(deviceLanguage))
              .called(1);
        },
      );

      test(
        "Should ignore the update onesignal language when device language is same",
        () async {
          const deviceLanguage = DeviceLanguage.indonesian;
          const onesignalLanguage = DeviceLanguage.indonesian;

          when(languageRepository.getLastChanged())
              .thenAnswer((_) => Future.value(deviceLanguage));
          when(languageRepository.getLastChangedOnesignal())
              .thenAnswer((_) => Future.value(onesignalLanguage));

          final result = await onesignalRepository.updateLanguage();

          expect(result, true);

          verify(languageRepository.getLastChanged()).called(1);
          verify(languageRepository.getLastChangedOnesignal()).called(1);
          verifyNever(onesignal.setLanguage(any));
          verifyNever(languageRepository.updateLastChangedOnesignal(any));
        },
      );

      test(
        "Should ignore the update onesignal language when device language is not selected",
        () async {
          when(languageRepository.getLastChanged())
              .thenAnswer((_) => Future.value(null));

          final result = await onesignalRepository.updateLanguage();

          expect(result, true);

          verify(languageRepository.getLastChanged()).called(1);
          verifyNever(languageRepository.getLastChangedOnesignal());
          verifyNever(onesignal.setLanguage(any));
          verifyNever(languageRepository.updateLastChangedOnesignal(any));
        },
      );

      test(
        "Should return false when onesignal update language thrown exception",
        () async {
          const deviceLanguage = DeviceLanguage.indonesian;
          const onesignalLanguage = DeviceLanguage.english;

          when(languageRepository.getLastChanged())
              .thenAnswer((_) => Future.value(deviceLanguage));
          when(languageRepository.getLastChangedOnesignal())
              .thenAnswer((_) => Future.value(onesignalLanguage));

          when(onesignal.setLanguage(deviceLanguage.toLocale().languageCode))
              .thenThrow(Exception());

          final result = await onesignalRepository.updateLanguage();

          expect(result, false);

          verify(languageRepository.getLastChanged()).called(1);
          verify(languageRepository.getLastChangedOnesignal()).called(1);
          verify(onesignal.setLanguage(deviceLanguage.toLocale().languageCode))
              .called(1);
          verifyNever(languageRepository.updateLastChangedOnesignal(any));
        },
      );
    });
  });
}
