/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../models/models.dart';
import '../../injection.dart';

abstract class DatabaseProvider {
  /// Gets the most up-to-date result for this query.
  Future<dynamic> get(String path);

  /// Fires when the data at this path is updated.
  StreamDatabase<dynamic> onValue(String path);
}

class DatabaseProviderImpl implements DatabaseProvider {
  final FirebaseDatabase _database = sl<FirebaseDatabase>();

  @override
  Future<dynamic> get(String path) async {
    DatabaseReference ref = _database.ref(path);
    DataSnapshot snapshot =
        await ref.get().timeout(const Duration(seconds: 60));

    if (snapshot.exists && snapshot.value != null) {
      return jsonDecode(jsonEncode(snapshot.value));
    } else {
      return null;
    }
  }

  @override
  StreamDatabase<dynamic> onValue(String path) {
    StreamController<dynamic> controller =
        StreamController<dynamic>.broadcast();
    DatabaseReference reference = _database.ref(path);

    StreamSubscription subscription = reference.onValue.listen(
      (event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists && snapshot.value != null) {
          if (!controller.isClosed) {
            controller.sink.add(jsonDecode(jsonEncode(snapshot.value)));
          }
        } else {
          if (!controller.isClosed) {
            controller.sink.add(null);
          }
        }
      },
      onError: (e, s) => controller.sink.addError(e, s),
      onDone: () => controller.sink.done,
    );

    return StreamDatabase<dynamic>(
      databaseReference: reference,
      streamController: controller,
      streamSubscription: subscription,
    );
  }
}
