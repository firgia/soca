/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

/// Firebase cloud functions name
abstract class FunctionName {
  static const String answerCall = "answerCall";
  static const String createCall = "createCall";
  static const String createUser = "createUser";
  static const String declineCall = "declineCall";
  static const String endCall = "endCall";
  static const String getCall = "getCall";
  static const String getCallHistory = "getCallHistory";
  static const String getCallStatistic = "getCallStatistic";
  static const String getMinimumVersionApp = "getMinimumVersionApp";
  static const String getProfileUser = "getProfileUser";
  static const String getRTCCredential = "getRTCCredential";
  static const String onSignIn = "onSignIn";
  static const String getLanguage = "getLanguage";
  static const String getTranslationsLanguage = "getTranslationsLanguage";
  static const String updateCallSettings = "updateCallSettings";
}
