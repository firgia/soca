/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _functionsName => "test";

// Mockito cannot generate a valid mock class which implements
// 'HttpsCallableResult' for the following reasons:
//
// The property accessor 'HttpsCallableResult.data' features a non-nullable
// unknown return type, and cannot be stubbed.
//
// So we can create manually in this file
class MockHttpsCallableResult extends Mock implements HttpsCallableResult {}

void main() {
  late MockFirebaseFunctions firebaseFunctions;
  late FunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();
    firebaseFunctions = getMockFirebaseFunctions();
    functionsProvider = FunctionsProvider();
  });

  tearDown(() => unregisterLocator());

  group(".call()", () {
    MockHttpsCallable httpsCallable = MockHttpsCallable();
    MockHttpsCallableResult httpCallableResult = MockHttpsCallableResult();

    test("Should return the data from MockHttpsCallableResult", () async {
      when(httpCallableResult.data).thenReturn({"name": "hello"});
      when(httpsCallable.call())
          .thenAnswer((_) => Future.value(httpCallableResult));
      when(firebaseFunctions.httpsCallable(_functionsName))
          .thenReturn(httpsCallable);

      final result =
          await functionsProvider.call(functionsName: _functionsName);
      expect(result, {"name": "hello"});
    });

    test("Should throw exception when a failure occurs", () async {
      Exception exception = FirebaseFunctionsException(
        message: "unknown",
        code: "unknown",
      );

      when(firebaseFunctions.httpsCallable(_functionsName))
          .thenThrow(exception);

      expect(
        () => functionsProvider.call(functionsName: _functionsName),
        throwsA(exception),
      );
    });
  });
}
