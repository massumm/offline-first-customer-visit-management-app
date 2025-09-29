import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color colorPrimary = Color(0xFFEA4B98);
  static const MaterialColor colorPrimarySwatch = MaterialColor(0xFFEA4B98, {
    50: Color.fromRGBO(234, 75, 152, .1),
    100: Color.fromRGBO(234, 75, 152, .2),
    200: Color.fromRGBO(234, 75, 152, .3),
    300: Color.fromRGBO(234, 75, 152, .4),
    400: Color.fromRGBO(234, 75, 152, .5),
    500: Color.fromRGBO(234, 75, 152, .6),
    600: Color.fromRGBO(234, 75, 152, .7),
    700: Color.fromRGBO(234, 75, 152, .8),
    800: Color.fromRGBO(234, 75, 152, .9),
    900: Color.fromRGBO(234, 75, 152, 1),
  });

  static const Color subTextColor = Color(0xFF5C5C5C);
  static const Color hintTextColor = Color(0xFF8E8E93);
  static const Color menuSubColor = Color(0xFF575757);
  static const Color authBackground = Color(0xFFF4F4FB);
  static const Color pageBackground = Colors.white;
  static Color elevatedContainerColorOpacity =
      Colors.grey.withValues(alpha: 0.5);

  // error image bg color
  static const Color errorImageBgColor = Color(0xffF3F5F9);

  // image error color
  static const Color imageErrorColor = Color(0xff8D949D);

  static const Color secondaryBgColor = Color(0xffefeff4);

  // Button disable color
  static const Color buttonDisableColor = Color(0xffBDBDBD);
  static const Color messageTextColor = Color(0xFF111B21);

  static const Color colorDelete = Color(0xFFE53935);
  static const Color echoMessageBgColor = Color(0xFFBBDEFB);
}
