/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/data/data.dart';

import '../../mock/mock.mocks.dart';

void main() {
  group(".dispose()", () {
    test("Should close stream and deactivate sync to Database", () {
      final StreamController<int> streamController = StreamController();
      final MockDatabaseReference databaseReference = MockDatabaseReference();
      final StreamSubscription subscription = streamController.stream.listen(
        (event) {},
      );

      StreamDatabase streamDatabase = StreamDatabase(
        databaseReference: databaseReference,
        streamController: streamController,
        streamSubscription: subscription,
      );

      expect(streamDatabase.isDisposed, false);
      expect(streamController.isClosed, false);
      expect(streamController.hasListener, true);
      verifyNever(databaseReference.keepSynced(false));

      streamDatabase.dispose();
      expect(streamDatabase.isDisposed, true);
      expect(streamController.isClosed, true);
      expect(streamController.hasListener, false);
      verify(databaseReference.keepSynced(false));
    });
  });
}
