/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

import '../../../config/config.dart';
import '../../../injection.dart';
import '../../presentation.dart';

class SignInScreen extends StatelessWidget with UIMixin {
  SignInScreen({super.key});
  final AppNavigator appNavigator = sl<AppNavigator>();
  final DeviceInfo deviceInfo = sl<DeviceInfo>();
  final SignInBloc signInBloc = sl<SignInBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => signInBloc,
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SignInSuccessfully) {
            appNavigator.goToHome(context);
          }
        },
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              SafeArea(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      maxHeight: 1100,
                    ),
                    padding: const EdgeInsets.all(kDefaultSpacing * 1.5),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        SocaIconImage(
                          size: isTablet(context) ? 250 : 200,
                          heroTag: "splash",
                        ),
                        const Spacer(flex: 4),
                        const _SignInText(),
                        const Spacer(flex: 2),
                        _buildLargeSignInButton(),
                        const Spacer(flex: 3),
                        const _VolunteerUserText(),
                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                ),
              ),
              _buildLoading(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        bool isLoading = state is SignInLoading;

        if (isLoading) {
          return const LoadingPanel();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildLargeSignInButton() {
    if (deviceInfo.isIOS()) {
      return Column(
        children: [
          SignInWithAppleButton(
            onPressed: () => signInBloc.add(const SignInWithApple()),
          ),
          const SizedBox(height: kDefaultSpacing * 1.5),
          SignInWithGoogleButton(
            onPressed: () => signInBloc.add(const SignInWithGoogle()),
            reverseBrightnessColor: true,
          ),
        ],
      );
    } else {
      return SignInWithGoogleButton(
        onPressed: () => signInBloc.add(const SignInWithGoogle()),
      );
    }
  }
}

class _SignInText extends StatelessWidget {
  const _SignInText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: BrightnessBuilder(builder: (context, brightness) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.sign_in,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: .8,
                color: AppColors.fontPallets[0],
              ),
              textAlign: TextAlign.center,
            ).tr(),
            Text(
              LocaleKeys.sign_in_info,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.fontPallets[0],
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ).tr(),
          ],
        );
      }),
    );
  }
}

class _VolunteerUserText extends StatelessWidget {
  const _VolunteerUserText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Text(
        LocaleKeys.volunteer_sign_in_info,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ).tr(),
    );
  }
}
