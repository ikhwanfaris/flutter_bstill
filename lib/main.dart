import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/l10n/l10n.dart';
import 'package:music_streaming_mobile/provider/locale_provider.dart';
import 'package:music_streaming_mobile/provider/revenuecat.dart';
import 'package:music_streaming_mobile/screens/dashboard/loading.dart';

import 'package:music_streaming_mobile/screens/misc/recently_played.dart';
import 'package:music_streaming_mobile/screens/my_account/browser.dart';
import 'package:music_streaming_mobile/screens/my_account/select_fav_artist.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:music_streaming_mobile/services/subscriptions_api.dart';

import 'app_config.dart';

// void init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();

//   await setupServiceLocator();

//   await Firebase.initializeApp();
//   await UserProfileManager().refreshProfile();
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     EasyLocalization(
//         useOnlyLangCode: true,
//         supportedLocales: const [
//           Locale('en', 'US'),
//           Locale('ar', 'AE'),
//           Locale('ar', 'DZ'),
//           Locale('de', 'DE'),
//           Locale('fr', 'FR'),
//           Locale('ru', 'RU')
//         ],
//         path: 'assets/translations',
//         // <-- change the path of the translation files
//         fallbackLocale: const Locale('en', 'US'),
//         child: const MainApp()),
//   );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MainApp());
  });
}

final GoRouter _router = GoRouter(
  observers: [
    GoRouterObserver(),
  ],
  routes: <GoRoute>[
    GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey, child: const LoadingScreen())),
    GoRoute(
        path: '/home',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                  menuType: MenuType.home,
                  selectedIndex: 0,
                ))),
    GoRoute(
        path: '/search',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey, child: const SearchByGenre())),
    GoRoute(
        path: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey, child: const LoginScreen())),
    GoRoute(
        path: '/verify-otp',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: VerifyOTP(
                    verificationId:
                        (state.extra as Map<String, String>)['verificationId']!,
                    phone: (state.extra as Map<String, String>)['phone']!))),
    GoRoute(
        path: '/playlists',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: const Playlists(menuType: MenuType.playlists))),
    GoRoute(
        path: '/change-language',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: ChangeLanguage(isFirstTimeLogin: state.extra as bool))),
    GoRoute(
        path: '/select-fav-artist',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child:
                    SelectFavArtists(isFirstTimeLogin: state.extra as bool))),
    GoRoute(
        path: '/search_anything',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                  menuType: MenuType.searchAnything,
                  selectedIndex: 1,
                ))),
    GoRoute(
        path: '/searched_genre_music/:id',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                  menuType: MenuType.searchByGenre,
                  selectedIndex: 1,
                  id: (state.params['id']!),
                  extraData: state.extra as String?,
                ))),
    GoRoute(
        path: '/my-playlist',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                    menuType: MenuType.myPlaylists, selectedIndex: 2))),
    GoRoute(
        path: '/followed-playlist',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                    menuType: MenuType.followedPlaylists, selectedIndex: 2))),
    GoRoute(
        path: '/followed-artists',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                    menuType: MenuType.followedArtists, selectedIndex: 2))),
    GoRoute(
        path: '/liked-songs',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child: MainScreen(
                    menuType: MenuType.likedSongs, selectedIndex: 0))),
    GoRoute(
        path: '/account',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            NoTransitionPage<void>(
                key: state.pageKey,
                child:
                    MainScreen(menuType: MenuType.account, selectedIndex: 2))),
    GoRoute(
      path: '/album_detail/:id',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: MainScreen(
                  menuType: MenuType.albumDetail,
                  id: (state.params['id']!),
                  selectedIndex: state.extra as int)),
    ),
    GoRoute(
      path: '/song_detail/:id',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: MainScreen(
                  menuType: MenuType.songDetail,
                  id: (state.params['id']!),
                  selectedIndex: 0)),
    ),
    GoRoute(
      path: '/playlist_detail/:id',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: MainScreen(
                  menuType: MenuType.playlistDetail,
                  id: (state.params['id']!),
                  selectedIndex: state.extra as int)),
    ),
    GoRoute(
      path: '/artist_detail/:id',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: MainScreen(
                  menuType: MenuType.artistDetail,
                  id: (state.params['id']!),
                  selectedIndex: state.extra as int)),
    ),
    GoRoute(
      path: '/terms-of-use',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: BrowserPage(
                  title: AppLocalizations.of(context)!.termsOfUse,
                  url: AppConfig.of(context)!.tncUrl)),
    ),
    GoRoute(
      path: '/favourite-artists',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey, child: const SelectFavArtists()),
    ),
    GoRoute(
      path: '/privacy-policy',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey,
              child: BrowserPage(
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  url: AppConfig.of(context)!.privacyPolicyUrl)),
    ),
    GoRoute(
      path: '/recently-played',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const History()),
    ),
    GoRoute(
      path: '/contact-us',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const ContactUs()),
    ),
    GoRoute(
      path: '/language',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey, child: const ChangeLanguage()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const Register()),
    ),
    GoRoute(
      path: '/reset_password',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey, child: const ResetPassword()),
    ),
    GoRoute(
      path: '/forgetPassword',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
              key: state.pageKey, child: const Forgetpassword()),
    ),
    GoRoute(
      path: '/seeallpage',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
        key: state.pageKey,
        child: MainScreen(
          menuType: MenuType.seeAllPage,
          selectedIndex: 1,
          a: state.extra,
        ),
      ),
    ),
    GoRoute(
      path: '/seeallsongpage',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          NoTransitionPage<void>(
        key: state.pageKey,
        child: MainScreen(
          menuType: MenuType.seeAllSongPage,
          selectedIndex: 1,
          a: state.extra,
        ),
      ),
    ),
  ],
);

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    PurchaseAPI.init(context);
    getIt<PlayerManager>().init();
  }

  @override
  void dispose() {
    getIt<PlayerManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => RevenueCatProvider()),
      ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
          builder: (context, child) {
            final provider = Provider.of<LocaleProvider>(context);
            return MaterialApp.router(
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
              // routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
              // routeInformationParser: RoutemasterParser(),

              theme: ThemeData(
                fontFamily: AppTheme().fontName,
              ),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: L10n.all,
              locale: provider.locale,
              // navigatorKey: NoomiKeys.navKey,
              builder: EasyLoading.init(),
              // home: FirebaseAuth.instance.currentUser?.uid == null ? const LoginScreen() : const MainScreen(),
              // home: const MainScreen(),
            );
          })
    ]);
  }
}

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // checkSubscriptionStatus();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // checkSubscriptionStatus();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // checkSubscriptionStatus();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // checkSubscriptionStatus();
  }
}
