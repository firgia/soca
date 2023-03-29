/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 28 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

import '../../helper/helper.dart';
import '../../mock/mock.mocks.dart';

String get _createCall => "createCall";
String get _getCall => "getCall";
String get _getRTCCredential => "getRTCCredential";

void main() {
  late CallingProvider callingProvider;
  late MockDatabaseProvider databaseProvider;
  late MockFunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();
    databaseProvider = getMockDatabaseProvider();
    functionsProvider = getMockFunctionsProvider();
    callingProvider = CallingProvider();
  });

  tearDown(() => unregisterLocator());

  group(".cancelOnCallStateUpdated", () {
    test("Should dispose the [StreamDatabase]", () {
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

      when(
        databaseProvider.onValue("calls/1234/state"),
      ).thenReturn(streamDatabase);

      callingProvider.onCallStateUpdated("1234");
      expect(streamDatabase.isDisposed, false);

      callingProvider.cancelOnCallStateUpdated();
      expect(streamDatabase.isDisposed, true);
    });
  });

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

  group(".getRTCCredential()", () {
    String channelName = "sample";
    int uid = 2;
    RTCRole role = RTCRole.audience;

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _getRTCCredential,
          parameters: {
            "channel_name": channelName,
            "uid": uid,
            "role": role.name,
          },
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.getRTCCredential(
        channelName: channelName,
        role: role,
        uid: uid,
      );

      verify(functionsProvider.call(
        functionsName: _getRTCCredential,
        parameters: {
          "channel_name": channelName,
          "uid": uid,
          "role": role.name,
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _getRTCCredential,
          parameters: {
            "channel_name": channelName,
            "uid": uid,
            "role": role.name,
          },
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.getRTCCredential(
          channelName: channelName,
          role: role,
          uid: uid,
        ),
        throwsA(exception),
      );
    });
  });

  group(".onCallStateUpdated()", () {
    String callID = "1234";

    test("Should call databaseProvider.onValue()", () async {
      when(
        databaseProvider.onValue("calls/$callID/state"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: StreamController(),
          streamSubscription: StreamController().stream.listen((event) {}),
        ),
      );

      callingProvider.onCallStateUpdated(callID);
      verify(databaseProvider.onValue("calls/$callID/state"));
    });

    test("Should return Stream from databaseProvider.onValue()", () async {
      final StreamController<int> streamController = StreamController();

      when(
        databaseProvider.onValue("calls/$callID/state"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: streamController,
          streamSubscription: streamController.stream.listen((event) {}),
        ),
      );

      Stream stream = callingProvider.onCallStateUpdated(callID);
      expect(stream, streamController.stream);
    });
  });
}
