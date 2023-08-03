import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class InputField extends StatefulWidget {
  final String? label;
  final bool? showLabelInNewLine;
  final String? hintText;
  final String? defaultText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ThemeIcon? icon;
  final int? maxLines;
  final bool? showDivider;
  final Color? iconColor;
  final bool? isDisabled;
  final bool? startedEditing;
  final bool? isError;
  final bool? iconOnRightSide;
  final Color? backgroundColor;
  final bool? showBorder;
  final Color? borderColor;
  final double? cornerRadius;

  final Color? cursorColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const InputField(
      {Key? key,
      this.label,
      this.showLabelInNewLine = true,
      this.hintText,
      this.defaultText,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.icon,
      this.maxLines,
      this.showDivider = false,
      this.iconColor,
      this.isDisabled,
      this.startedEditing = false,
      this.isError = false,
      this.iconOnRightSide = false,
      this.backgroundColor,
      this.showBorder = false,
      this.borderColor,
      this.cornerRadius = 0,
      this.cursorColor,
      this.textStyle,
      this.labelStyle})
      : super(key: key);

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  late String? label;
  late bool? showLabelInNewLine;

  late String? hintText;
  late String? defaultText;
  late TextEditingController? controller;
  late ValueChanged<String>? onChanged;
  late ValueChanged<String>? onSubmitted;
  late ThemeIcon? icon;
  late int? maxLines;
  late bool? showDivider;
  late Color? iconColor;
  late bool isDisabled;
  late bool? startedEditing;
  late bool? isError;
  late bool? iconOnRightSide;
  late Color? backgroundColor;
  late bool? showBorder;
  late Color? borderColor;
  late double? cornerRadius;

  late Color cursorColor;
  late TextStyle textStyle;
  late TextStyle labelStyle;

  @override
  void initState() {
    label = widget.label;
    showLabelInNewLine = widget.showLabelInNewLine;
    hintText = widget.hintText;
    defaultText = widget.defaultText;
    controller = widget.controller;
    onChanged = widget.onChanged;
    onSubmitted = widget.onSubmitted;
    icon = widget.icon;
    maxLines = widget.maxLines;
    showDivider = widget.showDivider;
    iconColor = widget.iconColor;
    isDisabled = widget.isDisabled ?? false;
    startedEditing = widget.startedEditing;
    isError = widget.isError;
    iconOnRightSide = widget.iconOnRightSide;
    backgroundColor = widget.backgroundColor;
    showBorder = widget.showBorder;
    borderColor = widget.borderColor;
    cornerRadius = widget.cornerRadius;

    cursorColor = widget.cursorColor ?? AppTheme().mediumLightColor;
    textStyle = widget.textStyle ?? TextStyles.bodySm;
    labelStyle =
        widget.labelStyle ?? TextStyles.bodyExtraSm.subTitleColor.semiBold;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      // margin: EdgeInsets.symmetric(vertical: 5),
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: maxLines != null
          ? (min(maxLines!, 10) * 20) + 45
          : label != null
              ? 70
              : 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (label != null && showLabelInNewLine == true)
              ? Text(label!, style: labelStyle).bP4
              : Container(),
          Row(
            children: [
              const SizedBox(width: 20),
              (label != null && showLabelInNewLine == false)
                  ? Text(label!,
                          style: TextStyles.bodyExtraSm.subTitleColor.semiBold)
                      .bP4
                  : Container(),
              iconOnRightSide == false ? iconView() : Container(),
              Expanded(
                child: SizedBox(
                  child: Focus(
                    child: TextField(
                      readOnly: isDisabled,
                      style: textStyle,
                      controller: controller,
                      onChanged: onChanged,
                      maxLines: maxLines ?? 1,
                      cursorColor: cursorColor,
                      decoration: InputDecoration(
                        hintStyle: TextStyles.bodySm.subTitleColor,
                        hintText: hintText,
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        onSubmitted!(value);
                      },
                    ).setPadding(
                        left: backgroundColor != null ? 16 : 5,
                        right: backgroundColor != null ? 16 : 5),
                    onFocusChange: (hasFocus) {
                      startedEditing = hasFocus;
                      setState(() {});
                    },
                  ),
                ),
              ),
              iconOnRightSide == true ? iconView() : Container(),
            ],
          ),
          line()
        ],
      ),
    );
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
        ? ThemeIconWidget(icon!,
                color: iconColor ?? AppTheme().themeColor, size: 20)
            .rP16
        : Container();
  }
}

