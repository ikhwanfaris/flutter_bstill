import 'package:music_streaming_mobile/helper/user_profile_manager.dart';
import 'package:music_streaming_mobile/main.dart';

import 'app_config.dart';
import 'package:flutter/material.dart';
import 'helper/pub_imports.dart';
import 'services/service_locator.dart';

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupServiceLocator();

  await Firebase.initializeApp();
  await UserProfileManager().refreshProfile();
}

void main() async {
  await init();

  var configuredApp = const AppConfig(
    appDisplayName: "BStill Staging",
    appInternalId: 1,
    apiLink: 'https://testapi.ambotcrypto.com/',
    shareLink: 'https://testapi.ambotcrypto.com/app/registration/',
    version: '0.0.1',
    prod: false,
    apiKey: {
      "revenueCat": {
        "ios": {
          "test": 'appl_eTERXAwayhtveozAQuJoihUqcvU',
          "prod": 'appl_hqWWELHfozcuvfNbxfWHNWWgHgb',
        },
        "android": {
          "test": 'goog_eVQYUDLVaPuPzRdhOSNivdSbNRP',
          "prod": 'goog_HkvLvznWGJXmnrvUrHiYXwtMEuw',
        }
      }
    },
    tncUrl: 'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
    privacyPolicyUrl: 'https://privacypolicy-2f852.web.app/',
    ef1_signatureVerifyUrl:
        'https://staging.eforestapi.com/api/bstill/signature/verify',
    ef2_signatureVerifyUrl:
        'https://staging.eforestv2api.com/api/fruits/signature/verify',
    child:
        // loadView2(),
        // SplashScreen(),
        MainApp(),
  );

  // runApp(configuredApp);
  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'AE'),
        Locale('ar', 'DZ'),
        Locale('de', 'DE'),
        Locale('fr', 'FR'),
        Locale('ru', 'RU')
      ],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: configuredApp));
}

// Widget loadView2() {
//   Future.delayed(const Duration(microseconds: 100)).then((_) {
//     return const MainApp();
//   });
//   return const SplashScreen();
//   // return const MainApp();
// }
