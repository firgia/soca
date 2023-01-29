/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Jan 26 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:auto_animated/auto_animated.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../injection.dart';
import '../../../core/core.dart';
import '../../../logic/logic.dart';
import '../../../config/config.dart';
import '../../widgets/widgets.dart';

class LanguageScreen extends StatelessWidget {
  late final LanguageBloc languageBloc;

  LanguageScreen({super.key}) {
    languageBloc = sl<LanguageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    _updateLanguageState(context);

    return Scaffold(
      body: CustomAppBar(
        key: const Key("app-bar"),
        title: LocaleKeys.language.tr(),
        body: BlocBuilder<LanguageBloc, LanguageState>(
          bloc: languageBloc,
          builder: (context, state) {
            final isLoading = state is LanguageLoading;

            return IgnorePointer(
              ignoring: isLoading,
              child: _buildLanguageItems(),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: _buildNextButton(context),
        ),
      ),
    );
  }

  Widget _buildLanguageItems() {
    return SafeArea(
      key: const Key("language-items"),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
          ),
          padding: const EdgeInsets.all(kDefaultSpacing * 1.5),
          child: LiveGrid(
            itemBuilder: (context, index, animation) {
              return FadeAndSlideAnimation(
                animation: animation,
                child: BlocBuilder<LanguageBloc, LanguageState>(
                  bloc: languageBloc,
                  builder: (context, state) {
                    final deviceLanguage = DeviceLanguage.values[index];
                    bool isSelected = false;

                    if (state is LanguageSelected) {
                      isSelected = deviceLanguage == state.language;
                    }

                    return FlagButton(
                      language: deviceLanguage,
                      onPressed: () => _changeLanguage(context, deviceLanguage),
                      selected: isSelected,
                    );
                  },
                ),
              );
            },
            showItemDuration: const Duration(milliseconds: 400),
            showItemInterval: const Duration(milliseconds: 40),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: DeviceLanguage.values.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      bloc: languageBloc,
      builder: (context, state) {
        final isLoading = state is LanguageLoading;

        return AsyncButton(
          key: const Key("next-button"),
          isLoading: isLoading,
          // TODO: Implement this
          ///  onPressed: () => controller.next(),
          onPressed: () {},
          style: FlatButtonStyle(expanded: true, size: ButtonSize.large),
          child: const Text(LocaleKeys.next).tr(),
        );
      },
    );
  }

  /// Change current language
  void _changeLanguage(BuildContext context, DeviceLanguage language) {
    context.setLocale(language.toLocale());
    _updateLanguageState(context);
  }

  /// Updating UI Language
  void _updateLanguageState(BuildContext context) {
    final updatedLanguage = context.locale.toDeviceLanguage();
    languageBloc.add(LanguageChanged(updatedLanguage));
  }
}
