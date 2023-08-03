import 'package:flutter/material.dart';

enum Font { lato, openSans, poppins, raleway, roboto, niramit }

class AppTheme {
  static AppTheme singleton = AppTheme._internal();
  Font fontType = Font.niramit;

  factory AppTheme() {
    return singleton;
  }

  AppTheme._internal();

  String get fontName {
    switch (fontType) {
      case Font.roboto:
        return 'Roboto';
      case Font.raleway:
        return 'Raleway';
      case Font.poppins:
        return 'Poppins';
      case Font.openSans:
        return 'OpenSans';
      case Font.lato:
        return 'Lato';
      case Font.niramit:
        return 'Niramit';
    }
  }

  double get iconSize {
    return 15;
  }

  Color get primaryBackgroundColor {
    return Template1App().color.primaryBackgroundColor;
  }

  Color get secondaryBackgroundColor {
    return Template1App().color.secondaryBackgroundColor;
  }

  Color get headingTextColor {
    return Template1App().color.headingTextColor;
  }

  Color get subHeadingTextColor {
    return Template1App().color.subHeadingTextColor;
  }

  Color get mediumLightColor {
    return Template1App().color.mediumLightColor;
  }

  Color get lightColor {
    return Template1App().color.lightTitleTextColor;
  }

  Color get skyBlue {
    return Colors.blueAccent;
  }

  Color get lightBlue {
    return Colors.blueAccent;
  }

  Color get extraLightBlue {
    return Colors.blueAccent;
  }

  Color get grey {
    return const Color(0XFF535c68);
  }

  Color get shadowColor {
    return Colors.grey;
  }

  Color get dividerColor {
    return Template1App().color.dividerColor;
  }

  Color get iconColor {
    return Template1App().color.mediumLightColor;
  }

  Color get redColor {
    return Template1App().color.errorColor;
  }

  Color get successColor {
    return Template1App().color.successColor;
  }

  Color get lightGreen {
    return Colors.greenAccent;
  }

  Color get yellow {
    return Template1App().color.yellowColor;
  }

  Color get themeColor {
    return Template1App().color.themeColor;
  }

  Color get black {
    return Template1App().color.blackColor;
  }

  Color get lightBlack {
    return Template1App().color.subHeadingTextColor;
  }

  Color get borderColor {
    return Template1App().color.borderColor;
  }

  Color get navigationBarColor {
    return Template1App().color.navigationBarColor;
  }

  Color get fontColor {
    return Template1App().color.fontColor;
  }
}

class Template1App {
  static final Template1App _singleton = Template1App._internal();

  factory Template1App() {
    return _singleton;
  }

  Template1App._internal();

  Template1AppColor color = Template1AppColor();
// double iconSize = 15;
// Font fontType = Font.openSans;
}

class Template1AppColor {
  static final Template1AppColor _singleton = Template1AppColor._internal();

  factory Template1AppColor() {
    return _singleton;
  }

  Template1AppColor._internal();

  Color get headingTextColor {
    return const Color(0xff2d3436);
  }

  Color get subHeadingTextColor {
    return const Color(0xff2d3436);
  }

  Color get primaryBackgroundColor {
    return const Color(0XFF0a0a0a);
  }

  Color get secondaryBackgroundColor {
    return const Color(0XFFFBFEFF);
  }

  Color get mediumLightColor {
    return const Color(0xffbdc3c7);
  }

  Color get lightTitleTextColor {
    return const Color(0xffffffff);
  }

  Color get blackColor {
    return const Color(0xff000000);
  }

  Color get borderColor {
    return const Color(0xff636e72);
  }

  Color get shadowColor {
    return const Color(0xffa4b0be);
  }

  Color get dividerColor {
    return const Color(0xff57606f).withOpacity(0.8);
  }

  Color get iconColor {
    return const Color(0xffecf0f1);
  }

  Color get errorColor {
    return const Color(0xffff4757);
  }

  Color get successColor {
    return const Color(0xff2ed573);
  }

  Color get themeColor {
    return const Color(0xff10ac84);
  }

  Color get yellowColor {
    return const Color(0xfff9ca24);
  }

  Color get enabledButtonBackgroundColor {
    return const Color(0xffd35400);
  }

  Color get disabledButtonBackgroundColor {
    return const Color(0xff7f8c8d);
  }

  Color get navigationBarColor {
    return const Color(0XFFc0e2fc);
  }

  Color get fontColor {
    return const Color(0XFF3c516e);
  }
}
