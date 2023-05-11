/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue May 09 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'settings_screen.dart';

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        if (state is AccountData) {
          AuthMethod? authMethod = state.signInMethod;
          String? email = state.email;

          if (authMethod != null && email != null) {
            return Card(
              key: const Key("settings_screen_account_card"),
              margin: const EdgeInsets.only(
                left: kDefaultSpacing,
                right: kDefaultSpacing,
                bottom: kDefaultSpacing * 1.5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: AccountCard(
                  authMethod: authMethod,
                  email: email,
                ),
              ),
            );
          }
        }

        return const SizedBox();
      },
    );
  }
}

class _HapticsFeedbackSwitch extends StatelessWidget {
  const _HapticsFeedbackSwitch();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => current is SettingsValue,
      builder: (context, state) {
        if (state is SettingsValue) {
          return ListTileSwitch(
            key: const Key("settings_screen_haptics"),
            switchKey: const Key("settings_screen_haptics_switch"),
            icon: Icons.vibration_rounded,
            iconColor: Colors.amber,
            title: "Haptics",
            value: state.isHapticsEnable,
            onChanged: (value) {
              context.read<SettingsCubit>().setEnableHaptics(value);
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kBorderRadius),
              topRight: Radius.circular(kBorderRadius),
            ),
            padding: const EdgeInsets.only(
              bottom: kDefaultSpacing * .5,
              right: kDefaultSpacing,
              left: kDefaultSpacing,
              top: kDefaultSpacing,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _VoiceAssistantFeedbackSwitch extends StatelessWidget {
  const _VoiceAssistantFeedbackSwitch();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) => current is SettingsValue,
      builder: (context, state) {
        if (state is SettingsValue) {
          return ListTileSwitch(
            key: const Key("settings_screen_voice_assistant"),
            switchKey: const Key("settings_screen_voice_assistant_switch"),
            icon: Icons.record_voice_over_outlined,
            iconColor: Colors.amber,
            value: state.isVoiceAssistantEnable,
            onChanged: (value) {
              context.read<SettingsCubit>().setEnableVoiceAssistant(value);
            },
            title: "Voice assistant",
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(kBorderRadius),
              bottomRight: Radius.circular(kBorderRadius),
            ),
            padding: const EdgeInsets.only(
              bottom: kDefaultSpacing,
              right: kDefaultSpacing,
              left: kDefaultSpacing,
              top: kDefaultSpacing * .5,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    return PageIconButton(
      key: const Key("settings_screen_language_button"),
      icon: Icons.language,
      label: LocaleKeys.language.tr(),
      iconColor: Colors.grey,
      onPressed: () => sl<AppNavigator>().goToLanguage(context),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key("settings_screen_sign_out_button"),
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: () {
          context.read<SignOutCubit>().signOut();
        },
        child: Padding(
          padding: const EdgeInsets.all(kDefaultSpacing * 1.1),
          child: BrightnessBuilder(builder: (context, brightness) {
            Color color = brightness == Brightness.dark
                ? Colors.redAccent[100]!
                : AppColors.red;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  EvaIcons.logOut,
                  color: color,
                ),
                const SizedBox(width: kDefaultSpacing / 2),
                Text(
                  LocaleKeys.sign_out.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: color),
                ),
                const SizedBox(width: kDefaultSpacing / 2),
              ],
            );
          }),
        ),
      ),
    );
  }
}
