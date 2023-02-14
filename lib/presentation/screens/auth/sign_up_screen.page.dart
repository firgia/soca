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
  const _SignUpFormPage() : super(key: const Key("sign_up_screen_form_page"));

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
      : super(key: const Key("sign_up_screen_select_user_type_page"));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageTitleText(LocaleKeys.select_user_type.tr()),
        const SizedBox(height: kDefaultSpacing),
        const _BlindUserButton(),
        const SizedBox(height: kDefaultSpacing),
        const _VolunteerUserButton(),
        const Spacer(),
        _PageInfoText(LocaleKeys.sign_up_rule_desc.tr()),
        const SizedBox(height: kDefaultSpacing),
        const _NextButton(),
      ],
    );
  }
}

class _SelectLanguagePage extends StatelessWidget {
  const _SelectLanguagePage()
      : super(key: const Key("sign_up_screen_select_language_page"));

  @override
  Widget build(BuildContext context) {
    return const Text("Select Language Page");
  }
}

class _PersonalInformationPage extends StatelessWidget {
  const _PersonalInformationPage()
      : super(
            key: const Key("sign_up_screen_select_personal_information_page"));

  @override
  Widget build(BuildContext context) {
    return const Text("Personal Information Page");
  }
}
