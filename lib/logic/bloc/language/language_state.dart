/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageLoading extends LanguageState {
  const LanguageLoading();
}

class LanguageUnselected extends LanguageState {
  const LanguageUnselected();
}

class LanguageSelected extends LanguageState {
  final DeviceLanguage language;
  const LanguageSelected(this.language);

  @override
  List<Object?> get props => [
        language,
      ];
}

class LanguageLoaded extends LanguageState {
  final List<Language> languages;
  const LanguageLoaded(this.languages);

  @override
  List<Object?> get props => [
        languages,
      ];
}
