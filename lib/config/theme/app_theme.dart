/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_font.dart';

const kDefaultSpacing = 16.0;
const kBorderRadius = 16.0;

/// all custom application theme
abstract class AppTheme with WidgetsBindingObserver {
  static bool get isDarkMode {
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    return platformDispatcher.platformBrightness == Brightness.dark;
  }

  static ThemeData get dark => ThemeData(
        appBarTheme: _getAppbarTheme(Brightness.dark),
        brightness: Brightness.dark,
        canvasColor: _getCanvasColor(Brightness.dark),
        cardColor: _getCardColor(Brightness.dark),
        cardTheme: _getCardTheme(Brightness.dark),
        dividerColor: _getDividerColor(Brightness.dark),
        elevatedButtonTheme: _getElevatedButtonThemeData(),
        fontFamily: AppFont.poppins,
        iconTheme: _getIconTheme(Brightness.dark),
        inputDecorationTheme: _getInputDecorationTheme(Brightness.dark),
        primarySwatch: Colors.blue,
        primaryColorDark: AppColors.darkBlue,
        primaryColor: AppColors.blue,
        primaryColorLight: AppColors.lightBlue,
        textTheme: _getTextTheme(Brightness.dark),
      );

  static ThemeData get light => ThemeData(
        appBarTheme: _getAppbarTheme(Brightness.light),
        brightness: Brightness.light,
        canvasColor: _getCanvasColor(Brightness.light),
        cardColor: _getCardColor(Brightness.light),
        cardTheme: _getCardTheme(Brightness.light),
        dividerColor: _getDividerColor(Brightness.light),
        elevatedButtonTheme: _getElevatedButtonThemeData(),
        fontFamily: AppFont.poppins,
        iconTheme: _getIconTheme(Brightness.light),
        inputDecorationTheme: _getInputDecorationTheme(Brightness.light),
        primarySwatch: Colors.blue,
        primaryColorDark: AppColors.darkBlue,
        primaryColor: AppColors.blue,
        primaryColorLight: AppColors.lightBlue,
        textTheme: _getTextTheme(Brightness.light),
      );
}

ElevatedButtonThemeData _getElevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom().merge(
      ButtonStyle(elevation: MaterialStateProperty.all(0)),
    ),
  );
}

AppBarTheme _getAppbarTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return AppBarTheme(
    backgroundColor: isDark
        ? const Color.fromRGBO(0, 0, 0, 1)
        : const Color.fromRGBO(242, 242, 246, 1),
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    actionsIconTheme: IconThemeData(
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    titleTextStyle: TextStyle(
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}

Color? _getCanvasColor(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return isDark ? AppColors.canvasDark : AppColors.canvasLight;
}

Color? _getCardColor(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return isDark ? AppColors.cardDark : AppColors.cardLight;
}

CardTheme? _getCardTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadius),
    ),
    margin: const EdgeInsets.all(kDefaultSpacing),
    elevation: 0,
    shadowColor: isDark ? Colors.white12 : Colors.black12,
  );
}

Color _getDividerColor(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return isDark
      ? const Color.fromRGBO(67, 67, 69, 1)
      : const Color.fromRGBO(200, 200, 202, 1);
}

IconThemeData? _getIconTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return isDark
      ? const IconThemeData(color: Color.fromRGBO(90, 90, 94, 1))
      : const IconThemeData(color: Color.fromRGBO(196, 196, 198, 1));
}

TextTheme _getTextTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 28,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 26,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 24,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: .5,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
      letterSpacing: .5,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w700,
      letterSpacing: .5,
      fontSize: 18,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      color:
          isDark ? AppColors.fontPalletsDark[1] : AppColors.fontPalletsLight[1],
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color:
          isDark ? AppColors.fontPalletsDark[2] : AppColors.fontPalletsLight[2],
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.4,
      color:
          isDark ? AppColors.fontPalletsDark[0] : AppColors.fontPalletsLight[0],
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      fontSize: 12,
      color:
          isDark ? AppColors.fontPalletsDark[1] : AppColors.fontPalletsLight[1],
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 10,
      letterSpacing: 0.5,
      color:
          isDark ? AppColors.fontPalletsDark[2] : AppColors.fontPalletsLight[2],
    ),
  );
}

InputDecorationTheme? _getInputDecorationTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final borderColor = _getDividerColor(brightness);

  return InputDecorationTheme(
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: .8,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: .8,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 1.4,
      ),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderColor.withOpacity(.8),
        width: .8,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? AppColors.lightRed : AppColors.darkRed,
        width: .8,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? AppColors.lightRed : AppColors.darkRed,
        width: 1.4,
      ),
    ),
    errorStyle: _getTextTheme(brightness).bodySmall?.copyWith(
          color: isDark ? AppColors.lightRed : AppColors.darkRed,
        ),
    errorMaxLines: 1,
    hintStyle: _getTextTheme(brightness).bodyMedium,
    isDense: true,
  );
}
