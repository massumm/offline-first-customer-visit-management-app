import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color colorPrimary = Color(0XFFE9522B);
  static const MaterialColor colorPrimarySwatch = MaterialColor(0XFFE9522B, {
    50: Color.fromRGBO(233, 82, 43, .1),
    100: Color.fromRGBO(233, 82, 43, .2),
    200: Color.fromRGBO(233, 82, 43, .3),
    300: Color.fromRGBO(233, 82, 43, .4),
    400: Color.fromRGBO(233, 82, 43, .5),
    500: Color.fromRGBO(233, 82, 43, .6),
    600: Color.fromRGBO(233, 82, 43, .7),
    700: Color.fromRGBO(233, 82, 43, .8),
    800: Color.fromRGBO(233, 82, 43, .9),
    900: Color.fromRGBO(233, 82, 43, 1),
  });

  static const Color subTextColor = Color(0xFFB7B7B7);
  static const Color cardBgColor = Color(0xFF1F1F1F);
  static const Color greenColor = Color(0xFF0ECA36);
  static const Color orangeColor = Color(0xFFFFAB00);
  static const Color redColor = Color(0xFFFF5630);

  // ------------- Light Theme Colors ---------------------
  static const Color lightTextPrimaryColor = Color(0xFF241814);
  static const Color lightTextSecondaryColor = Color(0xFF5B5B5B);
  static const Color lightBgColor = Color(0xFFF2F2F2);
  static const Color lightStockColor = Color(0xFFE8E4E2);
  static const Color lightInputBorder = Color(0xFFE8E4E2);
  static const Color lightHintTextColor= Color(0xFF5B5B5B);



  static const Color redProgressColor = Color(0xFFFF1B1F);
  static const Color black = Colors.black;
  static const Color black11 = Colors.black26;
  static const Color secondaryBg2Color = Color(0xFFFFEBE5);
  static const Color screenBgColor = Color(0xFF0d0d0d);
  static const Color greyColor1 = Color(0xFF2B2B2B);

  //..............

  static const Color hintTextColor = Color(0xFF8E8E93);
  static const Color menuSubColor = Color(0xFF575757);
  static const Color authBackground = Color(0xFFF4F4FB);
  static const Color pageBackground = Colors.white;
  static Color elevatedContainerColorOpacity =
  Colors.grey.withAlpha(128); // 0.5 opacity

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
