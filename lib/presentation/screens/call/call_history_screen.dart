/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soca/config/config.dart';
import 'package:soca/data/data.dart';
import 'package:soca/injection.dart';
import 'package:soca/presentation/presentation.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../../../core/core.dart';
import '../../../logic/logic.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  CallHistoryBloc callHistoryBloc = sl<CallHistoryBloc>();
  late final StreamController<SwipeRefreshState> swipeRefreshController;
  DeviceFeedback deviceFeedback = sl<DeviceFeedback>();
  bool hasPlayPageInfo = false;

  @override
  void initState() {
    super.initState();

    swipeRefreshController = StreamController<SwipeRefreshState>.broadcast();
    callHistoryBloc.add(const CallHistoryFetched());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playPageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => callHistoryBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text(LocaleKeys.call_history).tr(),
        ),
        body: BlocConsumer<CallHistoryBloc, CallHistoryState>(
          listener: (context, state) {
            if (state is CallHistoryError &&
                state.failure?.code != CallingFailureCode.notFound) {
              Alert(context).showSomethingErrorMessage();
            }
          },
          builder: (context, state) {
            bool isLoading = state is CallHistoryLoading;
            List<List<CallHistory>> data = [];

            if (state is CallHistoryLoaded) {
              data = state.data;
            }

            return SwipeRefresh.builder(
              stateStream: swipeRefreshController.stream,
              onRefresh: onRefresh,
              platform: CustomPlatformWrapper(),
              itemCount: isLoading ? 2 : data.length,
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const CallHistoryCard.loading();
                } else {
                  return CallHistoryCard(data: data[index]);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    Completer completer = sl<Completer>();

    callHistoryBloc.add(CallHistoryFetched(completer: completer));
    await completer.future;

    if (!swipeRefreshController.isClosed) {
      swipeRefreshController.sink.add(SwipeRefreshState.hidden);
    }
  }

  @override
  void dispose() {
    super.dispose();

    swipeRefreshController.close();
  }

  void playPageInfo() {
    if (mounted && !hasPlayPageInfo) {
      hasPlayPageInfo = true;

      deviceFeedback.playVoiceAssistant(
        [
          LocaleKeys.va_call_history_page.tr(),
        ],
        context,
        immediately: true,
      );
    }
  }
}
