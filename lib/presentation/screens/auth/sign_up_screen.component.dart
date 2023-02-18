/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_screen.dart';

class _HelloText extends StatelessWidget {
  const _HelloText() : super(key: const Key("sign_up_screen_hello_text"));

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.hello,
      style: Theme.of(context).textTheme.headlineLarge,
    ).tr();
  }
}

class _LetsGetStartedText extends StatelessWidget {
  const _LetsGetStartedText()
      : super(key: const Key("sign_up_screen_lets_get_started_text"));

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.lets_get_started,
      style: Theme.of(context).textTheme.headlineLarge,
    ).tr();
  }
}

class _FillInFormText extends StatelessWidget {
  const _FillInFormText()
      : super(key: const Key("sign_up_screen_fill_in_form_text"));

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.fill_in_form_to_continue,
      style: Theme.of(context).textTheme.bodySmall,
    ).tr();
  }
}

class _AuthIconButton extends StatelessWidget with UIMixin {
  const _AuthIconButton()
      : super(key: const Key("sign_up_screen_auth_icon_button"));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        String? email;
        AuthMethod? signInMethod;

        if (state is AccountData) {
          email = state.email;
          signInMethod = state.signInMethod;
        }

        if (signInMethod != null) {
          return AuthIconButton(
            type: signInMethod,
            ontap: () => _showAccount(
              context,
              type: signInMethod!,
              email: email ?? "unknown",
              isMobile: isMobile(context),
              signOutCubit: context.read<SignOutCubit>(),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _AccountCard extends StatelessWidget with UIMixin {
  _AccountCard() : super(key: const Key("sign_up_screen_account_card"));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        String? email;
        AuthMethod? signInMethod;

        if (state is AccountData) {
          email = state.email;
          signInMethod = state.signInMethod;
        }

        if (signInMethod != null) {
          return AccountCard(
            authMethod: signInMethod,
            email: email ?? "unknown",
            onTap: () => _showAccount(
              context,
              email: email ?? "unknown",
              isMobile: isMobile(context),
              type: signInMethod!,
              signOutCubit: context.read<SignOutCubit>(),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _PageTitleText extends StatelessWidget with UIMixin {
  const _PageTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLTR(context) ? Alignment.topLeft : Alignment.topRight,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _PageInfoText extends StatelessWidget {
  const _PageInfoText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall,
      textAlign: TextAlign.center,
    );
  }
}

class _BlindUserButton extends StatelessWidget {
  const _BlindUserButton()
      : super(key: const Key("sign_up_screen_blind_user_button"));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        bool isSelected = state.type == UserType.blind;

        return IllustrationCardButton(
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
}

class _VolunteerUserButton extends StatelessWidget {
  const _VolunteerUserButton()
      : super(key: const Key("sign_up_screen_volunteer_user_button"));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        bool isSelected = state.type == UserType.volunteer;

        return IllustrationCardButton(
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
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpInputBloc, SignUpInputState>(
      builder: (context, state) {
        SignUpInputBloc signUpInputBloc = context.read<SignUpInputBloc>();
        bool enable = state.isCanNext();

        return ElevatedButton(
          key: const Key("sign_up_screen_next_button"),
          onPressed: !enable
              ? null
              : () => signUpInputBloc.add(const SignUpInputNextStep()),
          style: FlatButtonStyle(expanded: true),
          child: const Text(LocaleKeys.next).tr(),
        );
      },
    );
  }
}

class _BackIconButton extends StatelessWidget with UIMixin {
  const _BackIconButton()
      : super(key: const Key("sign_up_screen_back_icon_button"));

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          context.read<SignUpInputBloc>().add(const SignUpInputBackStep()),
      color: AppColors.fontPallets[2],
      icon: Icon(
        isRTL(context)
            ? FontAwesomeIcons.arrowRight
            : FontAwesomeIcons.arrowLeftLong,
      ),
    );
  }
}

class _AddLanguageButton extends StatelessWidget {
  const _AddLanguageButton({
    required this.onPressed,
  }) : super(key: const Key("sign_up_screen_add_language_button"));

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(
        CustomIcons.add,
        size: 18,
      ),
      onPressed: onPressed,
      label: const Text(LocaleKeys.add).tr(),
      style: OutlinedButtonStyle(expanded: true),
    );
  }
}

/// Showing account to sign out with bottomsheet or dialog
void _showAccount(
  BuildContext context, {
  required AuthMethod type,
  required String email,
  required bool isMobile,
  required SignOutCubit signOutCubit,
}) {
  buildContent() => Column(
        children: [
          AccountCard.large(
            authMethod: type,
            email: email,
          ),
          const Spacer(),
          BlocBuilder<SignOutCubit, SignOutState>(
            bloc: signOutCubit,
            builder: (context, state) {
              return SignOutButton(
                onPressed: (() {
                  if (isMobile) {
                    AppBottomSheet(context).close();
                  } else {
                    AppDialog(context).close();
                  }

                  signOutCubit.signOut();
                }),
                isLoading: state is SignOutLoading,
              );
            },
          ),
        ],
      );

  if (isMobile) {
    AppBottomSheet(context).show(
      height: 330,
      childBuilder: (context, brightness) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing * 2),
            child: buildContent(),
          ),
        );
      },
    );
  } else {
    AppDialog(context).show(
      childBuilder: (context, brightness) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 330),
          padding: const EdgeInsets.all(kDefaultSpacing * 2),
          child: buildContent(),
        );
      },
    );
  }
}
