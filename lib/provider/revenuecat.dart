import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../model/entitlement.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  // EntitlementInfo _entitlement = EntitlementInfo.free;
  // EntitlementInfo get entitlement => _entitlement;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });

    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // final entitlements = customerInfo.entitlements.active;
    // print(customerInfo);
    // _entitlement =
    //     entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;
    // access latest customerInfo
  }

  Future updatePurchaseStatus() async {
    final purchaserInfo = await Purchases.getCustomerInfo();
    // print(purchaserInfo.toJson());
    final entitlements = purchaserInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;

    notifyListeners();
  }
}
