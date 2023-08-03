import 'package:music_streaming_mobile/app_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../helper/common_import.dart';

class PurchaseAPI {
  static Future init(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var env = packageInfo.packageName.split('.').last;
    var platform = 'android';

    if (Platform.isIOS) {
      platform = 'ios';
    }
    final _conf = PurchasesConfiguration(
        AppConfig.of(context)?.apiKey['revenueCat'][platform][env]);
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await Purchases.configure(
          _conf..appUserID = FirebaseAuth.instance.currentUser!.uid);
    } else {
      await Purchases.configure(_conf);
    }
  }

  static Future subscribePackage(Package package) async {
    try {
      var result = await Purchases.purchasePackage(package);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
