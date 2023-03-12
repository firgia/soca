/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

void main() {
  late DatabaseProvider databaseProvider;
  late MockFirebaseDatabase firebaseDatabase;

  setUp(() {
    registerLocator();
    firebaseDatabase = getMockFirebaseDatabase();
    databaseProvider = DatabaseProvider();
  });

  tearDown(() => unregisterLocator());

  group(".get()", () {
    test("Should set .ref() with [path] parameters", () async {
      String path = "/user-test";

      MockDatabaseReference reference = MockDatabaseReference();
      MockDataSnapshot snapshot = MockDataSnapshot();

      when(snapshot.exists).thenReturn(false);
      when(snapshot.value).thenReturn(null);
      when(reference.get()).thenAnswer((_) => Future.value(snapshot));
      when(firebaseDatabase.ref(path)).thenReturn(reference);

      await databaseProvider.get(path);
      verify(firebaseDatabase.ref(path));
    });

    test(
        "Should return response data when snapshot exists and value is not null",
        () async {
      String path = "/user-test";

      MockDatabaseReference reference = MockDatabaseReference();
      MockDataSnapshot snapshot = MockDataSnapshot();

      when(snapshot.exists).thenReturn(true);
      when(snapshot.value).thenReturn({"id": "1234"});
      when(reference.get()).thenAnswer((_) => Future.value(snapshot));
      when(firebaseDatabase.ref(path)).thenReturn(reference);

      final response = await databaseProvider.get(path);
      expect(response, {"id": "1234"});
    });

    test("Should return null when snapshot doesn't exists", () async {
      String path = "/user-test";

      MockDatabaseReference reference = MockDatabaseReference();
      MockDataSnapshot snapshot = MockDataSnapshot();

      when(snapshot.exists).thenReturn(false);
      when(snapshot.value).thenReturn(null);
      when(reference.get()).thenAnswer((_) => Future.value(snapshot));
      when(firebaseDatabase.ref(path)).thenReturn(reference);

      final response = await databaseProvider.get(path);
      expect(response, isNull);
    });

    test("Should throw exception when a failure occurs", () async {
      String path = "/user-test";
      Exception exception = Exception("unknown");

      when(firebaseDatabase.ref(path)).thenThrow(exception);

      expect(
        () => databaseProvider.get(path),
        throwsA(exception),
      );
    });
  });
}
