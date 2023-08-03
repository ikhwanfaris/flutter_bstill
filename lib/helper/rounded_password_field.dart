import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PasswordField extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final String? label;
  final bool? showDivider;
  final bool? iconOnRightSide;
  final ThemeIcon? icon;
  final Color? iconColor;
  final bool? showRevealPasswordIcon;
  final bool? showLabelInNewLine;
  final bool? showBorder;
  final Color? borderColor;
  final bool? isError;
  final bool? startedEditing;
  final double? cornerRadius;

  final Color? cursorColor;
  final TextStyle? textStyle;

  const PasswordField({
    Key? key,
    required this.onChanged,
    this.controller,
    this.label,
    this.hintText,
    this.showDivider = false,
    this.backgroundColor,
    this.iconOnRightSide,
    this.iconColor,
    this.icon,
    this.showLabelInNewLine = true,
    this.showRevealPasswordIcon = false,
    this.showBorder = false,
    this.borderColor,
    this.isError = false,
    this.startedEditing = false,
    this.cornerRadius = 0,
    this.cursorColor,
    this.textStyle,
  }) : super(key: key);

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;
  late String? label;
  late String? hintText;
  late bool? showDivider;
  late Color? backgroundColor;
  late bool? iconOnRightSide;
  late ThemeIcon? icon;
  late Color? iconColor;
  late bool? showRevealPasswordIcon;
  late bool? showLabelInNewLine;
  late bool? showBorder;
  late Color? borderColor;
  late bool? isError;
  late bool? startedEditing;
  late double? cornerRadius;
  late ValueChanged<String> onChanged;
  late TextEditingController? controller;

  late Color? cursorColor;
  late TextStyle? textStyle;

  @override
  void initState() {
    onChanged = widget.onChanged;
    controller = widget.controller;
    hintText = widget.hintText;
    label = widget.label;
    showDivider = widget.showDivider;
    backgroundColor = widget.backgroundColor;
    iconColor = widget.iconColor;
    icon = widget.icon;
    iconOnRightSide = widget.iconOnRightSide;
    showRevealPasswordIcon = widget.showRevealPasswordIcon;
    showLabelInNewLine = widget.showLabelInNewLine;
    showBorder = widget.showBorder;
    borderColor = widget.borderColor;
    isError = widget.isError;
    startedEditing = widget.startedEditing;
    cornerRadius = widget.cornerRadius;

    cursorColor = widget.cursorColor;
    textStyle = widget.textStyle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: EdgeInsets.symmetric(vertical: 5),
      height: label != null ? 70 : 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (label != null && showLabelInNewLine == true)
              ? Text(label!,
                      style: TextStyles.bodyExtraSm.subTitleColor.semiBold)
                  .bP4
              : Container(),
          Expanded(
            child: Row(
              children: [
                (label != null && showLabelInNewLine == false)
                    ? Text(label!,
                            style:
                                TextStyles.bodyExtraSm.subTitleColor.semiBold)
                        .bP4
                    : Container(),
                iconView(),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: isError == false
                        ? backgroundColor
                        : (showDivider == false && showBorder == false)
                            ? AppTheme().redColor
                            : backgroundColor,
                    borderRadius: BorderRadius.circular(cornerRadius ?? 0),
                    border: showBorder == true
                        ? Border.all(
                            width: 0.5,
                            color: isError == true
                                ? AppTheme().redColor
                                : borderColor ?? AppTheme().borderColor)
                        : null,
                  ),
                  child: Focus(
                    child: TextField(
                            style: textStyle ?? TextStyles.bodySm,
                            controller: controller,
                            onChanged: onChanged,
                            cursorColor: cursorColor ?? AppTheme().black,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hintStyle: TextStyles.bodySm.subTitleColor,
                              hintText: hintText,
                              border: InputBorder.none,
                            ))
                        .setPadding(
                            left: backgroundColor != null ? 16 : 0,
                            right: backgroundColor != null ? 16 : 0),
                    onFocusChange: (hasFocus) {
                      startedEditing = hasFocus;
                      setState(() {});
                    },
                  ),
                )),
                revealPasswordIcon()
              ],
            ),
          ),
          line()
        ],
      ),
    );
  }

  Widget revealPasswordIcon() {
    return showRevealPasswordIcon == true
        ? ThemeIconWidget(
            showPassword == false ? ThemeIcon.reveal : ThemeIcon.hide,
            color: AppTheme().themeColor,
            size: 20,
          ).rP16.ripple(() {
            setState(() {
              showPassword = !showPassword;
            });
          })
        : Container();
  }

  Widget line() {
    return showDivider == true
        ? Container(
            height: 0.5,
            color: startedEditing == true
                ? AppTheme().themeColor
                : isError == true
                    ? AppTheme().redColor
                    : AppTheme().dividerColor)
        : Container();
  }

  Widget iconView() {
    return icon != null
        ? ThemeIconWidget(
            icon!,
            color: iconColor ?? AppTheme().themeColor,
            size: 20,
          ).rP16
        : Container();
  }
}
