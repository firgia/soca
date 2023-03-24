/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final RouteCubit routeCubit = sl<RouteCubit>();
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

    userBloc.add(const UserFetched());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => routeCubit),
        BlocProvider(create: (context) => userBloc),
      ],
      child: MultiBlocListener(
        listeners: [
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
          body: SafeArea(
            child: SwipeRefresh.adaptive(
              stateStream: swipeRefreshController.stream,
              onRefresh: onRefresh,
              platform: CustomPlatformWrapper(),
              children: const [
                SizedBox(height: kDefaultSpacing / 1.5),
                _UserProfile(),
                _UserAction(),
                SizedBox(height: kDefaultSpacing * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    Completer completer = sl<Completer>();
    userBloc.add(UserFetched(completer: completer));

    await completer.future;
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
