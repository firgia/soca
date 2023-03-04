/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../widgets.dart';

class LanguageSelectionModal with UIMixin {
  late BuildContext context;
  late AppDialog _dialog;
  late AppBottomSheet _bottomSheet;

  LanguageSelectionModal(this.context) {
    _dialog = AppDialog(context);
    _bottomSheet = AppBottomSheet(context);
  }

  Future<void> showSelectionLanguageUI({
    required List<Language> selected,
    required List<Language> selection,
    required Function(Language selected) onSelected,
  }) async {
    if (isTablet(context)) {
      _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
            child: Column(
              children: [
                DialogTitleText(
                  title: LocaleKeys.select_language.tr(),
                  onClosePressed: () => _dialog.close(),
                ),
                Expanded(
                  child: LanguageSelectionCard.builder(
                    selected: selected,
                    selection: selection,
                    onSelected: (value) {
                      onSelected(value);
                      _dialog.close();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      _bottomSheet.show(
        height: MediaQuery.of(context).size.height * .9,
        childBuilder: (context, brightness) {
          return Column(
            children: [
              BottomSheetTitleText(
                title: LocaleKeys.select_language.tr(),
                onClosePressed: () => _bottomSheet.close(),
              ),
              Expanded(
                child: LanguageSelectionCard.builder(
                  selected: selected,
                  selection: selection,
                  onSelected: (value) {
                    onSelected(value);
                    _bottomSheet.close();
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
