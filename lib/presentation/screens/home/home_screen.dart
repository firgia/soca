/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soca/core/core.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import '../../../config/config.dart';
import '../../../data/data.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../widgets/widgets.dart';

part 'home_screen.component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppNavigator appNavigator = sl<AppNavigator>();
  final AssistantCommandBloc assistantCommandBloc = sl<AssistantCommandBloc>();
  final CallStatisticBloc callStatisticBloc = sl<CallStatisticBloc>();
  final IncomingCallBloc incomingCallBloc = sl<IncomingCallBloc>();
  final RouteCubit routeCubit = sl<RouteCubit>();
  final SignOutCubit signOutCubit = sl<SignOutCubit>();
  final UserBloc userBloc = sl<UserBloc>();
  final UserRepository userRepository = sl<UserRepository>();
  late final StreamController<SwipeRefreshState> swipeRefreshController;
  late final StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    swipeRefreshController = StreamController<SwipeRefreshState>.broadcast();
    subscription = userRepository.onUserDeviceUpdated.listen(
      (userDevice) => routeCubit.getTargetRoute(
        checkDifferentDevice: true,
        userDevice: userDevice,
      ),
    );

    assistantCommandBloc.add(const AssistantCommandFetched());
    userBloc.add(const UserFetched());
    incomingCallBloc.add(const IncomingCallFetched());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callStatisticBloc.add(CallStatisticFetched(context.locale.languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => callStatisticBloc),
        BlocProvider(create: (context) => routeCubit),
        BlocProvider(create: (context) => signOutCubit),
        BlocProvider(create: (context) => userBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AssistantCommandBloc, AssistantCommandState?>(
            bloc: assistantCommandBloc,
            listener: (context, state) {
              if (state is AssistantCommandCallVolunteerLoaded) {
                appNavigator.goToCreateCall(context, user: state.data);
                assistantCommandBloc.add(const AssistantCommandEventRemoved());
              }
            },
          ),
          BlocListener<SignOutCubit, SignOutState>(
            listener: (context, state) {
              if (state is SignOutSuccessfully || state is SignOutError) {
                appNavigator.goToSplash(context);
              }
            },
          ),
          BlocListener<IncomingCallBloc, IncomingCallState>(
            bloc: incomingCallBloc,
            listener: (context, state) {
              if (state is IncomingCallLoaded) {
                appNavigator.goToAnswerCall(
                  context,
                  callID: state.id,
                  blindID: state.blindID,
                  name: state.name,
                  urlImage: state.urlImage,
                );
                incomingCallBloc.add(const IncomingCallEventRemoved());
              }
            },
          ),
          BlocListener<RouteCubit, RouteState>(
            listener: (context, state) {
              if (state is RouteTarget) {
                if (state.name == AppPages.unknownDevice) {
                  appNavigator.goToUnknownDevice(context);
                }
              }
            },
          ),
        ],
        child: Scaffold(
          body: _LoadingWrapper(
            child: SafeArea(
              bottom: false,
              child: SwipeRefresh.adaptive(
                stateStream: swipeRefreshController.stream,
                onRefresh: onRefresh,
                platform: CustomPlatformWrapper(),
                children: const [
                  SizedBox(height: kDefaultSpacing / 1.5),
                  _UserProfile(),
                  _UserAction(),
                  _PermissionCard(),
                  SizedBox(height: kDefaultSpacing * 1.5),
                  _CallStatistic(),
                  SizedBox(height: kDefaultSpacing * 1.5),
                  _CallHistoryButton(),
                  SizedBox(height: kDefaultSpacing * 1.5),
                  _SignOutButton(),
                  SizedBox(height: kDefaultSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    Completer completer = sl<Completer>();
    Completer completerCall = sl<Completer>();

    userBloc.add(UserFetched(completer: completer));
    callStatisticBloc.add(
      CallStatisticFetched(
        context.locale.languageCode,
        completer: completerCall,
      ),
    );

    await Future.wait([
      completer.future,
      completerCall.future,
    ]);

    if (!swipeRefreshController.isClosed) {
      swipeRefreshController.sink.add(SwipeRefreshState.hidden);
    }
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
    swipeRefreshController.close();
  }
}
