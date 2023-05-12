/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Apr 19 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'video_call_screen.dart';

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.callingSetup,
  });

  final CallingSetup callingSetup;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(flex: 2),
            _buildFlashlightButton(),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildEndCallButton(),
            ),
            const Spacer(flex: 1),
            _buildFlipButton(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return BlocBuilder<CallActionBloc, CallActionState>(
      builder: (context, state) {
        final isLoading = state is CallActionLoading;
        CallActionBloc callActionBloc = context.read<CallActionBloc>();

        return Transform.scale(
          scale: 1.1,
          child: FloatingActionButton(
            key: const Key("video_call_screen_end_call_button"),
            onPressed: isLoading
                ? null
                : () {
                    AppSnackbar(context).showMessage(LocaleKeys.end_call.tr());
                    callActionBloc.add(CallActionEnded(callingSetup.id));
                  },
            heroTag: null,
            backgroundColor: Colors.red,
            child: isLoading
                ? const AdaptiveLoading(
                    key: Key("video_call_screen_end_call_button_loading"),
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.call_end_rounded,
                    key: Key("video_call_screen_end_call_button_icon"),
                    color: Colors.white,
                    size: 26,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFlashlightButton() {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        VideoCallBloc videoCallBloc = context.read<VideoCallBloc>();

        final enableFlashlight = state.setting?.enableFlashlight ?? false;
        final isLoading = state is VideoCallSettingFlashlightLoading;

        return _IconButton(
          buttonKey: const Key("video_call_screen_flashlight_button"),
          iconKey: const Key("video_call_screen_flashlight_button_icon"),
          loadingKey: const Key("video_call_screen_flashlight_button_loading"),
          enabled: enableFlashlight,
          isLoading: isLoading,
          onPressed: () {
            videoCallBloc.add(
              VideoCallSettingFlashlightUpdated(
                callID: callingSetup.id,
                value: !enableFlashlight,
              ),
            );
          },
          icon: Icons.flashlight_on_rounded,
          disableIcon: Icons.flashlight_off_rounded,
        );
      },
    );
  }

  Widget _buildFlipButton() {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        VideoCallBloc videoCallBloc = context.read<VideoCallBloc>();

        final enableFlip = state.setting?.enableFlip ?? false;
        final isLoading = state is VideoCallSettingFlipLoading;

        return _IconButton(
          buttonKey: const Key("video_call_screen_flip_button"),
          iconKey: const Key("video_call_screen_flip_button_icon"),
          loadingKey: const Key("video_call_screen_flip_button_loading"),
          enabled: enableFlip,
          isLoading: isLoading,
          onPressed: () {
            videoCallBloc.add(
              VideoCallSettingFlipUpdated(
                callID: callingSetup.id,
                value: !enableFlip,
              ),
            );
          },
          icon: Icons.flip,
          disableIcon: Icons.flip,
          flip: enableFlip,
        );
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.buttonKey,
    required this.loadingKey,
    required this.iconKey,
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
    required this.icon,
    this.disableIcon,
    this.flip = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData icon;
  final IconData? disableIcon;
  final bool flip;
  final Key buttonKey;
  final Key loadingKey;
  final Key iconKey;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .9,
      child: Opacity(
        opacity: isLoading ? .6 : 1,
        child: FloatingActionButton(
          key: buttonKey,
          onPressed: isLoading ? null : onPressed,
          heroTag: null,
          elevation: 0,
          backgroundColor: enabled
              ? Colors.white.withOpacity(.6)
              : Colors.black.withOpacity(.6),
          child: isLoading
              ? AdaptiveLoading(key: loadingKey, color: Colors.white)
              : FlipWidget(
                  flip: flip,
                  child: Icon(
                    enabled ? icon : (disableIcon ?? icon),
                    key: iconKey,
                    color: enabled ? Colors.black : Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ShadowGradient extends StatelessWidget {
  const _ShadowGradient({this.reverse = true, Key? key}) : super(key: key);

  final bool reverse;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(.2),
            Colors.black.withOpacity(0),
          ],
          begin: (reverse) ? Alignment.bottomCenter : Alignment.topCenter,
          end: (reverse) ? Alignment.topCenter : Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _VideoViewBlindUser extends StatelessWidget {
  const _VideoViewBlindUser({
    required this.rtcEngine,
    super.key,
  });

  final agora.RtcEngine rtcEngine;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        final isLocalJoined = state.isLocalJoined;
        final enableFlip = state.setting?.enableFlip ?? false;

        return isLocalJoined
            ? FlipWidget(
                key: const Key("video_call_screen_video_view_blind_user_flip"),
                flip: enableFlip,
                child: agora.AgoraVideoView(
                  controller: agora.VideoViewController(
                    rtcEngine: rtcEngine,
                    canvas: const agora.VideoCanvas(uid: 0),
                  ),
                ),
              )
            : const AdaptiveLoading(
                color: Colors.white,
                radius: 24,
              );
      },
    );
  }
}

class _VideoViewVolunteerUser extends StatelessWidget {
  const _VideoViewVolunteerUser({
    required this.rtcEngine,
    required this.callingSetup,
    super.key,
  });

  final agora.RtcEngine rtcEngine;
  final CallingSetup callingSetup;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
        builder: (context, state) {
      final remoteUID = state.remoteUID;
      final enableFlip = state.setting?.enableFlip ?? false;

      if (remoteUID != null) {
        return FlipWidget(
          key: const Key("video_call_screen_video_view_volunteer_user_flip"),
          flip: enableFlip,
          child: agora.AgoraVideoView(
            controller: agora.VideoViewController.remote(
              rtcEngine: rtcEngine,
              canvas: agora.VideoCanvas(uid: remoteUID),
              connection:
                  agora.RtcConnection(channelId: callingSetup.rtc.channelName),
            ),
          ),
        );
      } else {
        return const AdaptiveLoading(
          color: Colors.white,
          radius: 24,
        );
      }
    });
  }
}

class _ProfileUser extends StatelessWidget {
  const _ProfileUser({
    required this.callingSetup,
  });

  final CallingSetup callingSetup;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kDefaultSpacing / 2,
          horizontal: kDefaultSpacing,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ProfileImage.network(
                radius: 40,
                url: callingSetup.remoteUser.avatar,
              ),
            ),
            const SizedBox(width: kDefaultSpacing + 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildName(context),
                  _buildUserTypeText(),
                ],
              ),
            ),
            const SizedBox(width: kDefaultSpacing + 10),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      callingSetup.remoteUser.name,
      style:
          Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserTypeText() {
    UserType data = callingSetup.remoteUser.type;

    return Tooltip(
      message: data == UserType.blind
          ? LocaleKeys.blind.tr()
          : LocaleKeys.volunteer.tr(),
      triggerMode: TooltipTriggerMode.tap,
      child: Icon(
        data == UserType.blind ? EvaIcons.eyeOff : EvaIcons.eye,
      ),
    );
  }
}
