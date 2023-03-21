/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

class Parser {
  static T? get<T>(dynamic object) {
    try {
      return object;
    } catch (_) {
      return null;
    }
  }

  /// Make sure dynamic object have a bool value
  ///
  ///
  /// Return `null` if map doesn't have bool value
  static bool? getBool(dynamic object) {
    String? result = object?.toString();

    if (result == "true") {
      return true;
    } else if (result == "false") {
      return false;
    } else {
      return null;
    }
  }

  /// Make sure dynamic object have a double value
  ///
  ///
  /// Return `null` if map doesn't have double value
  static double? getDouble(dynamic object) {
    String? result = object?.toString();
    return (result == null) ? null : double.tryParse(result);
  }

  /// Make sure dynamic object have a int value
  ///
  ///
  /// Return `null` if map doesn't have int value
  static int? getInt(dynamic object) {
    String? result = object?.toString();
    return (result == null) ? null : int.tryParse(result);
  }

  /// Make sure dynamic object have a list of dynamic value
  ///
  ///
  /// Return `null` if map doesn't have list of dynamic value
  static List<dynamic>? getListDynamic(dynamic data) {
    try {
      final List<dynamic> result = data;

      return result;
    } catch (_) {
      return null;
    }
  }

  /// Make sure dynamic object have a list of string value
  ///
  ///
  /// Return `null` if map doesn't have list of string value
  static List<String>? getListString(dynamic object) {
    try {
      List<dynamic>? data = object;

      if (data == null) {
        return null;
      } else {
        List<String> result = [];

        for (dynamic o in data) {
          result.add(o.toString().trim());
        }

        return result;
      }
    } catch (e) {
      return null;
    }
  }

  /// Make sure dynamic object is a map
  ///
  ///
  /// Return `null` if this dynamic object not a valid map
  static Map<String, dynamic>? getMap(dynamic data) {
    try {
      final Map<String, dynamic> result = data;

      return result;
    } catch (_) {
      return null;
    }
  }

  /// Make sure dynamic object have a string value
  ///
  ///
  /// Return `null` if map doesn't have string value
  static String? getString(dynamic object) {
    String? result = object?.toString();
    return (result == null)
        ? null
        : result.trim().isEmpty
            ? null
            : result.trim();
  }
}
