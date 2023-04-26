/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'home_screen.dart';

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return ProfileCard(
            key: const Key("home_screen_profile_card"),
            user: state.data,
          );
        } else {
          return const ProfileCard.loading(
            key: Key("home_screen_profile_card_loading"),
          );
        }
      },
    );
  }
}

class _UserAction extends StatelessWidget {
  const _UserAction();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          UserType? type = state.data.type;
          if (type == UserType.volunteer) {
            return const VolunteerInfoCard();
          } else if (type == UserType.blind) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultSpacing),
              child: CallVolunteerButton(
                onPressed: () async {
                  sl<AppNavigator>().goToCreateCall(context, user: state.data);
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _LoadingWrapper extends StatelessWidget {
  const _LoadingWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<RouteCubit, RouteState>(
          builder: (context, state) {
            bool isLoading = state is RouteLoading;

            if (isLoading) {
              return const LoadingPanel();
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class _PermissionCard extends StatefulWidget {
  const _PermissionCard();

  @override
  State<_PermissionCard> createState() => _PermissionCardState();
}

class _PermissionCardState extends State<_PermissionCard>
    with WidgetsBindingObserver {
  DeviceInfo deviceInfo = sl<DeviceInfo>();
  DeviceSettings deviceSettings = sl<DeviceSettings>();

  bool cameraAllowed = false;
  bool microphoneAllowed = false;
  bool notificationAllowed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    requestAllPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      checkAllPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAllPermissionAllowed()) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kDefaultSpacing * 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
            child: Text(
              LocaleKeys.please_allow_permission,
              style: Theme.of(context).textTheme.titleLarge,
            ).tr(),
          ),
          const SizedBox(height: kDefaultSpacing),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultSpacing / 2),
              children: [
                if (!cameraAllowed)
                  PermissionCard(
                    icon: EvaIcons.camera,
                    title: LocaleKeys.camera.tr(),
                    subtitle: LocaleKeys.required_when_making_calls.tr(),
                    onPressedAllow: () => showCameraPermission(),
                    iconColor: Colors.grey,
                  ),
                if (!microphoneAllowed)
                  PermissionCard(
                    icon: EvaIcons.mic,
                    title: LocaleKeys.microphone.tr(),
                    subtitle: LocaleKeys.required_when_making_calls.tr(),
                    onPressedAllow: () => showMicrophonePermission(),
                    iconColor: Colors.blueGrey,
                  ),
                if (!notificationAllowed)
                  PermissionCard(
                    icon: EvaIcons.bell,
                    title: LocaleKeys.notification.tr(),
                    subtitle: LocaleKeys.required_when_making_calls.tr(),
                    onPressedAllow: () => showNotificationPermission(),
                    iconColor: Colors.amber[300],
                  ),
              ],
            ),
          )
        ],
      );
    }
  }

  bool isAllPermissionAllowed() =>
      (cameraAllowed && microphoneAllowed && notificationAllowed);

  void showCameraPermission() async {
    Alert alert = Alert(context);

    final cameraStatus =
        await deviceInfo.getPermissionStatus(Permission.camera);

    if (cameraStatus == PermissionStatus.denied) {
      final result = await deviceInfo.requestPermission(Permission.camera);

      setState(() {
        cameraAllowed = (result == PermissionStatus.granted);
      });
      if (result != PermissionStatus.granted) {
        deviceSettings.openAppSettings();
      }
    } else if (cameraStatus == PermissionStatus.permanentlyDenied) {
      await alert.showPermissionPermanentlyDeniedMessage(
        captionText: LocaleKeys.camera.tr(),
        onActionPressed: () => deviceSettings.openAppSettings(),
      );

      await checkCamera();
    } else if (cameraStatus == PermissionStatus.restricted) {
      await alert.showPermissionRestrictedMessage(
        captionText: LocaleKeys.camera.tr(),
      );
    }
  }

  void showMicrophonePermission() async {
    Alert alert = Alert(context);

    final microphoneStatus =
        await deviceInfo.getPermissionStatus(Permission.microphone);

    if (microphoneStatus == PermissionStatus.denied) {
      final result = await deviceInfo.requestPermission(Permission.microphone);

      setState(() {
        microphoneAllowed = (result == PermissionStatus.granted);
      });
      if (result != PermissionStatus.granted) {
        deviceSettings.openAppSettings();
      }
    } else if (microphoneStatus == PermissionStatus.permanentlyDenied) {
      await alert.showPermissionPermanentlyDeniedMessage(
        captionText: LocaleKeys.microphone.tr(),
        onActionPressed: () => deviceSettings.openAppSettings(),
      );

      await checkMicrophone();
    } else if (microphoneStatus == PermissionStatus.restricted) {
      await alert.showPermissionRestrictedMessage(
        captionText: LocaleKeys.microphone.tr(),
      );
    }
  }

  void showNotificationPermission() async {
    Alert alert = Alert(context);

    final notificationStatus =
        await deviceInfo.getPermissionStatus(Permission.notification);

    if (notificationStatus == PermissionStatus.denied) {
      final result = await Permission.notification.request();

      setState(() {
        notificationAllowed = (result == PermissionStatus.granted);
      });
      if (result != PermissionStatus.granted) {
        deviceSettings.openNotificationSettings();
      }
    } else if (notificationStatus == PermissionStatus.permanentlyDenied) {
      await alert.showPermissionPermanentlyDeniedMessage(
        captionText: LocaleKeys.notification.tr(),
        onActionPressed: () => deviceSettings.openNotificationSettings(),
      );

      await checkNotification();
    } else if (notificationStatus == PermissionStatus.restricted) {
      await alert.showPermissionRestrictedMessage(
        captionText: LocaleKeys.notification.tr(),
      );
    }
  }

  Future<void> requestAllPermission() async {
    await deviceInfo.requestPermissions([
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ]);

    await checkAllPermission();
  }

  Future<void> checkAllPermission() async {
    await Future.wait([
      checkCamera(),
      checkMicrophone(),
      checkNotification(),
    ]);
  }

  Future<void> checkCamera() async {
    final cameraStatus =
        await deviceInfo.getPermissionStatus(Permission.camera);

    setState(() {
      cameraAllowed = cameraStatus == PermissionStatus.granted;
    });
  }

  Future<void> checkMicrophone() async {
    final microphoneStatus =
        await deviceInfo.getPermissionStatus(Permission.microphone);

    setState(() {
      microphoneAllowed = microphoneStatus == PermissionStatus.granted;
    });
  }

  Future<void> checkNotification() async {
    final notificationStatus =
        await deviceInfo.getPermissionStatus(Permission.notification);

    setState(() {
      notificationAllowed = notificationStatus == PermissionStatus.granted;
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }
}
