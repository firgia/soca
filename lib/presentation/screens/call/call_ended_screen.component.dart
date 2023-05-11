/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'call_ended_screen.dart';

class _CallEndedInfoText extends StatelessWidget {
  const _CallEndedInfoText(this.userType);
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        userType == UserType.blind
            ? LocaleKeys.call_ended_blind_info
            : LocaleKeys.call_ended_volunteer_info,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.fontPallets[1],
              fontWeight: FontWeight.w400,
            ),
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ).tr();
    });
  }
}

class _CallEndedText extends StatelessWidget {
  const _CallEndedText();

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        LocaleKeys.call_ended,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.fontPallets[0],
            ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ).tr();
    });
  }
}

class _CallEndedCountdown extends StatefulWidget {
  const _CallEndedCountdown({
    required this.duration,
    required this.onEnded,
  });

  final Duration duration;
  final VoidCallback onEnded;

  @override
  State<_CallEndedCountdown> createState() => _CallEndedCountdownState();
}

class _CallEndedCountdownState extends State<_CallEndedCountdown> {
  late Duration duration;
  late ValueNotifier<double> value = ValueNotifier(0);

  Timer? timer;

  @override
  void initState() {
    super.initState();

    duration = widget.duration;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      this.timer = timer;

      if (value.value < duration.inSeconds.toDouble()) {
        value.value++;
      } else {
        timer.cancel();
        widget.onEnded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, brightness) {
      bool isDarkMode = brightness == Brightness.dark;

      return SimpleCircularProgressBar(
        progressStrokeWidth: 20,
        backStrokeWidth: 8,
        size: 300,
        valueNotifier: value,
        mergeMode: true,
        maxValue: duration.inSeconds.toDouble(),
        animationDuration: duration.inSeconds,
        backColor: isDarkMode ? const Color(0xFF16262D) : Colors.grey[200]!,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }
}

class _IllustrationImage extends StatelessWidget {
  const _IllustrationImage();

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      ImageAnimation.star,
      key: const Key("call_ended_screen_illustration_image"),
      height: 300,
      width: 300,
    );
  }
}

class _OkButton extends StatelessWidget {
  const _OkButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key("call_ended_screen_ok_button"),
      onPressed: () {
        sl<AppNavigator>().goToHome(context);
      },
      style: FlatButtonStyle(
        expanded: true,
        size: ButtonSize.large,
      ),
      child: const Text(LocaleKeys.ok).tr(),
    );
  }
}
