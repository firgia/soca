/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final DeviceLanguage? language;

  const LanguageChanged([this.language]);

  @override
  List<Object?> get props => [
        language,
      ];
}

class LanguageFetched extends LanguageEvent {
  const LanguageFetched();
}
