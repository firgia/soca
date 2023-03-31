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

String get _answerCall => "answerCall";
String get _getCallStatistic => "getCallStatistic";
String get _createCall => "createCall";
String get _endCall => "endCall";
String get _declineCall => "declineCall";
String get _getCall => "getCall";
String get _getCallHistory => "getCallHistory";
String get _getRTCCredential => "getRTCCredential";
String get _updateCallSettings => "updateCallSettings";

String get _declinedCallIDKey => "declined_call_id";
String get _endedCallIDKey => "ended_call_id";

void main() {
  late CallingProvider callingProvider;
  late MockDatabaseProvider databaseProvider;
  late MockFlutterSecureStorage secureStorage;
  late MockFunctionsProvider functionsProvider;

  setUp(() {
    registerLocator();
    secureStorage = getMockFlutterSecureStorage();
    databaseProvider = getMockDatabaseProvider();
    functionsProvider = getMockFunctionsProvider();
    callingProvider = CallingProviderImpl();
  });

  tearDown(() => unregisterLocator());

  group(".answerCall()", () {
    String callID = "123";
    String blindID = "12345";

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _answerCall,
          parameters: {
            "id": callID,
            "blind_id": blindID,
          },
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.answerCall(
        callID: callID,
        blindID: blindID,
      );

      verify(functionsProvider.call(
        functionsName: _answerCall,
        parameters: {
          "id": callID,
          "blind_id": blindID,
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _answerCall,
          parameters: {
            "id": callID,
            "blind_id": blindID,
          },
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.answerCall(
          callID: callID,
          blindID: blindID,
        ),
        throwsA(exception),
      );
    });
  });

  group(".cancelOnCallSettingUpdated", () {
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
        databaseProvider.onValue("calls/1234/settings"),
      ).thenReturn(streamDatabase);

      callingProvider.onCallSettingUpdated("1234");
      expect(streamDatabase.isDisposed, false);

      callingProvider.cancelOnCallSettingUpdated();
      expect(streamDatabase.isDisposed, true);
    });
  });

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

  group(".cancelOnUserCallUpdated", () {
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
        databaseProvider.onValue("calls/1234/users"),
      ).thenReturn(streamDatabase);

      callingProvider.onUserCallUpdated("1234");
      expect(streamDatabase.isDisposed, false);

      callingProvider.cancelOnUserCallUpdated();
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

  group(".declineCall()", () {
    String callID = "123";
    String blindID = "12345";

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _declineCall,
          parameters: {
            "id": callID,
            "blind_id": blindID,
          },
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.declineCall(
        callID: callID,
        blindID: blindID,
      );
      verify(functionsProvider.call(
        functionsName: _declineCall,
        parameters: {
          "id": callID,
          "blind_id": blindID,
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _declineCall,
          parameters: {
            "id": callID,
            "blind_id": blindID,
          },
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.declineCall(
          callID: callID,
          blindID: blindID,
        ),
        throwsA(exception),
      );
    });
  });

  group(".endCall()", () {
    String callID = "123";

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _endCall,
          parameters: {"id": callID},
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.endCall(callID);
      verify(functionsProvider.call(
        functionsName: _endCall,
        parameters: {"id": callID},
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _endCall,
          parameters: {"id": callID},
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.endCall(callID),
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

  group(".getCallHistory()", () {
    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(functionsName: _getCallHistory),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.getCallHistory();
      verify(functionsProvider.call(functionsName: _getCallHistory));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(functionsName: _getCallHistory),
      ).thenThrow(exception);

      expect(
        () => callingProvider.getCallHistory(),
        throwsA(exception),
      );
    });
  });

  group(".getCallStatistic()", () {
    String year = "2003";
    String locale = "en";

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _getCallStatistic,
          parameters: {
            "year": year,
            "locale": locale,
          },
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.getCallStatistic(
        year: year,
        locale: locale,
      );

      verify(functionsProvider.call(
        functionsName: _getCallStatistic,
        parameters: {
          "year": year,
          "locale": locale,
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _getCallStatistic,
          parameters: {
            "year": year,
            "locale": locale,
          },
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.getCallStatistic(
          year: year,
          locale: locale,
        ),
        throwsA(exception),
      );
    });
  });

  group(".getDeclinedCallID()", () {
    test("Should return data based on storage data", () async {
      when(secureStorage.read(key: _declinedCallIDKey))
          .thenAnswer((_) => Future.value("id"));
      final result = await callingProvider.getDeclinedCallID();
      expect(result, "id");
      verify(secureStorage.read(key: _declinedCallIDKey));
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _declinedCallIDKey))
          .thenAnswer((_) => Future.value(null));
      final result = await callingProvider.getDeclinedCallID();
      expect(result, null);
      verify(secureStorage.read(key: _declinedCallIDKey));
    });
  });

  group(".getEndedCallID()", () {
    test("Should return data based on storage data", () async {
      when(secureStorage.read(key: _endedCallIDKey))
          .thenAnswer((_) => Future.value("id"));
      final result = await callingProvider.getEndedCallID();
      expect(result, "id");
      verify(secureStorage.read(key: _endedCallIDKey));
    });

    test("Should return null when data is not found", () async {
      when(secureStorage.read(key: _endedCallIDKey))
          .thenAnswer((_) => Future.value(null));
      final result = await callingProvider.getEndedCallID();
      expect(result, null);
      verify(secureStorage.read(key: _endedCallIDKey));
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

  group(".onCallSettingUpdated()", () {
    String callID = "1234";

    test("Should call databaseProvider.onValue()", () async {
      when(
        databaseProvider.onValue("calls/$callID/settings"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: StreamController(),
          streamSubscription: StreamController().stream.listen((event) {}),
        ),
      );

      callingProvider.onCallSettingUpdated(callID);
      verify(databaseProvider.onValue("calls/$callID/settings"));
    });

    test("Should return Stream from databaseProvider.onValue()", () async {
      final StreamController<int> streamController = StreamController();

      when(
        databaseProvider.onValue("calls/$callID/settings"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: streamController,
          streamSubscription: streamController.stream.listen((event) {}),
        ),
      );

      Stream stream = callingProvider.onCallSettingUpdated(callID);
      expect(stream, streamController.stream);
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

  group(".onUserCallUpdated()", () {
    String callID = "1234";

    test("Should call databaseProvider.onValue()", () async {
      when(
        databaseProvider.onValue("calls/$callID/users"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: StreamController(),
          streamSubscription: StreamController().stream.listen((event) {}),
        ),
      );

      callingProvider.onUserCallUpdated(callID);
      verify(databaseProvider.onValue("calls/$callID/users"));
    });

    test("Should return Stream from databaseProvider.onValue()", () async {
      final StreamController<int> streamController = StreamController();

      when(
        databaseProvider.onValue("calls/$callID/users"),
      ).thenReturn(
        StreamDatabase(
          databaseReference: MockDatabaseReference(),
          streamController: streamController,
          streamSubscription: streamController.stream.listen((event) {}),
        ),
      );

      Stream stream = callingProvider.onUserCallUpdated(callID);
      expect(stream, streamController.stream);
    });
  });

  group(".setDeclinedCallID()", () {
    test("Should save data to storage", () async {
      await callingProvider.setDeclinedCallID("test");
      verify(secureStorage.write(key: _declinedCallIDKey, value: "test"));
    });
  });

  group(".setEndedCallID()", () {
    test("Should save data to storage", () async {
      await callingProvider.setEndedCallID("test");
      verify(secureStorage.write(key: _endedCallIDKey, value: "test"));
    });
  });

  group(".updateCallSettings()", () {
    String callID = "123";
    bool? enableFlashlight = false;
    bool? enableFlip = false;

    test("Should call functionsProvider.call()", () async {
      when(
        functionsProvider.call(
          functionsName: _updateCallSettings,
          parameters: {
            "id": callID,
            "enable_flashlight": enableFlashlight,
            "enable_flip": enableFlip,
          },
        ),
      ).thenAnswer((_) => Future.value({}));

      await callingProvider.updateCallSettings(
        callID: callID,
        enableFlashlight: enableFlashlight,
        enableFlip: enableFlip,
      );

      verify(functionsProvider.call(
        functionsName: _updateCallSettings,
        parameters: {
          "id": callID,
          "enable_flashlight": enableFlashlight,
          "enable_flip": enableFlip,
        },
      ));
    });

    test("Should thrown Exception when getting error", () async {
      Exception exception = Exception("unknown");

      when(
        functionsProvider.call(
          functionsName: _updateCallSettings,
          parameters: {
            "id": callID,
            "enable_flashlight": enableFlashlight,
            "enable_flip": enableFlip,
          },
        ),
      ).thenThrow(exception);

      expect(
        () => callingProvider.updateCallSettings(
          callID: callID,
          enableFlashlight: enableFlashlight,
          enableFlip: enableFlip,
        ),
        throwsA(exception),
      );
    });
  });
}
