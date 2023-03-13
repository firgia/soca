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
import '../../../config/config.dart';
import '../../../data/data.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppNavigator appNavigator = sl<AppNavigator>();
  final RouteCubit routeCubit = sl<RouteCubit>();
  final UserRepository userRepository = sl<UserRepository>();

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = userRepository.onUserDeviceUpdated.listen(
      (userDevice) => routeCubit.getTargetRoute(
        checkDifferentDevice: true,
        userDevice: userDevice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RouteCubit, RouteState>(
      bloc: routeCubit,
      listener: (context, state) {
        if (state is RouteTarget) {
          if (state.name == AppPages.unknownDevice) {
            appNavigator.goToUnknownDevice(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }
}
