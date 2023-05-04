/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/// {@template firebase_functions_exception}
/// `Exception`
///
/// A [FirebaseFunctionsException] maybe thrown with the following error code:
///
/// - **unauthenticated**:
/// The request does not have valid authentication credentials for the operation.
///
/// - **not-found**:
/// Thrown if the data is not available.
///
/// - **permission-denied**:
/// Thrown if does not have permission to execute the specified operation.
///
/// - **unavailable**:
/// Thrown if the service is currently unavailable.
///
/// [Explore more FirebaseFunctionsException code](https://firebase.google.com/docs/reference/android/com/google/firebase/functions/FirebaseFunctionsException.Code)
///
///
///  A [TimeoutException] maybe Thrown when a scheduled timeout happens while waiting for an async result.
/// {@endtemplate}

export 'app_provider.dart';
export 'auth_provider.dart';
export 'calling_provider.dart';
export 'database_provider.dart';
export 'device_provider.dart';
export 'functions_provider.dart';
export 'onesignal_provider.dart';
export 'local_language_provider.dart';
export 'user_provider.dart';
