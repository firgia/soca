/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_provider.dart';

abstract class _LanguageProviderInterface {
  /// Get the last saved changed language.
  Future<String?> getLastChanged();

  /// Get the last saved changed Onesignal language.
  Future<String?> getLastChangedOnesignal();

  /// Set the last saved changed language.
  Future<void> setLastChanged(String language);

  /// Set the last saved changed Onesignal language.
  Future<void> setLastChangedOnesignal(String language);

  void dispose();
}
