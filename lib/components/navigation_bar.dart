import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class CustomNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget child;
  final bool? showSeparator;
  final Color? backgroundColor;

  const CustomNavigationBar(
      {Key? key, required this.child, this.showSeparator, this.backgroundColor})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: backgroundColor ??
                    AppTheme.singleton.primaryBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50, child: child).tp(50),
                    const Spacer(),
                  ],
                ).hP16,
              ),
            ),
            showSeparator == true
                ? Divider(height: 1, color: AppTheme.singleton.dividerColor)
                : Container()
          ],
        ));
  }
}

class BackNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;
  final bool? centerTitle;
  final VoidCallback backTapHandler;

  const BackNavigationBar(
      {Key? key,
      this.title,
      this.showDivider,
      this.centerTitle,
      required this.backTapHandler})
      : preferredSize = const Size.fromHeight(80.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: AppTheme.singleton.primaryBackgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  ThemeIconWidget(ThemeIcon.backArrow,
                          size: AppTheme.singleton.iconSize,
                          color: AppTheme.singleton.iconColor)
                      .ripple(() {
                    backTapHandler();
                    // Navigator.of(context).pop();
                  }),
                  centerTitle == true ? const Spacer() : Container(),
                  centerTitle != true ? Container(width: 20) : Container(),
                  title != null
                      ? Text(title!,
                              style: TextStyles.h3Style.bold.subTitleColor)
                          .ripple(() {
                          backTapHandler();
                          //Navigator.of(context).pop();
                        })
                      : Container(),
                  centerTitle == true ? const Spacer() : Container(),
                  Container(width: 20)
                ],
              ).tp(55).hP16,
              const Spacer(),
              showDivider == true
                  ? Divider(height: 1, color: AppTheme.singleton.dividerColor)
                  : Container()
            ],
          ),
        ));
  }
}

class NavigationBarWithCloseBtn extends StatelessWidget
    with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;
  final bool? centerTitle;

  const NavigationBarWithCloseBtn(
      {Key? key, this.title, this.showDivider, this.centerTitle})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: AppTheme.singleton.primaryBackgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  ThemeIconWidget(ThemeIcon.close,
                          size: AppTheme.singleton.iconSize)
                      .ripple(() {
                    // Routemaster.of(context).pop();
                  }),
                  centerTitle == true ? const Spacer() : Container(),
                  centerTitle != true ? Container(width: 20) : Container(),
                  title != null
                      ? Text(title!, style: TextStyles.body.bold).ripple(() {
                          // NavigationService.instance.goBack();
                          // Routemaster.of(context).pop();
                        })
                      : Container(),
                  centerTitle == true ? const Spacer() : Container(),
                  Container(width: 20)
                ],
              ).tp(55).hP16,
              const Spacer(),
              showDivider == true
                  ? Divider(height: 1, color: AppTheme.singleton.dividerColor)
                  : Container()
            ],
          ),
        ));
  }
}

class TitleNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;

  const TitleNavigationBar({Key? key, required this.title, this.showDivider})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: AppTheme.singleton.primaryBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title!, style: TextStyles.body.bold).bP16,
              showDivider == true
                  ? Divider(height: 1, color: AppTheme.singleton.dividerColor)
                  : Container()
            ],
          ),
        ));
  }
}

class BackNavBar extends StatelessWidget {
  final String? title;
  final bool? showDivider;
  final bool? centerTitle;
  final VoidCallback backTapHandler;

  const BackNavBar(
      {Key? key,
      this.title,
      this.showDivider,
      this.centerTitle,
      required this.backTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 90 : 85,
      color: AppTheme.singleton.primaryBackgroundColor.withOpacity(0.5),
      child: Column(
        children: [
          Row(
            children: [
              ThemeIconWidget(ThemeIcon.backArrow,
                      size: AppTheme.singleton.iconSize,
                      color: AppTheme.singleton.lightColor)
                  .ripple(() {
                backTapHandler();
                // Navigator.of(context).pop();
              }).tp(Platform.isIOS ? 0 : 5),
              centerTitle == true ? const Spacer() : Container(),
              centerTitle != true ? Container(width: 20) : Container(),
              title != null
                  ? Text(title!, style: TextStyles.titleMedium.lightColor)
                      .ripple(() {
                      backTapHandler();
                      //Navigator.of(context).pop();
                    })
                  : Container(),
              centerTitle == true ? const Spacer() : Container(),
              Container(width: 20)
            ],
          ).tp(Platform.isIOS ? 50 : 40).hP16,
          const Spacer(),
          showDivider == true
              ? Divider(height: 1, color: AppTheme.singleton.dividerColor)
              : Container()
        ],
      ),
    );
  }
}