class DropdownFiled extends StatefulWidget {
  final String? label;
  final bool? showLabelInNewLine;
  final String? hintText;
  final String? defaultText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingStart;
  final VoidCallback onPress;
  final ThemeIcon? icon;
  final int? maxLines;
  final bool? showDivider;
  final Color? iconColor;
  final bool? isDisabled;
  final bool? startedEditing;
  final bool? isError;
  final bool? iconOnRightSide;
  final Color? backgroundColor;
  final bool? showBorder;
  final Color? borderColor;
  final double? cornerRadius;

  final Color? cursorColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const DropdownFiled(
      {Key? key,
      this.label,
      this.showLabelInNewLine = true,
      this.hintText,
      this.defaultText,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.onEditingStart,
      required this.onPress,
      this.icon,
      this.maxLines,
      this.showDivider = false,
      this.iconColor,
      this.isDisabled,
      this.startedEditing = false,
      this.isError = false,
      this.iconOnRightSide = false,
      this.backgroundColor,
      this.showBorder = false,
      this.borderColor,
      this.cornerRadius = 0,
      this.cursorColor,
      this.textStyle,
      this.labelStyle})
      : super(key: key);

  @override
  _DropdownFiledState createState() => _DropdownFiledState();
}

class _DropdownFiledState extends State<DropdownFiled> {
  late String? label;
  late bool? showLabelInNewLine;

  late String? hintText;
  late String? defaultText;
  late TextEditingController? controller;
  late ValueChanged<String>? onChanged;
  late VoidCallback? onEditingStart;
  late ValueChanged<String>? onSubmitted;
  late VoidCallback onPress;
  late ThemeIcon? icon;
  late int? maxLines;
  late bool? showDivider;
  late Color? iconColor;
  late bool isDisabled;
  late bool? startedEditing;
  late bool? isError;
  late bool? iconOnRightSide;
  late Color? backgroundColor;
  late bool? showBorder;
  late Color? borderColor;
  late double? cornerRadius;

  late Color cursorColor;
  late TextStyle textStyle;
  late TextStyle labelStyle;

