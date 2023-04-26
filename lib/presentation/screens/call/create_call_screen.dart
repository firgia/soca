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
  late AppNavigator appNavigator;
  late CallActionBloc callActionBloc;

  @override
  void initState() {
    super.initState();

    appNavigator = sl<AppNavigator>();
    callActionBloc = sl<CallActionBloc>();
    callActionBloc.add(const CallActionCreated());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => callActionBloc,
      child: BlocListener<CallActionBloc, CallActionState>(
        listener: (context, state) {
          if (state is CallActionCreatedSuccessfully) {
            appNavigator.goToVideoCall(context, setup: state.data);
          } else if (state is CallActionEndedSuccessfully) {
            appNavigator.back(context);
          } else if (state is CallActionCreatedUnanswered) {
            appNavigator.back(context);
            AppSnackbar(context)
                .showMessage(LocaleKeys.fail_to_call_no_volunteers.tr());
          } else if (state is CallActionError) {
            Alert(context).showSomethingErrorMessage(
              errorCode: state.failure?.code.name,
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
