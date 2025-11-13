import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconCupertinoTheme {
  static const CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemOrange,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.darkBackgroundGray,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Display',
      ),
    ),
  );

  static const CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemOrange,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
    barBackgroundColor: CupertinoColors.white,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.black,
      textStyle: TextStyle(
        color: CupertinoColors.black,
        fontFamily: '.SF Pro Text',
      ),
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Display',
      ),
    ),
    applyThemeToAll: true,
  );

  /// ————————————————————————————————————————————————————————————————
  /// Adaptive + mapping helpers (recommended)
  /// ————————————————————————————————————————————————————————————————

  /// Build a Cupertino theme that mirrors a Material ColorScheme.
  static CupertinoThemeData fromColorScheme(
    ColorScheme scheme, {
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    return CupertinoThemeData(
      brightness: brightness,
      // Keep your brand color in sync with Material primary
      primaryColor: scheme.primary,
      // Respect grouped backgrounds commonly used by Cupertino lists
      scaffoldBackgroundColor: isDark
          ? CupertinoColors.black
          : CupertinoColors.systemGroupedBackground,
      // Make bars match Material surface/primary contrasts
      barBackgroundColor: isDark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.systemBackground,
      textTheme: CupertinoTextThemeData(
        // Primary label color (used widely across Cupertino widgets)
        primaryColor: isDark ? CupertinoColors.white : CupertinoColors.black,
        // Base text style; iOS will pick SF Pro automatically on device
        textStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
        ),
        // Optional: fine-tune other text slots if you wish
        // actionTextStyle: const TextStyle(fontWeight: FontWeight.w600),
        // tabLabelTextStyle: const TextStyle(fontSize: 12),
      ),
      // Ensures even Material-wrapped Cupertino widgets use this theme
      applyThemeToAll: true,
    );
  }

  /// Mirror a full Material ThemeData (color scheme + brightness).
  // IconCupertinoTheme.dart

  static CupertinoThemeData fromMaterial(ThemeData material) {
    final isDark = material.brightness == Brightness.dark;
    return CupertinoThemeData(
      brightness: material.brightness,
      primaryColor: material.colorScheme.primary,
      barBackgroundColor: isDark
          ? CupertinoColors.darkBackgroundGray
          : CupertinoColors.systemBackground,
      scaffoldBackgroundColor: isDark
          ? CupertinoColors.black
          : material.colorScheme.surface,
      textTheme: CupertinoTextThemeData(
        primaryColor: isDark ? CupertinoColors.white : CupertinoColors.black,
        textStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: isDark ? CupertinoColors.white : CupertinoColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
        ),
      ),
      applyThemeToAll: true,
    );
  }

  /// Quick adaptive picker: returns light or dark theme above
  /// if you prefer a fixed palette without mapping.
  static CupertinoThemeData adaptive(Brightness brightness) =>
      brightness == Brightness.dark ? darkTheme : lightTheme;
}
