/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_cubit.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageUnselected extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageSelected extends LanguageState {
  final DeviceLanguage language;

  const LanguageSelected(this.language);

  @override
  List<Object> get props => [
        language,
      ];
}