  @override
  void initState() {
    label = widget.label;
    showLabelInNewLine = widget.showLabelInNewLine;
    hintText = widget.hintText;
    defaultText = widget.defaultText;
    controller = widget.controller;
    onChanged = widget.onChanged;
    onSubmitted = widget.onSubmitted;
    onEditingStart = widget.onEditingStart;

    onPress = widget.onPress;
    icon = widget.icon;
    maxLines = widget.maxLines;
    showDivider = widget.showDivider;
    iconColor = widget.iconColor;
    isDisabled = widget.isDisabled ?? false;
    startedEditing = widget.startedEditing;
    isError = widget.isError;
    iconOnRightSide = widget.iconOnRightSide;
    backgroundColor = widget.backgroundColor;
    showBorder = widget.showBorder;
    borderColor = widget.borderColor;
    cornerRadius = widget.cornerRadius;
    cursorColor = widget.cursorColor ?? AppTheme().mediumLightColor;
    textStyle = widget.textStyle ?? TextStyles.bodySm;
    labelStyle =
        widget.labelStyle ?? TextStyles.bodyExtraSm.subTitleColor.semiBold;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines != null
          ? (min(maxLines!, 10) * 20) + 45
          : label != null
              ? 70
              : 50,
      child: InkWell(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (label != null && showLabelInNewLine == true)
                ? Text(label!, style: labelStyle).bP4
                : Container(),
            Row(
              children: [
                (label != null && showLabelInNewLine == false)
                    ? Text(label!,
                            style:
                                TextStyles.bodyExtraSm.subTitleColor.semiBold)
                        .bP4
                    : Container(),
                iconOnRightSide == false ? iconView() : Container(),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: isDisabled,
                              style: textStyle,
                              controller: controller,
                              onChanged: onChanged,
                              maxLines: maxLines ?? 1,
                              cursorColor: cursorColor,
                              decoration: InputDecoration(
                                hintStyle: TextStyles.bodySm.subTitleColor,
                                hintText: hintText,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                onSubmitted!(value);
                              },
                            ).setPadding(
                                left: backgroundColor != null ? 16 : 5,
                                right: backgroundColor != null ? 16 : 5),
                          ),
                          const ThemeIconWidget(
                            ThemeIcon.downArrow,
                            size: 20,
                          ).rP8
                        ],
                      ),
                      onFocusChange: (hasFocus) {
                        startedEditing = hasFocus;
                        onEditingStart;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                iconOnRightSide == true ? iconView() : Container(),
              ],
            ),
            line()
          ],
        ),
      ),
    );
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
        ? ThemeIconWidget(icon!,
                color: iconColor ?? AppTheme().themeColor, size: 20)
            .rP16
        : Container();
  }
}

// class InputPriceField extends StatefulWidget {
//   final String? label;
//   final String? hintText;
//   final String? currencyText;
//   final String? currencyFlag;
//   final bool? disableCurrencySelction;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;
//   final ValueChanged<String>? onCurrencyValueChanged;
//   final TextStyle? labelStyle;
//
//   const InputPriceField(
//       {Key? key,
//       this.label,
//       this.hintText,
//       this.currencyText,
//       this.currencyFlag,
//       this.controller,
//       this.onChanged,
//       this.onCurrencyValueChanged,
//       this.disableCurrencySelction,
//       this.labelStyle})
//       : super(key: key);
//
//   @override
//   _InputPriceFieldState createState() => _InputPriceFieldState();
// }
//
// class _InputPriceFieldState extends State<InputPriceField> {
//   late String? currencyText;
//   late String? currencyFlag;
//   late TextStyle labelStyle;
//
//   @override
//   void initState() {
//
//     currencyText = widget.currencyText;
//     currencyFlag = widget.currencyFlag;
//     labelStyle =
//         widget.labelStyle ?? TextStyles.bodyExtraSm.subTitleColor.semiBold;
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppTheme().primaryBackgroundColor,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       height: 80,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           widget.label != null
//               ? Text(widget.label!, style: labelStyle).bP8
//               : Container(),
//           Row(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     widget.currencyText ?? "+1",
//                     style: TextStyles.bodySm.bold,
//                   ).hP8.ripple(() {
//                     showCurrencyPicker(
//                       context: context,
//                       showFlag: true,
//                       showCurrencyName: true,
//                       showCurrencyCode: true,
//                       onSelect: (Currency currency) {
//                         setState(() {
//                           currencyFlag = currency.flag;
//                           currencyText = currency.symbol;
//                           widget.onCurrencyValueChanged!(widget.currencyText!);
//                         });
//                       },
//                     );
//                   }),
//                 ],
//               ),
//               Container(
//                 width: 1,
//                 height: 20,
//                 color: AppTheme().dividerColor,
//               ).hP16,
//               Expanded(
//                   child: TextField(
//                 style: TextStyles.bodySm,
//                 controller: widget.controller,
//                 onChanged: widget.onChanged,
//                 keyboardType: TextInputType.number,
//                 cursorColor: AppTheme().titleTextColor,
//                 decoration: InputDecoration(
//                   hintStyle: TextStyles.bodySm.subTitleColor,
//                   hintText: widget.hintText,
//                   border: InputBorder.none,
//                 ),
//               ))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class DropDownField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final bool? disable;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextStyle? labelStyle;

  const DropDownField(
      {Key? key,
      this.label,
      this.hintText,
      this.disable,
      this.controller,
      this.onTap,
      this.onChanged,
      this.labelStyle})
      : super(key: key);

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  late TextStyle? labelStyle;

  @override
  void initState() {
    labelStyle =
        widget.labelStyle ?? TextStyles.bodyExtraSm.subTitleColor.semiBold;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme().primaryBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Text(widget.label!, style: labelStyle).bP8
              : Container(),
          Row(
            children: [
              Expanded(
                  child: TextField(
                style: TextStyles.bodySm,
                controller: widget.controller,
                onChanged: widget.onChanged,
                keyboardType: TextInputType.number,
                cursorColor: AppTheme().mediumLightColor,
                decoration: InputDecoration(
                  hintStyle: TextStyles.bodySm..subTitleColor,
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
              )),
              ThemeIconWidget(ThemeIcon.downArrow, color: AppTheme().redColor)
            ],
          ).ripple(() {
            if (widget.disable != true) {
              widget.onTap!();
            }
          }),
        ],
      ),
    );
  }
}

