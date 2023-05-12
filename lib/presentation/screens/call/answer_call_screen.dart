/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Apr 23 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../widgets/widgets.dart';

part 'answer_call_screen.component.dart';

class AnswerCallScreen extends StatefulWidget {
  const AnswerCallScreen({
    required this.callID,
    required this.blindID,
    required this.name,
    required this.urlImage,
    super.key,
  });

  final String callID;
  final String blindID;
  final String? name;
  final String? urlImage;

  @override
  State<AnswerCallScreen> createState() => _AnswerCallScreenState();
}

class _AnswerCallScreenState extends State<AnswerCallScreen> {
  AppNavigator appNavigator = sl<AppNavigator>();
  CallActionBloc callActionBloc = sl<CallActionBloc>();
  CallKit callKit = sl<CallKit>();
  DeviceFeedback deviceFeedback = sl<DeviceFeedback>();
  bool hasPlayPageInfo = false;
  bool hasPlayStartVideoCall = false;

  @override
  void initState() {
    super.initState();

    callActionBloc.add(CallActionAnswered(
      callID: widget.callID,
      blindID: widget.blindID,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playPageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => callActionBloc,
      child: BlocListener<CallActionBloc, CallActionState>(
        listener: (context, state) {
          if (state is CallActionAnsweredSuccessfully) {
            playStartVideoCall().then(
              (_) {
                if (mounted) {
                  appNavigator.goToVideoCall(context, setup: state.data);
                }
              },
            );
          } else if (state is CallActionEndedSuccessfully) {
            callKit.endAllCalls();
            appNavigator.back(context);
            AppSnackbar(context)
                .showMessage(LocaleKeys.end_call_successfully.tr());
          } else if (state is CallActionError) {
            callKit.endAllCalls();
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
                _BackgroundImage(widget.urlImage),
                Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      _NameText(widget.name ?? ""),
                      const _AnsweringCallText(),
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

  void playPageInfo() {
    if (mounted && !hasPlayPageInfo) {
      hasPlayPageInfo = true;

      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.va_async_answering_call.tr(),
        ],
        context,
        immediately: true,
      );
    }
  }

  Future<void> playStartVideoCall() async {
    if (mounted && !hasPlayStartVideoCall) {
      hasPlayStartVideoCall = true;
      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.va_starting_video_call.tr(),
        ],
        context,
        immediately: true,
      );

      // Add delay to make sure user hear the 'starting video call' voice

      if (deviceFeedback.isVoiceAssistantEnable) {
        // Add delay to make sure user hear the 'starting video call' voice
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
