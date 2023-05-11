/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'language_screen.dart';

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultSpacing * 2,
          vertical: kDefaultSpacing,
        ),
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            final isLoading = state is LanguageLoading;

            return AsyncButton(
              key: const Key("language_screen_back_button"),
              isLoading: isLoading,
              onPressed: () {
                sl<AppNavigator>().back(context);
              },
              style: FlatButtonStyle(expanded: true, size: ButtonSize.large),
              child: const Text(LocaleKeys.back).tr(),
            );
          },
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultSpacing * 2,
          vertical: kDefaultSpacing,
        ),
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            final isLoading = state is LanguageLoading;

            return AsyncButton(
              key: const Key("language_screen_next_button"),
              isLoading: isLoading,
              onPressed: () {
                sl<SettingsCubit>().setHasPickLanguage(true);
                sl<AppNavigator>().goToSplash(context);
              },
              style: FlatButtonStyle(expanded: true, size: ButtonSize.large),
              child: const Text(LocaleKeys.next).tr(),
            );
          },
        ),
      ),
    );
  }
}
