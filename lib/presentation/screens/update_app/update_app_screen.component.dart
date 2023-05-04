/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed May 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'update_app_screen.dart';

class _NewUpdateInfoText extends StatelessWidget {
  const _NewUpdateInfoText();

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        LocaleKeys.update_app_required_desc,
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

class _UpdateRequiredText extends StatelessWidget {
  const _UpdateRequiredText();

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, _) {
      return Text(
        LocaleKeys.update_app_required,
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
      ImageAnimation.mobileAppRepair,
      key: const Key("update_app_screen_illustration_image"),
      height: 250,
      width: 250,
    );
  }
}

class _UpdateNotButton extends StatelessWidget {
  const _UpdateNotButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key("update_app_screen_update_now_button"),
      onPressed: () {},
      style: FlatButtonStyle(
        expanded: true,
        size: ButtonSize.large,
      ),
      child: const Text(LocaleKeys.update_now).tr(),
    );
  }
}
