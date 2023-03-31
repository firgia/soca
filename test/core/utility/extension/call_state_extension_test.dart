/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".getFromName()", () {
    test('Should return [CallState.ended] when name is ended', () {
      expect(CallStateExtension.getFromName("ended"), CallState.ended);
    });

    test(
        'Should return [CallState.endedWithCanceled] when name is '
        'ended_with_canceled', () {
      expect(CallStateExtension.getFromName("ended_with_canceled"),
          CallState.endedWithCanceled);
    });

    test(
        'Should return [CallState.endedWithDeclined] when name is '
        'ended_with_declined', () {
      expect(CallStateExtension.getFromName("ended_with_declined"),
          CallState.endedWithDeclined);
    });

    test(
        'Should return [CallState.endedWithUnanswered] when name is '
        'ended_with_unanswered', () {
      expect(CallStateExtension.getFromName("ended_with_unanswered"),
          CallState.endedWithUnanswered);
    });

    test('Should return [CallState.ongoing] when name is ongoing', () {
      expect(CallStateExtension.getFromName("ongoing"), CallState.ongoing);
    });

    test('Should return [CallState.waiting] when name is waiting', () {
      expect(CallStateExtension.getFromName("waiting"), CallState.waiting);
    });
  });
}
