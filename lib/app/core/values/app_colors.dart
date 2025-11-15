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

  static const Color buttonColorRedPink = Color(0xFFE11D48);
  static const Color colorSecondary = Color(0xFFFFE2E2);

static const Color bgColorRed = Color(0xFFC31212);
  static const Color subTextColor = Color(0xFFB7B7B7);
  static const Color greenColor = Color(0xFF0ECA36);
  static const Color informationColor = Color(0xFFFFAB00);
  static const Color warningColor = Color(0xFFE92B2B);
  static const Color warningBgColor = Color(0xFFFEEFEC);
  static const Color disableColor = Color(0xFFABABAB);
  static const Color disableBgColor = Color(0xFFE5E5E5);
  static const Color cardBgColor = Color(0xFFFFEBE5);
  static const Color pageBackground = Color(0xFFF2F2F2);

  // ------------- Light Theme Colors ---------------------
  static const Color lightTextPrimaryColor = Color(0xFF241814);
  static const Color lightTextSecondaryColor = Color(0xFF5B5B5B);
  static const Color lightBgColor = Color(0xFFF2F2F2);
  static const Color lightStockColor = Color(0xFFE8E4E2);
  static const Color lightShapeColor = Color(0xFFFFFFFF);
  static const Color lightInputBorderColor = Color(0xFFE8E4E2);
  static const Color lightHintTextColor = Color(0xFF5B5B5B);
  static const Color iconBgColorLight = Color(0xFFFFEBE5);
  static const Color lightBgColorSecondary = Color(0xFFF2F2F2);
  static const Color lightBgColorTertiary = Color(0xFFF2F4F7);
  static const Color lightWarningColorBG = Color(0XFFFEF7E8);
  static const Color ligthBorderGrayColor = Color(0xFFE1E4E9);
  static const Color lightCardBgColor = Color(0xFFF5F5F5);
  static const Color lightAppBarBgColor = Color(0xFFD9D9D9);

  // ----------------- Dark Theme Colors ----------------------

  static const Color darkBgColor = Color(0xFF0D0D0D);
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF);
  static const Color darkTextSecondaryColor = Color(0xFFB7B7B7);
  static const Color darkStockColor = Color(0xFF2B2B2B);
  static const Color darkShapeColor = Color(0xFF1F1F1F);
  static const Color iconBgColorDark = Color(0xFF2B2B2B);
  static const Color darkBgColorSecondary = Color(0xFF1F1F1F);

  static const Color redProgressColor = Color(0xFFFF1B1F);
  static const Color black = Colors.black;
  static const Color black11 = Colors.black26;
  static const Color secondaryBg2Color = Color(0xFFFFEBE5);
  static const Color screenBgColor = Color(0xFF0d0d0d);
  static const Color greyColor1 = Color(0xFF2B2B2B);
  static const Color darkWarningColorBG = Color(0XFFFEF7E8);

  //..............

  static const Color hintTextColor = Color(0xFF8E8E93);
  static const Color menuSubColor = Color(0xFF575757);
  static const Color authBackground = Color(0xFFF4F4FB);

  static Color elevatedContainerColorOpacity = Colors.grey.withAlpha(
    128,
  ); // 0.5 opacity

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

  static const Color positiveBorderColor = Color(0XFF0CAC2E);
  static const Color positiveBgColor = Color(0XFFE8FBEC);
  static const Color darkBgColorPositive = Color(0XFF0D0D0D);

  // Gradient colors
  static const Color gradientRedStart = Color(0xFFD93B3B);
  static const Color gradientRedMiddle = Color(0xFFE47A7B);
  static const Color gradientRedEnd = Color(0xFFF29191);

  static const Color gradientBlueStart = Color(0xFF3E8CC3);
  static const Color gradientBlueMiddle = Color(0xFF82BBDF);
  static const Color gradientBlueEnd = Color(0xFFB9DCF6);

  static const Color gradientGreenStart = Color(0xFF3BAB55);
  static const Color gradientGreenMiddle = Color(0xFF75CC88);
  static const Color gradientGreenEnd = Color(0xFFBEF7CD);

  static const LinearGradient redGradient = LinearGradient(
    colors: [gradientRedStart, gradientRedMiddle, gradientRedEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [gradientBlueStart, gradientBlueMiddle, gradientBlueEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [gradientGreenStart, gradientGreenMiddle, gradientGreenEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );
}
