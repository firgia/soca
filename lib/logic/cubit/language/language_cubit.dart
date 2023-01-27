/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageUnselected());

  void updateSelection(BuildContext context) {
    final currentLanguage = AppTranslations.getCurrentDeviceLanguage(context);

    if (currentLanguage == null) {
      emit(LanguageUnselected());
    } else {
      emit(LanguageSelected(currentLanguage));
    }
  }

  void change(BuildContext context, DeviceLanguage language) {
    AppTranslations.change(language, context);
    updateSelection(context);
  }
}
