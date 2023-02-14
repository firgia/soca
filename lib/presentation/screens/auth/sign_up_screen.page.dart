/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_screen.dart';

class _SignUpFormPage extends StatelessWidget {
  const _SignUpFormPage() : super(key: const Key("sign_up_form_page"));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        SignUpStep step = state.currentStep;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: step == SignUpStep.inputPersonalInformation
              ? const _PersonalInformationPage()
              : step == SignUpStep.selectLanguage
                  ? const _SelectLanguagePage()
                  : const _SelectUserTypePage(),
        );
      },
    );
  }
}

class _SelectUserTypePage extends StatelessWidget {
  const _SelectUserTypePage()
      : super(key: const Key("sign_up_select_user_type_page"));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageTitleText(LocaleKeys.select_user_type.tr()),
        const SizedBox(height: kDefaultSpacing),
        _buildBlindUserButton(),
        const SizedBox(height: kDefaultSpacing),
        _buildVolunteerUserButton(),
        const Spacer(),
        _PageInfoText(LocaleKeys.sign_up_rule_desc.tr()),
        const SizedBox(height: kDefaultSpacing),
        _buildNextButton(),
      ],
    );
  }

  Widget _buildBlindUserButton() {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        bool isSelected = state.type == UserType.blind;

        return IllustrationCardButton(
          key: const Key("sign_up_blind_user_button"),
          selected: isSelected,
          onPressed: () => context
              .read<SignUpInputBloc>()
              .add(const SignUpInputTypeChanged(UserType.blind)),
          subtitle: LocaleKeys.blind_info.tr(),
          title: LocaleKeys.blind.tr(),
          vectorAsset: ImageVector.blindIllustration,
        );
      },
    );
  }

  Widget _buildVolunteerUserButton() {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        bool isSelected = state.type == UserType.volunteer;

        return IllustrationCardButton(
          key: const Key("sign_up_volunteer_user_button"),
          selected: isSelected,
          onPressed: () => context
              .read<SignUpInputBloc>()
              .add(const SignUpInputTypeChanged(UserType.volunteer)),
          subtitle: LocaleKeys.volunteer_info.tr(),
          title: LocaleKeys.volunteer.tr(),
          vectorAsset: ImageVector.greetingIllustration,
        );
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        SignUpInputBloc signUpInputBloc = context.read<SignUpInputBloc>();
        SignUpStep validStep = state.validStep;

        bool enableNextButton = (validStep == SignUpStep.selectLanguage ||
            validStep == SignUpStep.inputPersonalInformation);

        return _NextButton(
          onPressed: () => signUpInputBloc.add(const SignUpInputNextStep()),
          enable: enableNextButton,
        );
      },
    );
  }
}

class _SelectLanguagePage extends StatelessWidget {
  const _SelectLanguagePage()
      : super(key: const Key("sign_up_select_language_page"));

  @override
  Widget build(BuildContext context) {
    return const Text("Select Language Page");
  }
}

class _PersonalInformationPage extends StatelessWidget {
  const _PersonalInformationPage()
      : super(key: const Key("sign_up_select_personal_information_page"));

  @override
  Widget build(BuildContext context) {
    return const Text("Personal Information Page");
  }
}
