/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'unknown_device_screen.dart';

class _DifferentDeviceInfoText extends StatelessWidget {
  const _DifferentDeviceInfoText();

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        LocaleKeys.sign_in_different_device_info,
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

class _DifferentDeviceText extends StatelessWidget {
  const _DifferentDeviceText();

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        LocaleKeys.sign_in_different_device,
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

class _IllustrationImage extends StatelessWidget {
  const _IllustrationImage();

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      ImageAnimation.cyberSecurity,
      key: const Key("unknown_device_screen_illustration_image"),
      height: 250,
      width: 250,
    );
  }
}

class _GotItButton extends StatelessWidget {
  _GotItButton();

  final AppNavigator _appNavigator = sl<AppNavigator>();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key("unknown_device_screen_got_it_button"),
      onPressed: () => _appNavigator.goToSignIn(context),
      style: FlatButtonStyle(
        expanded: true,
        size: ButtonSize.large,
      ),
      child: const Text(LocaleKeys.got_it).tr(),
    );
  }
}
