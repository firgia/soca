/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import '../../../data/data.dart';
import '../../../core/core.dart';
import '../../../injection.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageRepository _languageRepository = sl<LanguageRepository>();
  final Logger _logger = Logger("Language Bloc");

  LanguageBloc() : super(const LanguageUnselected()) {
    on<LanguageChanged>(_onChanged);
    on<LanguageFetched>(_onFetched);
  }

  Future<void> _onChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    _logger.info("Change the language...");
    final language = event.language;
    emit(const LanguageLoading());
    await _languageRepository.updateLastChanged(language);

    if (language != null) {
      _logger.fine("Successfully change the language to $language");
      emit(LanguageSelected(language));
    } else {
      _logger.info("Unselected Language");
      emit(const LanguageUnselected());
    }
  }

  Future<void> _onFetched(
    LanguageFetched event,
    Emitter<LanguageState> emit,
  ) async {
    _logger.info("Get language...");
    emit(const LanguageLoading());
    List<Language> languages = await _languageRepository.getLanguages();
    _logger.info("Successfully to get language...");
    emit(LanguageLoaded(languages));
  }
}
