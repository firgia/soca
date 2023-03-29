/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _createCall => "createCall";
String get _getCall => "getCall";

void main() {
  late CallingProvider callingProvider;
  late MockFunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();
    functionsProvider = getMockFunctionsProvider();
    callingProvider = CallingProvider();
  });

  tearDown(() => unregisterLocator());

  group(".createCall()", () {
    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(functionsName: _createCall),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.createCall();
      verify(functionsProvider.call(functionsName: _createCall));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(functionsName: _createCall),
      ).thenThrow(exception);

      expect(
        () => callingProvider.createCall(),
        throwsA(exception),
      );
    });
  });

  group(".getCall()", () {
    String callID = "123";

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _getCall,
          parameters: {"id": callID},
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.getCall(callID);
      verify(functionsProvider.call(
        functionsName: _getCall,
        parameters: {"id": callID},
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _getCall,
          parameters: {"id": callID},
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.getCall(callID),
        throwsA(exception),
      );
    });
  });
}
