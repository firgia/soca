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
  const _HelloText() : super(key: const Key("sign_up_hello_text"));

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
      : super(key: const Key("sign_up_lets_get_started_text"));

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.lets_get_started,
      style: Theme.of(context).textTheme.headlineLarge,
    ).tr();
  }
}

class _FillInFormText extends StatelessWidget {
  const _FillInFormText() : super(key: const Key("sign_up_fill_in_form_text"));

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.fill_in_form_to_continue,
      style: Theme.of(context).textTheme.bodySmall,
    ).tr();
  }
}

class _AuthIconButton extends StatelessWidget with UIMixin {
  const _AuthIconButton() : super(key: const Key("sign_up_auth_icon_button"));

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
  _AccountCard() : super(key: const Key("sign_up_account_card"));

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
