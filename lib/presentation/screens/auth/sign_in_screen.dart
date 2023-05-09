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
import '../../../logic/logic.dart';
import '../../../config/config.dart';
import '../../../injection.dart';
import '../../presentation.dart';

class SignInScreen extends StatefulWidget with UIMixin {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with UIMixin {
  final AppNavigator appNavigator = sl<AppNavigator>();
  final DeviceFeedback deviceFeedback = sl<DeviceFeedback>();
  final DeviceInfo deviceInfo = sl<DeviceInfo>();
  final SignInBloc signInBloc = sl<SignInBloc>();
  final RouteCubit routeCubit = sl<RouteCubit>();
  bool playSignInInfo = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    playPageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => signInBloc),
        BlocProvider(create: (context) => routeCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RouteCubit, RouteState>(
            listener: (context, state) {
              if (state is RouteTarget) {
                if (state.name == AppPages.home) {
                  appNavigator.goToHome(context);
                } else if (state.name == AppPages.signUp) {
                  appNavigator.goToSignUp(context);
                }
              }

              if (state is RouteError) {
                /// Allow user to retry when got any error
                Alert(context).showSomethingErrorMessage(
                  onActionPressed: () =>
                      routeCubit.getTargetRoute(checkDifferentDevice: false),
                );
              }
            },
          ),
          BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccessfully) {
                playSignInSuccessfully();
                routeCubit.getTargetRoute(checkDifferentDevice: false);
              }
              // Error handling
              else if (state is SignInWithAppleError) {
                SignInWithAppleFailureCode code = state.failure.code;

                if (code != SignInWithAppleFailureCode.canceled) {
                  Alert(context).showAuthenticationErrorMessage(
                    errorCode: code.name,
                  );
                }
              } else if (state is SignInWithGoogleError) {
                SignInWithGoogleFailureCode code = state.failure.code;

                if (code == SignInWithGoogleFailureCode.networkRequestFailed) {
                  Alert(context).showInternetErrorMessage();
                } else {
                  Alert(context).showAuthenticationErrorMessage(
                    errorCode: code.name,
                  );
                }
              } else if (state is SignInError) {
                Alert(context).showAuthenticationErrorMessage();
              }
            },
          ),
        ],
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
    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, routeState) {
        return BlocBuilder<SignInBloc, SignInState>(
          builder: (context, signInState) {
            bool isLoading =
                signInState is SignInLoading || routeState is RouteLoading;

            if (isLoading) {
              return const LoadingPanel();
            } else {
              return const SizedBox();
            }
          },
        );
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

  void playPageInfo() {
    if (mounted) {
      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.va_sign_in_page.tr(),
          LocaleKeys.va_sign_in_required_1.tr(),
          LocaleKeys.va_sign_in_required_2.tr(),
          LocaleKeys.va_sign_in_required_3.tr(),
        ],
        context,
      );
    }
  }

  void playSignInSuccessfully() {
    if (mounted) {
      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.va_sign_in_successfully.tr(),
        ],
        context,
        immediately: true,
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
