/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue May 09 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../widgets/widgets.dart';

part 'settings_screen.component.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AccountCubit accountCubit = sl<AccountCubit>();
  AppNavigator appNavigator = sl<AppNavigator>();
  SettingsCubit settingsCubit = sl<SettingsCubit>();
  SignOutCubit signOutCubit = sl<SignOutCubit>();

  @override
  void initState() {
    super.initState();

    accountCubit.getAccountData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => accountCubit),
        BlocProvider(create: (context) => settingsCubit),
        BlocProvider(create: (context) => signOutCubit),
      ],
      child: BlocListener<SignOutCubit, SignOutState>(
        listener: (context, state) {
          if (state is SignOutLoading) {
            AppDialog(context).showLoadingPanel();
          } else if (state is SignOutSuccessfully || state is SignOutError) {
            AppDialog(context).close();
            appNavigator.goToSplash(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const CustomBackButton(),
            title: const Text(LocaleKeys.settings).tr(),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultSpacing,
            ),
            children: const [
              _AccountCard(),
              _HapticsFeedbackSwitch(),
              _VoiceAssistantFeedbackSwitch(),
              SizedBox(height: kDefaultSpacing * 1.5),
              _LanguageButton(),
              SizedBox(height: kDefaultSpacing * 1.5),
              _SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
