/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Default of Application Color
abstract class AppColors {
  // Blue
  static Color get darkBlue => const Color.fromRGBO(59, 105, 229, 1);
  static Color get blue => const Color.fromRGBO(58, 130, 247, 1);
  static Color get lightBlue => const Color.fromRGBO(63, 158, 255, 1);

  // Green
  static Color get darkGreen => const Color.fromRGBO(0, 144, 0, 1);
  static Color get green => const Color.fromRGBO(0, 206, 83, 1);
  static Color get lightGreen => const Color.fromRGBO(36, 255, 105, 1);

  // Red
  static Color get darkRed => Colors.red[600]!;
  static Color get red => Colors.red;
  static Color get lightRed => Colors.red[400]!;

  static Color get barrier => Colors.grey[800]!.withOpacity(.7);

  /// Dynamic Color
  static Color get canvas {
    return AppTheme.isDarkMode ? canvasDark : canvasLight;
  }

  static Color get canvasLight => const Color.fromRGBO(242, 242, 246, 1);
  static Color get canvasDark => const Color.fromRGBO(0, 0, 0, 1);

  /// Dynamic Color
  static Color get card {
    return AppTheme.isDarkMode ? cardDark : cardLight;
  }

  static Color get cardLight => const Color.fromRGBO(255, 255, 255, 1);
  static Color get cardDark => const Color.fromRGBO(28, 28, 29, 1);

  /// Dynamic Color
  static Color get cardIconBackground {
    return AppTheme.isDarkMode
        ? cardIconBackgroundDark
        : cardIconBackgroundLight;
  }

  static Color get cardIconBackgroundLight =>
      const Color.fromRGBO(244, 244, 245, 1);
  static Color get cardIconBackgroundDark =>
      const Color.fromRGBO(44, 44, 47, 1);

  /// Dynamic Color
  static List<Color> get fontPallets {
    return AppTheme.isDarkMode ? fontPalletsDark : fontPalletsLight;
  }

  static List<Color> get fontPalletsLight {
    return const [
      Color.fromRGBO(0, 0, 0, 1),
      Color.fromRGBO(60, 60, 60, 1),
      Color.fromRGBO(140, 140, 140, 1),
    ];
  }

  static List<Color> get fontPalletsDark {
    return const [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(200, 200, 200, 1),
      Color.fromRGBO(150, 150, 150, 1),
    ];
  }

  /// Dynamic Color
  static Color get disableButtonBackground {
    return AppTheme.isDarkMode
        ? disableButtonBackgroundDark
        : disableButtonBackgroundLight;
  }

  static Color get disableButtonBackgroundLight =>
      const Color.fromRGBO(255, 255, 255, 1);
  static Color get disableButtonBackgroundDark =>
      const Color.fromRGBO(28, 28, 29, 1);

  /// Dynamic Color
  static Color get disableButtonForeground {
    return AppTheme.isDarkMode
        ? disableButtonForegroundDark
        : disableButtonForegroundLight;
  }

  static Color get disableButtonForegroundLight => fontPalletsLight[1];
  static Color get disableButtonForegroundDark => fontPalletsDark[1];
  static Color get genderFemaleColor => Colors.pink[300]!;
  static Color get genderMaleColor => Colors.lightBlue[300]!;
}
