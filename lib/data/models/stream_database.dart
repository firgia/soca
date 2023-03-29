/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamDatabase<T> with EquatableMixin {
  final DatabaseReference databaseReference;
  final StreamController<T> streamController;
  final StreamSubscription streamSubscription;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  StreamDatabase({
    required this.databaseReference,
    required this.streamController,
    required this.streamSubscription,
  });

  @override
  List<Object?> get props => [
        databaseReference,
        streamController,
        streamSubscription,
      ];

  void dispose() {
    streamSubscription.cancel();
    streamController.close();
    databaseReference.keepSynced(false);
    _isDisposed = true;
  }
}
