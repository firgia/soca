/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../message/message.dart';
import 'bottom_sheet.dart';
import 'dialog.dart';

class Alert with UIMixin {
  late BuildContext context;
  late AppDialog _dialog;
  late AppBottomSheet _bottomSheet;

  Alert(this.context) {
    _dialog = AppDialog(context);
    _bottomSheet = AppBottomSheet(context);
  }

  Future<void> showSomethingErrorMessage({
    String? title,
    String? body,
    String? errorCode,
    VoidCallback? onActionPressed,
  }) async {
    if (isTablet(context)) {
      return _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: ErrorMessage.somethingError(
              title: title,
              body: body,
              onActionPressed: () {
                _dialog.close();
                if (onActionPressed != null) onActionPressed();
              },
              errorCode: errorCode,
            ),
          );
        },
      );
    } else {
      return _bottomSheet.show(
        height: ErrorMessage.height + MediaQuery.of(context).padding.bottom,
        childBuilder: (context, brightness) {
          return SafeArea(
            child: ErrorMessage.somethingError(
              title: title,
              body: body,
              onActionPressed: () {
                _bottomSheet.close();
                if (onActionPressed != null) onActionPressed();
              },
              errorCode: errorCode,
            ),
          );
        },
      );
    }
  }

  void showInternetErrorMessage({VoidCallback? onActionPressed}) {
    if (isTablet(context)) {
      _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: ErrorMessage.internetError(
              onActionPressed: () {
                _dialog.close();
                if (onActionPressed != null) onActionPressed();
              },
            ),
          );
        },
      );
    } else {
      _bottomSheet.show(
        height: ErrorMessage.height + MediaQuery.of(context).padding.bottom,
        childBuilder: (context, brightness) {
          return SafeArea(
            child: ErrorMessage.internetError(
              onActionPressed: () {
                _bottomSheet.close();
                if (onActionPressed != null) onActionPressed();
              },
            ),
          );
        },
      );
    }
  }

  void showAuthenticationErrorMessage({
    String? title,
    String? body,
    String? errorCode,
    VoidCallback? onActionPressed,
  }) {
    if (isTablet(context)) {
      _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: ErrorMessage.authenticationError(
              title: title,
              body: body,
              onActionPressed: () {
                _dialog.close();
                if (onActionPressed != null) onActionPressed();
              },
              errorCode: errorCode,
            ),
          );
        },
      );
    } else {
      _bottomSheet.show(
        height: ErrorMessage.height + MediaQuery.of(context).padding.bottom,
        childBuilder: (context, brightness) {
          return SafeArea(
            child: ErrorMessage.authenticationError(
              title: title,
              body: body,
              onActionPressed: () {
                _bottomSheet.close();
                if (onActionPressed != null) onActionPressed();
              },
              errorCode: errorCode,
            ),
          );
        },
      );
    }
  }

  Future<void> showPermissionPermanentlyDeniedMessage({
    String? captionText,
    VoidCallback? onActionPressed,
  }) async {
    if (isTablet(context)) {
      await _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: PermissionMessage.permanentlyDenied(
              onActionPressed: () {
                _dialog.close();
                if (onActionPressed != null) onActionPressed();
              },
              captiontext: captionText,
            ),
          );
        },
      );
    } else {
      await _bottomSheet.show(
        height:
            PermissionMessage.height + MediaQuery.of(context).padding.bottom,
        childBuilder: (context, brightness) {
          return SafeArea(
            child: PermissionMessage.permanentlyDenied(
              onActionPressed: () {
                _bottomSheet.close();
                if (onActionPressed != null) onActionPressed();
              },
              captiontext: captionText,
            ),
          );
        },
      );
    }
  }

  Future<void> showPermissionRestrictedMessage({
    String? captionText,
    VoidCallback? onActionPressed,
  }) async {
    if (isTablet(context)) {
      await _dialog.show(
        childBuilder: (context, brightness) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: PermissionMessage.restricted(
              onActionPressed: () {
                _dialog.close();
                if (onActionPressed != null) onActionPressed();
              },
              captiontext: captionText,
            ),
          );
        },
      );
    } else {
      await _bottomSheet.show(
        height:
            PermissionMessage.height + MediaQuery.of(context).padding.bottom,
        childBuilder: (context, brightness) {
          return SafeArea(
            child: PermissionMessage.restricted(
              onActionPressed: () {
                _bottomSheet.close();
                if (onActionPressed != null) onActionPressed();
              },
              captiontext: captionText,
            ),
          );
        },
      );
    }
  }
}
