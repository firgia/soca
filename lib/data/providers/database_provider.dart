/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../../injection.dart';

class DatabaseProvider {
  final FirebaseDatabase _database = sl<FirebaseDatabase>();

  /// Gets the most up-to-date result for this query.
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
}
