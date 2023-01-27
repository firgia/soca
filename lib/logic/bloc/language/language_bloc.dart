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
import '../../../data/data.dart';
import '../../../core/core.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  late final LanguageRepository _languageRepository;

  LanguageBloc({
    required LanguageRepository languageRepository,
  })  : _languageRepository = languageRepository,
        super(const LanguageUnselected()) {
    on<LanguageChanged>(_onChanged);
  }

  Future<void> _onChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    final language = event.language;
    emit(const LanguageLoading());
    await _languageRepository.updateLastChanged(language);

    if (language != null) {
      emit(LanguageSelected(language));
    } else {
      emit(const LanguageUnselected());
    }
  }
}