class InputMobileNumberField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? phoneCodeText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? phoneCodeValueChanged;
  final bool? showDivider;
  final Color? cursorColor;
  final TextStyle? textStyle;
  final bool? isError;
  final TextStyle? labelStyle;

  const InputMobileNumberField(
      {Key? key,
      this.label,
      this.hintText,
      this.showDivider,
      required this.phoneCodeText,
      this.controller,
      required this.onChanged,
      required this.phoneCodeValueChanged,
      this.cursorColor,
      this.textStyle,
      this.isError,
      this.labelStyle})
      : super(key: key);

  @override
  InputMobileNumberFieldState createState() => InputMobileNumberFieldState();
}

class InputMobileNumberFieldState extends State<InputMobileNumberField> {
  late Color? cursorColor;
  late TextStyle? textStyle;
  bool? startedEditing;
  late bool? isError;
  late String? phoneCodeText;
  late TextStyle? labelStyle;

  @override
  void initState() {
    cursorColor = widget.cursorColor ?? AppTheme().mediumLightColor;
    textStyle = widget.textStyle ?? TextStyles.bodySm;
    isError = widget.isError;
    phoneCodeText = widget.phoneCodeText;
    labelStyle =
        widget.labelStyle ?? TextStyles.bodyExtraSm.subTitleColor.semiBold;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color:Colors.red,
      // margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      height: widget.label != null ? 61 : 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Text(widget.label!, style: labelStyle)
              : Container(),
          Row(children: [
            Text(
              phoneCodeText ?? "+1",
              style: textStyle,
            ).hP8.ripple(() {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                // optional. Shows phone code before the country name.
                onSelect: (Country country) {
                  setState(() {
                    phoneCodeText = '+${country.phoneCode}';
                    widget.phoneCodeValueChanged!('+${country.phoneCode}');
                  });
                },
              );
            }),
            Container(
              width: 0.5,
              height: 20,
              color: AppTheme().dividerColor,
            ).hP16,
            Expanded(
              child: SizedBox(
                  height: 46,
                  child: Focus(
                    child: TextField(
                      style: textStyle,
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      cursorColor: cursorColor,
                      decoration: InputDecoration(
                        hintStyle: TextStyles.bodySm..subTitleColor,
                        hintText: widget.hintText,
                        border: InputBorder.none,
                      ),
                    ),
                    onFocusChange: (hasFocus) {
                      startedEditing = hasFocus;
                      setState(() {});
                    },
                  )),
            )
          ]),
          line()
        ],
      ),
    );
  }

  Widget line() {
    return widget.showDivider == true
        ? Container(
            height: 0.5,
            color: startedEditing == true
                ? AppTheme().themeColor
                : isError == true
                    ? AppTheme().redColor
                    : AppTheme().dividerColor)
        : Container();
  }
}

