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
    return BlocBuilder<SignUpFormBloc, SignUpFormState>(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageTitleText(LocaleKeys.select_language.tr()),
        const SizedBox(height: 4),
        const Text(LocaleKeys.add_language_desc).tr(),
        const SizedBox(height: kDefaultSpacing),
        Expanded(child: _buildLanguage()),
        const SizedBox(height: kDefaultSpacing),
        BlocBuilder<SignUpFormBloc, SignUpFormState>(
          builder: (context, state) {
            UserType? type = state.type;

            return _PageInfoText(type == UserType.blind
                ? LocaleKeys.select_language_blind_desc.tr()
                : LocaleKeys.select_language_volunteer_desc.tr());
          },
        ),
        const SizedBox(height: kDefaultSpacing),
        const Row(
          children: [
            _BackIconButton(),
            SizedBox(width: kDefaultSpacing),
            Expanded(child: _NextButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguage() {
    return BlocBuilder<SignUpFormBloc, SignUpFormState>(
      builder: (context, state) {
        SignUpFormBloc signUpFormBloc = context.read<SignUpFormBloc>();

        List<Language> selectedLanguages = state.languages ?? [];
        bool isCanAddLanguage = state.isCanAddLanguage();

        return ListView.builder(
          itemCount: selectedLanguages.length + ((isCanAddLanguage) ? 1 : 0),
          itemBuilder: (context, index) {
            bool isTimeToShowAddButton = index == selectedLanguages.length;

            if (isTimeToShowAddButton) {
              return _AddLanguageButton(
                onPressed: () {
                  LanguageBloc languageBloc = context.read<LanguageBloc>();
                  LanguageState languageState = languageBloc.state;

                  if (languageState is LanguageLoaded) {
                    LanguageSelectionModal(context).showSelectionLanguageUI(
                      selected: selectedLanguages,
                      selection: languageState.languages,
                      onSelected: (selected) {
                        signUpFormBloc.add(SignUpFormLanguageAdded(selected));
                      },
                    );
                  } else {
                    languageBloc.add(const LanguageFetched());
                  }
                },
              );
            } else {
              final language = selectedLanguages[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: kDefaultSpacing),
                child: LanguageCard(
                  language,
                  onTapRemove: () {
                    signUpFormBloc.add(SignUpFormLanguageRemoved(language));
                  },
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _PersonalInformationPage extends StatelessWidget {
  const _PersonalInformationPage()
      : super(key: const Key("sign_up_screen_personal_information_page"));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageTitleText(LocaleKeys.personal_information.tr()),
        const SizedBox(height: kDefaultSpacing),
        const _ProfileImageButton(),
        const SizedBox(height: kDefaultSpacing),
        const _NameField(),
        const SizedBox(height: kDefaultSpacing * 1.5),
        _DateOfBirthField(),
        const SizedBox(height: kDefaultSpacing * 2),
        const _GenderButton(),
        const Spacer(),
        _PageInfoText(LocaleKeys.sign_up_rule_desc.tr()),
        const SizedBox(height: kDefaultSpacing),
        const Row(
          children: [
            _BackIconButton(),
            SizedBox(width: kDefaultSpacing),
            Expanded(child: _SaveButton()),
          ],
        ),
      ],
    );
  }
}
