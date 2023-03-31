/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import '../../injection.dart';

abstract class FunctionsProvider {
  /// Call the firebase functons
  ///
  /// {@macro firebase_functions_exception}
  Future<dynamic> call({
    required String functionsName,
    dynamic parameters,
  });
}

class FunctionsProviderImpl implements FunctionsProvider {
  final FirebaseFunctions _functions = sl<FirebaseFunctions>();

  @override
  Future<dynamic> call({
    required String functionsName,
    dynamic parameters,
  }) async {
    final result = await _functions
        .httpsCallable(functionsName)
        .call(parameters)
        .timeout(const Duration(seconds: 60));

    return jsonDecode(jsonEncode(result.data));
  }
}
