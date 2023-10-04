// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppColor {
  static ThemeData customDarkThem = ThemeData.dark().copyWith(
    colorScheme: ColorScheme(
      primary: Color(0xffE0E0E0),
      background: Color(0xFFEEEEEE),
      secondary: Colors.green,
      surface: Color(0XFFF8D320),
      onSurface: Colors.transparent,
      brightness: Brightness.light,
      onError: Colors.red,
      tertiary: Colors.blue,
      primaryVariant: Color(0xFFFF6F43),
      secondaryVariant: Color(0xFFFE1B03),
      onBackground: Colors.grey,
      onPrimary: Color(0xFFDDDDDD),
      inversePrimary: Colors.pink,
      // inverseSurface: Colors.green.shade400,
      onSecondary: Colors.black,
      error: Color(0x00000000),
    ),
    backgroundColor: const Color(0xff5DB1DF),
    primaryColor: const Color(0xff5DB1DF),
    dialogBackgroundColor: Color.fromARGB(255, 18, 43, 117),
    scaffoldBackgroundColor: const Color(0xFF17203A),
    cardTheme: CardTheme(color: Color(0xFF17203A)),
    cardColor: const Color(0xFF2D4DAB),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF273358),
      selectedItemColor: Color(0xff5DB1DF),
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle:
          TextStyle(fontFamily: "Poppins", color: Colors.black, fontSize: 7.sp),
      unselectedItemColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff5DB1DF),
    ),
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.white,
    textTheme: TextTheme(
        bodyMedium: TextStyle(fontFamily: "Poppins"),
        bodyLarge: TextStyle(
            fontSize: 18.sp,
            fontFamily: "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.bold),
        displayLarge: TextStyle(
            fontSize: 18.sp,
            fontFamily: "Poppins",
            color: Color(0xff5DB1DF),
            fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            fontSize: 13.sp,
            fontFamily: "Intel",
            color: Colors.white,
            overflow: TextOverflow.ellipsis),
        displaySmall: TextStyle(
            fontSize: 10.sp, fontFamily: "Intel", color: Colors.white)),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xff5DB1DF),
      colorScheme: ColorScheme(
        primary: Color(0xff5DB1DF),
        background: Color(0XFF212845),
        secondary: Color(0xFFFE270D),
        surface: Color(0XFFF8D320),
        onSurface: Colors.green,
        brightness: Brightness.light,
        onError: Colors.red,
        primaryVariant: Color(0xFFFF6F43),
        secondaryVariant: Color(0xFFFE1B03),
        onBackground: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        error: Colors.grey,
        inversePrimary: Color(0xFFFF6F43),
        onInverseSurface: Color(0xFFFE1B03),
      ),
    ),
  );
  static ThemeData customLightThem = ThemeData.light().copyWith(
    backgroundColor: const Color(0xFFFCFCFC),
    primaryColor: Color(0xff5DB1DF),
    colorScheme: ColorScheme(
      primary: Color(0xffE0E0E0),
      background: Color(0xFFEEEEEE),
      secondary: Colors.green,
      onInverseSurface: Color(0xFFFE1B03),
      surface: Color(0XFFF8D320),
      onSurface: Colors.transparent,
      brightness: Brightness.light,
      onError: Colors.red,
      tertiary: Colors.blue,
      primaryVariant: Color(0xFFFF6F43),
      secondaryVariant: Color(0xFFFE1B03),
      onBackground: Colors.grey,
      onPrimary: Color(0xFFDDDDDD),
      inversePrimary: Colors.white,
      // inverseSurface: Colors.green.shade400,
      onSecondary: Colors.black,
      error: Color(0x00000000),
    ),
    cardTheme: CardTheme(color: Colors.white.withOpacity(0.4)),
    cardColor: const Color(0xFF2D4DAB),
    textTheme: TextTheme(
        bodyMedium: TextStyle(fontFamily: "Poppins", color: Colors.black),
        bodyLarge: TextStyle(
            fontSize: 18.sp,
            fontFamily: "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.bold),
        displayLarge: TextStyle(
          fontSize: 14.sp,
          fontFamily: "Poppins",
          color: Colors.black,
        ),
        displayMedium: TextStyle(
            fontSize: 13.sp,
            fontFamily: "Intel",
            color: Colors.black,
            overflow: TextOverflow.ellipsis),
        displaySmall: TextStyle(
            fontSize: 10.sp, fontFamily: "Intel", color: Colors.white)),
    scaffoldBackgroundColor: Colors.white,
    primaryColorLight: Colors.grey,
    primaryColorDark: Colors.black,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF2D4DAB),
      selectedItemColor: Color(0xff5DB1DF),
      selectedIconTheme: IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.black),
      selectedLabelStyle:
          TextStyle(fontFamily: "Poppins", color: Colors.white, fontSize: 7.sp),
      unselectedItemColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xff5DB1DF),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xff5DB1DF),
      colorScheme: ColorScheme(
        primary: Color(0xff5DB1DF),
        background: Colors.white54,
        secondary: Color(0xFFFE270D),
        surface: Color(0XFFF8D320),
        onSurface: Colors.green,
        onInverseSurface: Colors.red,
        brightness: Brightness.light,
        onError: Colors.red,
        primaryVariant: Colors.blue,
        secondaryVariant: Colors.blueAccent,
        onBackground: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        inversePrimary: Colors.red,
        error: Colors.grey.withOpacity(0.3),
      ),
    ),
  );
}
