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
import 'package:soca/injection.dart';
import 'package:soca/logic/logic.dart';
import 'package:soca/presentation/presentation.dart';

import '../../../config/config.dart';

part 'sign_up_screen.component.dart';
part 'sign_up_screen.page.dart';

class SignUpScreen extends StatelessWidget
    with UIMixin
    implements ResponsiveLayoutInterface {
  final AppNavigator _appNavigator = sl<AppNavigator>();
  final AccountCubit _accountCubit = sl<AccountCubit>();
  final SignUpBloc _signUpBloc = sl<SignUpBloc>();
  final SignUpInputBloc _signUpInputBloc = sl<SignUpInputBloc>();
  final SignOutCubit _signOutCubit = sl<SignOutCubit>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _accountCubit.getAccountData();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _accountCubit),
        BlocProvider(create: (context) => _signUpBloc),
        BlocProvider(create: (context) => _signUpInputBloc),
        BlocProvider(create: (context) => _signOutCubit),
      ],
      child: WillPopScope(
        onWillPop: () async {
          // TODO: Implement this
          //  controller.back();
          return false;
        },
        child: Scaffold(
          body: MultiBlocListener(
            listeners: [
              BlocListener<SignOutCubit, SignOutState>(
                listener: (context, state) {
                  if (state is SignOutSuccessfully || state is SignOutError) {
                    _appNavigator.goToSplash(context);
                  }
                },
              )
            ],
            child: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                return IgnorePointer(
                  ignoring: state is SignUpLoading,
                  child: ResponsiveBuilder(
                    mobileBuilder: buildMobileLayout,
                    tabletBuilder: buildTabletLayout,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildMobileLayout(BuildContext context, BoxConstraints constraints) {
    return SafeArea(
      key: const Key("sign_up_mobile_layout"),
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(child: _HelloText()),
                _AuthIconButton(),
              ],
            ),
            const _LetsGetStartedText(),
            const SizedBox(height: kDefaultSpacing),
            const _FillInFormText(),
            const Spacer(flex: 1),
            const Flexible(
              flex: 10,
              child: _SignUpFormPage(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTabletLayout(BuildContext context, BoxConstraints constraints) {
    return SafeArea(
      key: const Key("sign_up_tablet_layout"),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
          ),
          padding: const EdgeInsets.all(kDefaultSpacing * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HelloText(),
              const _LetsGetStartedText(),
              const SizedBox(height: kDefaultSpacing),
              const _FillInFormText(),
              const SizedBox(height: kDefaultSpacing * 2),
              _AccountCard(),
              const Spacer(flex: 1),
              const Flexible(
                flex: 10,
                child: _SignUpFormPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
