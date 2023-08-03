import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/app_config.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AppUtil {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Widget showToast(
      {required String message, required BuildContext context}) {
    return Flushbar(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      backgroundGradient: LinearGradient(
        colors: [AppTheme().themeColor, AppTheme().themeColor.withOpacity(0.7)],
        stops: const [0.6, 1],
      ),
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      // title: AppConfig.projectName,
      message: message,
      duration: const Duration(seconds: 3),
    )..show(context);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme().themeColor)),
          );
        });
  }

  static void dismissLoader(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Widget addProgressIndicator(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.black12,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme().themeColor)),
    ));
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<File> findPath(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }

  static void logoutAction(BuildContext cxt, VoidCallback handler) {
    showDialog(
      barrierDismissible: false,
      context: cxt,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(AppConfig.of(context)!.appDisplayName,
              style: TextStyle(color: AppTheme().themeColor)),
          content: Text(AppLocalizations.of(context)!.logout),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes,
                  style: TextStyle(color: AppTheme().themeColor)),
              onPressed: () {
                Navigator.of(context).pop();
                handler();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.no,
                  style: const TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
