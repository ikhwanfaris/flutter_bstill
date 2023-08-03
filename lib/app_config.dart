import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  const AppConfig(
      {super.key,
      required this.appDisplayName,
      required this.appInternalId,
      required this.apiLink,
      required this.shareLink,
      required this.version,
      required this.prod,
      required this.apiKey,
      required this.tncUrl,
      required this.privacyPolicyUrl,
      required this.ef1_signatureVerifyUrl,
      required this.ef2_signatureVerifyUrl,
      required Widget child})
      : super(child: child);

  final String appDisplayName;
  final int appInternalId;
  final bool prod;
  final String apiLink;
  final String shareLink;
  final String version;
  final Map<dynamic, dynamic> apiKey;
  final String tncUrl;
  final String privacyPolicyUrl;
  final String ef1_signatureVerifyUrl;
  final String ef2_signatureVerifyUrl;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
