/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../widgets/widgets.dart';

part 'create_call_screen.component.dart';

class CreateCallScreen extends StatefulWidget {
  const CreateCallScreen({
    required this.user,
    super.key,
  });

  final User user;

  @override
  State<CreateCallScreen> createState() => _CreateCallScreenState();
}

class _CreateCallScreenState extends State<CreateCallScreen> {
  AppNavigator appNavigator = sl<AppNavigator>();
  CallActionBloc callActionBloc = sl<CallActionBloc>();
  CallKit callKit = sl<CallKit>();

  @override
  void initState() {
    super.initState();

    callActionBloc.add(const CallActionCreated());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => callActionBloc,
      child: BlocListener<CallActionBloc, CallActionState>(
        listener: (context, state) {
          if (state is CallActionCreatedSuccessfully) {
            CallingSetup data = state.data;
            callKit.startCall(
              CallKitArgument(
                id: data.id,
                nameCaller: data.remoteUser.name,
                handle: LocaleKeys.volunteer.tr(),
                type: 1,
              ),
            );
            appNavigator.goToVideoCall(context, setup: state.data);
          } else if (state is CallActionEndedSuccessfully) {
            appNavigator.back(context);
          } else if (state is CallActionCreatedUnanswered) {
            appNavigator.back(context);
            AppSnackbar(context)
                .showMessage(LocaleKeys.fail_to_call_no_volunteers.tr());
          } else if (state is CallActionError) {
            appNavigator.back(context);
            AppSnackbar(context).showMessage(
              LocaleKeys.error_something_wrong.tr(),
              style: SnacbarStyle.danger,
            );
          }
        },
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                _BackgroundImage(widget.user.avatar?.large),
                Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      _NameText(widget.user.name ?? ""),
                      const _CallingVolunteerText(),
                      const Spacer(flex: 3),
                      const _CancelButton(),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
