import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

enum SegmentType {
  segmentType1,
  segmentType2,
  segmentType3,
  segmentType4,
  segmentType5
}

enum HighligherType {
  highligherType1,
  highligherType2,
  highligherType3,
  highligherType4,
  highligherType5,
  highligherType6
}

class SegmentTab extends StatefulWidget {
  final ThemeIcon? icon;
  final String? image;

  final String title;
  final SegmentType? segmentType;

  final bool isSelected;
  final double? cornerRadius;

  final Color? inActiveBgColor;
  final Color? activeBgColor;

  final Color? inActiveIconColor;
  final Color? activeIconColor;

  final TextStyle? inActiveTextStyle;
  final TextStyle? activeTextStyle;

  final Color? borderColor;

  const SegmentTab({
    Key? key,
    this.icon,
    this.image,
    this.segmentType,
    required this.title,
    required this.isSelected,
    this.inActiveBgColor,
    this.cornerRadius,
    this.activeBgColor,
    this.inActiveIconColor,
    this.activeIconColor,
    this.inActiveTextStyle,
    this.activeTextStyle,
    this.borderColor,
  }) : super(key: key);

  @override
  SegmentTabState createState() => SegmentTabState();
}

class SegmentTabState extends State<SegmentTab> {
  ThemeIcon? icon;
  String? image;

  late String title;
  late bool isSelected;
  late SegmentType type;
  late double cornerRadius;

  @override
  void initState() {
    icon = widget.icon;
    image = widget.image;
    title = widget.title;
    isSelected = widget.isSelected;
    type = widget.segmentType ?? SegmentType.segmentType1;
    cornerRadius = widget.cornerRadius ?? 5;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SegmentType.segmentType1:
        return segmentType1();
      case SegmentType.segmentType2:
        return segmentType2();
      case SegmentType.segmentType3:
        return segmentType3();
      case SegmentType.segmentType4:
        return segmentType1();
      case SegmentType.segmentType5:
        return segmentType1();
    }
  }

  Widget segmentType1() {
    return Container(
      child: icon != null
          ? Row(
              children: [
                icon != null
                    ? ThemeIconWidget(
                        icon!,
                        color: isSelected == true
                            ? widget.activeIconColor ??
                                AppTheme().primaryBackgroundColor
                            : widget.inActiveIconColor ?? AppTheme().themeColor,
                        size: 15,
                      )
                    : Container(
                        width: 1,
                      ),
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ??
                                TextStyles.bodyExtraSm.bold.lightColor
                            : widget.inActiveTextStyle ??
                                TextStyles.bodyExtraSm)
                    .hP8
              ],
            ).hP8
          : Center(
              child: Text(title,
                      style: isSelected == true
                          ? widget.activeTextStyle ??
                              TextStyles.bodyExtraSm.bold
                          : widget.inActiveTextStyle ?? TextStyles.bodyExtraSm)
                  .hP16),
    )
        .shadow(
            radius: cornerRadius,
            fillColor: isSelected == true
                ? widget.activeBgColor ?? AppTheme().themeColor
                : widget.inActiveBgColor)
        .vP4;
  }

  Widget segmentType2() {
    return Container(
      child: icon != null
          ? Row(
              children: [
                icon != null
                    ? ThemeIconWidget(
                        icon!,
                        color: isSelected == true
                            ? widget.activeIconColor ??
                                AppTheme().primaryBackgroundColor
                            : widget.inActiveIconColor ?? AppTheme().themeColor,
                        size: 15,
                      )
                    : Container(
                        width: 1,
                      ),
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ?? TextStyles.h1Style.bold
                            : widget.inActiveTextStyle ?? TextStyles.h1Style)
                    .hP8
              ],
            ).hP8
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ?? TextStyles.h1Style.bold
                            : widget.inActiveTextStyle ?? TextStyles.h1Style)
                    .bp(12),
                Container(
                  height: 5,
                  color: isSelected == true
                      ? widget.activeBgColor ?? AppTheme().themeColor
                      : widget.inActiveBgColor,
                  width: 50,
                ).round(5)
              ],
            ),
    );
  }

  Widget segmentType3() {
    return Container(
        child: Column(
      children: [
        Container(
          height: 45,
          width: 50,
          color: isSelected == true
              ? widget.activeBgColor ?? AppTheme().themeColor
              : widget.inActiveBgColor ?? AppTheme().grey.withOpacity(0.1),
          child: Image.asset(
            image!,
            color: AppTheme().primaryBackgroundColor,
          ).p8,
        ).round(18).bP16,
        Text(title,
            style: isSelected == true
                ? widget.activeTextStyle ?? TextStyles.bodySm.bold
                : widget.inActiveTextStyle ?? TextStyles.bodySm
              ..subTitleColor)
      ],
    ).hP8);
  }
}
