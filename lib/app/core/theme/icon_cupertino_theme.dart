import 'package:flutter/cupertino.dart';

class IconCupertinoTheme {
  // Dark Theme for iOS
  static const CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemOrange,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.darkBackgroundGray,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamily: '.SF Pro Text', // Ensure consistent font
      ),
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontWeight: FontWeight.w600,
        fontFamily: '.SF Pro Display',
      ),
    ),
  );

  // Light Theme for iOS
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
  );
}