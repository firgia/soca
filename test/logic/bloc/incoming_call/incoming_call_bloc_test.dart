/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group(".add", () {
    group("IncomingCallEventAdded", () {
      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallLoaded] when successfully to add event',
        build: () => IncomingCallBloc(),
        act: (bloc) => bloc.add(
          IncomingCallEventAdded(
            CallEvent(
              {
                "extra": {
                  "uuid": "123",
                  "type": "incoming_video_call",
                  "user_caller": {
                    "uid": "123",
                    "name": "Test",
                    "avatar": "test.jpg",
                    "type": "blind",
                    "gender": "male",
                    "date_of_birth": null,
                  }
                }
              },
              Event.ACTION_CALL_ACCEPT,
            ),
          ),
        ),
        expect: () => const <IncomingCallState>[
          IncomingCallLoaded(
            id: "123",
            blindID: "123",
            name: "Test",
            urlImage: "test.jpg",
          ),
        ],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should not emits anything when CallEvent is not Event.ACTION_CALL_ACCEPT',
        build: () => IncomingCallBloc(),
        act: (bloc) => bloc.add(
          IncomingCallEventAdded(
            CallEvent(
              {
                "extra": {
                  "uuid": "123",
                  "type": "incoming_video_call",
                  "user_caller": {
                    "uid": "123",
                    "name": "Test",
                    "avatar": "test.jpg",
                    "type": "blind",
                    "gender": "male",
                    "date_of_birth": null,
                  }
                }
              },
              Event.ACTION_CALL_CALLBACK,
            ),
          ),
        ),
        expect: () => const <IncomingCallState>[],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallEmpty] when callID, blindID is null or'
        ' is not incoming video call',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.add(
            IncomingCallEventAdded(
              CallEvent(
                {
                  "extra": {
                    "uuid": "123",
                    "type": "incoming_video",
                    "user_caller": {
                      "uid": "123",
                      "name": "Test",
                      "avatar": "test.jpg",
                      "type": "blind",
                      "gender": "male",
                      "date_of_birth": null,
                    }
                  }
                },
                Event.ACTION_CALL_ACCEPT,
              ),
            ),
          );

          bloc.add(
            IncomingCallEventAdded(
              CallEvent(
                {
                  "extra": {
                    "uuid": null,
                    "type": "incoming_video",
                    "user_caller": {
                      "uid": "123",
                      "name": "Test",
                      "avatar": "test.jpg",
                      "type": "blind",
                      "gender": "male",
                      "date_of_birth": null,
                    }
                  }
                },
                Event.ACTION_CALL_ACCEPT,
              ),
            ),
          );

          bloc.add(
            IncomingCallEventAdded(
              CallEvent(
                {
                  "extra": {
                    "uuid": "123",
                    "type": "incoming_video_call",
                    "user_caller": {
                      "uid": null,
                      "name": "Test",
                      "avatar": "test.jpg",
                      "type": "blind",
                      "gender": "male",
                      "date_of_birth": null,
                    }
                  }
                },
                Event.ACTION_CALL_ACCEPT,
              ),
            ),
          );
        },
        expect: () => const <IncomingCallState>[
          IncomingCallEmpty(),
        ],
      );
    });

    group("IncomingCallEventRemoved", () {
      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallEmpty] when successfully to remove event',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": "123",
                "type": "incoming_video_call",
                "user_caller": {
                  "uid": "123",
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_ACCEPT,
          );

          bloc.add(const IncomingCallEventRemoved());
        },
        expect: () => const <IncomingCallState>[
          IncomingCallEmpty(),
        ],
        verify: (bloc) {
          expect(bloc.tempCallEvent, null);
        },
      );
    });

    group("IncomingCallFetched", () {
      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallLoaded] when successfully to add event',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": "123",
                "type": "incoming_video_call",
                "user_caller": {
                  "uid": "123",
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_ACCEPT,
          );

          bloc.add(const IncomingCallFetched());
        },
        expect: () => const <IncomingCallState>[
          IncomingCallLoaded(
            id: "123",
            blindID: "123",
            name: "Test",
            urlImage: "test.jpg",
          ),
        ],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should not emits anything when CallEvent is not Event.ACTION_CALL_ACCEPT',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": "123",
                "type": "incoming_video_call",
                "user_caller": {
                  "uid": "123",
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_CALLBACK,
          );

          bloc.add(const IncomingCallFetched());
        },
        expect: () => const <IncomingCallState>[],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallEmpty] when callID is null',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": null,
                "type": "incoming_video_call",
                "user_caller": {
                  "uid": "3",
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_ACCEPT,
          );

          bloc.add(const IncomingCallFetched());
        },
        expect: () => const <IncomingCallState>[
          IncomingCallEmpty(),
        ],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallEmpty] when blindID is null',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": "123",
                "type": "incoming_video_call",
                "user_caller": {
                  "uid": null,
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_ACCEPT,
          );

          bloc.add(const IncomingCallFetched());
        },
        expect: () => const <IncomingCallState>[
          IncomingCallEmpty(),
        ],
      );

      blocTest<IncomingCallBloc, IncomingCallState>(
        'Should emits [IncomingCallEmpty] when is not incoming video call',
        build: () => IncomingCallBloc(),
        act: (bloc) {
          bloc.tempCallEvent = CallEvent(
            {
              "extra": {
                "uuid": null,
                "type": "incoming_video",
                "user_caller": {
                  "uid": "123",
                  "name": "Test",
                  "avatar": "test.jpg",
                  "type": "blind",
                  "gender": "male",
                  "date_of_birth": null,
                }
              }
            },
            Event.ACTION_CALL_ACCEPT,
          );

          bloc.add(const IncomingCallFetched());
        },
        expect: () => const <IncomingCallState>[
          IncomingCallEmpty(),
        ],
      );
    });
  });
}
