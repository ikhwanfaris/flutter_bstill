import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/theme/theme.dart';

class FontSizes {
  static double scale = 1.2;
  static double get body => 14 * scale;
  static double get bodySm => 12 * scale;
  static double get bodyExtraSm => 10 * scale;
  static double get bodySuperExtraSm => 9 * scale;
  static double get title => 15 * scale;
  static double get titleM => 18 * scale;
  static double get sizeSmallXl => 21 * scale;
  static double get sizeXl => 25 * scale;
  static double get sizeXXl => 32 * scale;
  static double get sizeXXXl => 50 * scale;
  static double get sizeXXXXl => 60 * scale;
}

extension TextStyles on TextStyle {
  static TextStyle get title {
    return TextStyle(fontSize: FontSizes.title, color: AppTheme().fontColor);
  }

  static TextStyle get titleM {
    return TextStyle(fontSize: FontSizes.titleM, color: AppTheme().fontColor);
  }

  static TextStyle get titleNormal {
    return title.copyWith(
        fontWeight: FontWeight.w500, color: AppTheme().mediumLightColor);
  }

  static TextStyle get titleMedium {
    return titleM.copyWith(
        fontWeight: FontWeight.w300, color: AppTheme().mediumLightColor);
  }

  static TextStyle get titleBold {
    return titleM.copyWith(
        fontWeight: FontWeight.bold,
        color: AppTheme().mediumLightColor,
        fontSize: FontSizes.title);
  }

  static TextStyle get h1Style {
    return TextStyle(
        fontSize: FontSizes.sizeXXl,
        fontWeight: FontWeight.bold,
        color: AppTheme().headingTextColor);
  }

  static TextStyle get h2Style {
    return TextStyle(
        fontSize: FontSizes.sizeXl,
        fontWeight: FontWeight.bold,
        color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get h3Style {
    return TextStyle(
        fontSize: FontSizes.sizeSmallXl,
        fontWeight: FontWeight.bold,
        color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get largeStyle {
    return TextStyle(
        fontSize: FontSizes.sizeXXXl,
        fontWeight: FontWeight.bold,
        height: 0.8,
        color: AppTheme().headingTextColor);
  }

  static TextStyle get superLargeStyle {
    return TextStyle(
        fontSize: FontSizes.sizeXXXXl,
        fontWeight: FontWeight.bold,
        height: 0.8,
        color: AppTheme().headingTextColor);
  }

  static TextStyle get body {
    return TextStyle(
        fontSize: FontSizes.body,
        fontWeight: FontWeight.w300,
        color: AppTheme().mediumLightColor);
  }

  static TextStyle get bodySm {
    return body.copyWith(
        fontSize: FontSizes.bodySm, color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get bodyExtraSm {
    return body.copyWith(
        fontSize: FontSizes.bodyExtraSm, color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get bodySuperExtraSm {
    return body.copyWith(
        fontSize: FontSizes.bodySuperExtraSm,
        color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get underlineNormal {
    return TextStyle(
        fontSize: FontSizes.body,
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.underline,
        color: AppTheme().subHeadingTextColor);
  }

  static TextStyle get lineThrough {
    return TextStyle(
        fontSize: FontSizes.body,
        fontWeight: FontWeight.w300,
        decoration: TextDecoration.lineThrough,
        color: AppTheme().subHeadingTextColor);
  }
}

// class LightTextStyles {
//   static TextStyle get title =>TextStyle(fontSize: FontSizes.title , color: AppTheme().subTitleTextColor(App.template1));
//   static TextStyle get titleM =>TextStyle(fontSize: FontSizes.titleM, color: AppTheme().subTitleTextColor(App.template1));
//   static TextStyle get titleNormal => title.copyWith(fontWeight: FontWeight.w500);
//   static TextStyle get titleMedium => titleM.copyWith(fontWeight: FontWeight.w300);
//   static TextStyle get h1Style => TextStyle(fontSize: FontSizes.sizeXXl, fontWeight: FontWeight.bold, color: AppTheme().subTitleTextColor(App.template1));
//   static TextStyle get h2Style => TextStyle(fontSize: FontSizes.sizeXl, fontWeight: FontWeight.bold, color: AppTheme().lightTitleTextColor(App.template1));
//   static TextStyle get superLargeStyle => TextStyle(fontSize: FontSizes.sizeXXXl, fontWeight: FontWeight.bold,height: 0.8);
//
//   static TextStyle get body => TextStyle(fontSize: FontSizes.body, fontWeight: FontWeight.w300, color: AppTheme().lightTitleTextColor(App.template1));
//   static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm.);
//   static TextStyle get bodyExtraSm => body.copyWith(fontSize: FontSizes.bodyExtraSm(app));
//   static TextStyle get bodySuperExtraSm => body.copyWith(fontSize: FontSizes.bodySuperExtraSm(app));
//
//   static TextStyle get underlineNormal => TextStyle(fontSize: FontSizes.body, fontWeight: FontWeight.w300,decoration: TextDecoration.underline, color: AppTheme().lightTitleTextColor(App.template1));
// }

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get lightBold => copyWith(fontWeight: FontWeight.w400);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w300);
  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get subTitleColor => copyWith(color: AppTheme().mediumLightColor);
  TextStyle get lightColor => copyWith(color: AppTheme().lightColor);

  TextStyle get redColor =>
      copyWith(color: AppTheme().redColor.withOpacity(0.7));
  TextStyle get greenColor =>
      copyWith(color: AppTheme().successColor.withOpacity(0.7));
  TextStyle get themeColor => copyWith(color: AppTheme().themeColor);
  TextStyle get skyBlueColor => copyWith(color: AppTheme().skyBlue);
  TextStyle get fontColor => copyWith(color: AppTheme().fontColor);
}