class InputDateField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? defaultText;
  final ValueChanged<TimeOfDay>? onChanged;
  final TextStyle? labelStyle;

  const InputDateField(
      {Key? key,
      this.label,
      this.hintText,
      this.defaultText,
      this.onChanged,
      this.labelStyle})
      : super(key: key);

  @override
  _InputDateFieldState createState() => _InputDateFieldState();
}

class _InputDateFieldState extends State<InputDateField> {
  String? label;
  String? hintText;
  String? defaultText;
  TextEditingController controller = TextEditingController();
  ValueChanged<TimeOfDay>? onChanged;
  late TextStyle labelStyle;

  @override
  void initState() {
    hintText = widget.label;
    hintText = widget.hintText;
    defaultText = widget.defaultText;
    onChanged = widget.onChanged;

    controller.text = defaultText ?? '';
    labelStyle = widget.labelStyle ?? TextStyles.bodyExtraSm.semiBold;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Text(widget.label!, style: labelStyle).bP8
              : Container(),
          Container(
            width: 80,
            height: 50,
            color: AppTheme().primaryBackgroundColor,
            child: TextField(
              style: TextStyles.bodySm,
              textAlign: TextAlign.center,
              controller: controller,
              // onChanged: onChanged,
              cursorColor: AppTheme().mediumLightColor,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyles.bodySm..subTitleColor,
                border: InputBorder.none,
              ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay initialTime = TimeOfDay.now();
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: initialTime,
                );

                if (pickedTime != null) {
                  //print(pickedTime.minute); //pickedDate output format => 2021-03-10 00:00:00.000
                  // String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement
                  onChanged!(pickedTime);
                  setState(() {
                    controller.text = pickedTime
                        .format(context); //set output date to TextField value.
                  });
                } else {}
              },
            ).hP4,
          ).round(25),
        ],
      ),
    );
  }
}

class RoundedInputDateTimeField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? defaultText;
  final ValueChanged<DateTime>? onChanged;
  final TextStyle? labelStyle;

  const RoundedInputDateTimeField(
      {Key? key,
      this.label,
      this.hintText,
      this.defaultText,
      this.onChanged,
      this.labelStyle})
      : super(key: key);

  @override
  _RoundedInputDateTimeFieldState createState() =>
      _RoundedInputDateTimeFieldState();
}

class _RoundedInputDateTimeFieldState extends State<RoundedInputDateTimeField> {
  String? label;
  String? hintText;
  String? defaultText;
  TextEditingController controller = TextEditingController();
  ValueChanged<DateTime>? onChanged;
  late TextStyle labelStyle;

  @override
  void initState() {
    label = widget.label;
    hintText = widget.hintText;
    defaultText = widget.defaultText;
    onChanged = widget.onChanged;
    labelStyle = widget.labelStyle ?? TextStyles.bodyExtraSm.semiBold;
    controller.text = defaultText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          widget.label != null
              ? Text(widget.label!, style: labelStyle).bP8
              : Container(),
          Container(
            color: AppTheme().primaryBackgroundColor,
            child: Center(
              child: TextField(
                style: TextStyles.bodySm,
                textAlign: TextAlign.left,
                controller: controller,
                // onChanged: onChanged,
                cursorColor: AppTheme().mediumLightColor,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyles.bodySm..subTitleColor,
                  border: InputBorder.none,
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1960),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    onChanged!(pickedDate);
                    setState(() {
                      String formattedDate =
                          DateFormat('dd-MMM-yyyy').format(pickedDate);
                      controller.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ).hP16,
            ),
          ).round(25),
        ],
      ),
    );
  }
}
