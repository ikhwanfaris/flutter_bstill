import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/provider/locale_provider.dart';
import 'package:music_streaming_mobile/screens/dashboard/see_all_page_genre.dart';
import 'package:music_streaming_mobile/screens/dashboard/see_all_page_song.dart';
import '../../provider/revenuecat.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

//ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  MenuType menuType;
  final String? id;
  final String? extraData;
  final Object? a;
  final List? b;
  final String? title;
  int selectedIndex; //New
  MainScreen(
      {Key? key,
      required this.menuType,
      this.id,
      this.extraData,
      this.a,
      this.b,
      this.title,
      required this.selectedIndex})
      : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late MenuType menuType;
  late String? id;
  late String? extraData;
  WeSlideController weSlideController = WeSlideController();
  final player = AudioPlayer();
  bool fullScreenPlayer = false;
  final playerManager = getIt<PlayerManager>();
  var isSubscribed = false;
  // var navBarItems = <BottomNavigationBarItem>[];
  var navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: 'Home',
      backgroundColor: AppTheme.singleton.navigationBarColor,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.search),
      label: 'Search',
      backgroundColor: AppTheme.singleton.navigationBarColor,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_circle),
      label: 'Account',
      backgroundColor: AppTheme.singleton.navigationBarColor,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.star),
      label: 'Premium',
      backgroundColor: AppTheme.singleton.navigationBarColor,
    )
  ];
  var isSubscriptionLoading = false;
  var isSubscribedSeeds = false;
  var isSubscribedStore = false;

  @override
  void initState() {
    id = widget.id;
    extraData = widget.extraData;
    menuType = widget.menuType;

    setLang();
    checkSubscription();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print("WidgetsBinding");
      checkSubscription();
    });

    super.initState();
  }

  @override
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant oldWidget) {
    checkSubscription();
    super.didUpdateWidget(oldWidget);
  }

  checkSubscription() async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      setState(() {
        isSubscriptionLoading = true;
      });
      try {
        await UserProfileManager().refreshProfile();
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        isSubscribedStore = customerInfo.activeSubscriptions.isNotEmpty;

        isSubscribedSeeds =
            UserProfileManager().user?.active_subscription != '' &&
                (UserProfileManager().user!.subscribeVia == 'EFOREST_SEEDS' ||
                    UserProfileManager().user?.subscribeVia == 'EF2_FRUITS') &&
                UserProfileManager().user!.subscribeStatus == 'A';

        if (isSubscribedStore == true || isSubscribedSeeds == true) {
          isSubscribed = true;
        } else {
          isSubscribed = false;
        }

        setState(() {
          navBarItems = <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)?.home,
              backgroundColor: AppTheme.singleton.navigationBarColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)?.search,
              backgroundColor: AppTheme.singleton.navigationBarColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: AppLocalizations.of(context)?.account,
              backgroundColor: AppTheme.singleton.navigationBarColor,
            ),
            if (isSubscribed == false)
              BottomNavigationBarItem(
                icon: const Icon(Icons.star),
                label: AppLocalizations.of(context)?.premium,
                backgroundColor: AppTheme.singleton.navigationBarColor,
              )
          ];
          isSubscriptionLoading = false;
        });
        // access latest customerInfo
      } on PlatformException catch (e) {
        // Error fetching customer info
        setState(() {
          isSubscriptionLoading = false;
        });
        print(e);
        // return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    // checkSubscription();
    // navBarSetup(context);

    const double _panelMinSize = 170.0;
    final double _panelMaxSize = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.singleton.black,
      body: ValueListenableBuilder<bool>(
          valueListenable: playerManager.playStateNotifier,
          builder: (_, value, __) {
            // print(
            //     'playerManager.playStateNotifier ${playerManager.playStateNotifier}');
            return ValueListenableBuilder<bool>(
                valueListenable: playerManager.playStateNotifier,
                builder: (_, value, __) {
                  return navBarItems.isNotEmpty
                      ? WeSlide(
                          appBarHeight: 150,
                          controller: weSlideController,
                          backgroundColor:
                              AppTheme.singleton.primaryBackgroundColor,
                          panelMinSize: value == true ? _panelMinSize : 0,
                          panelMaxSize: _panelMaxSize,
                          body: loadView(),
                          footer: !isSubscriptionLoading
                              ? bottomNavigationBar()
                              : Container(),
                          footerHeight: 92,
                          panel: value == true
                              ? const FullScreenPlayerController()
                              : Container(),
                          panelHeader: value == true
                              ? Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    playerManager.closePlayer();
                                  },
                                  background: Container(
                                    color: Colors.red,
                                  ),
                                  child: SmallPlayerController(
                                      weSlideController: weSlideController),
                                )
                              : Container(),
                        )
                      : Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                });
          }),
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex, //New
      unselectedItemColor: AppTheme.singleton.fontColor,
      selectedItemColor: AppTheme.singleton.fontColor,
      items: navBarItems,
      onTap: _onItemTapped, //New
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      if (index == 0) {
        widget.menuType = MenuType.home;
      } else if (index == 1) {
        widget.menuType = MenuType.search;
      }
      //  else if (index == 2) {
      //   widget.menuType = MenuType.playlists;
      // }
      // else if (index == 3) {
      //   widget.menuType = MenuType.likedSongs;
      // }
      else if (index == 2) {
        widget.menuType = MenuType.account;
      } else if (index == 3) {
        widget.menuType = MenuType.premium;
      }
    });
  }

  Widget loadView() {
    if (widget.menuType == MenuType.home) {
      return const Dashboard();
      // return const MyAccount();
    } else if (widget.menuType == MenuType.search) {
      return const SearchByGenre();
    } else if (widget.menuType == MenuType.searchByGenre) {
      return SearchedGenreMusic(genreId: id!, genreName: extraData!);
    }
    // else if (widget.menuType == MenuType.searchAnything) {
    //   return SearchAnything();
    // }
    else if (widget.menuType == MenuType.playlists) {
      return const Playlists(menuType: MenuType.playlists);
    } else if (widget.menuType == MenuType.myPlaylists) {
      return const Playlists(menuType: MenuType.myPlaylists);
    } else if (widget.menuType == MenuType.followedPlaylists) {
      return const Playlists(menuType: MenuType.followedPlaylists);
    } else if (widget.menuType == MenuType.followedArtists) {
      return const Artists(menuType: MenuType.followedArtists);
    } else if (widget.menuType == MenuType.likedSongs) {
      return const LikedSongs();
    }
    //  else if (widget.menuType == MenuType.songDetail) {
    //   return SongDetail(
    //     songId: id!,
    //     index: widget.selectedIndex,
    //   );
    // }
    else if (widget.menuType == MenuType.playlistDetail) {
      return PlaylistDetail(playlistId: id!, index: widget.selectedIndex);
    } else if (widget.menuType == MenuType.albumDetail) {
      return AlbumDetail(
        albumId: id!,
        index: widget.selectedIndex,
        // playHandler: (album) {
        //   setState(() {
        //     // play album here
        //     getAllSongsFromAlbum(album);
        //   });
        // },
      );
    } else if (widget.menuType == MenuType.genreDetail) {
      return SearchedGenreMusic(
        genreId: id!,
        genreName: widget.selectedIndex.toString(),
      );
    } else if (widget.menuType == MenuType.artistDetail) {
      return ArtistDetail(artistId: id!, index: widget.selectedIndex);
    } else if (widget.menuType == MenuType.termsOfUse) {
      return const TermsOfUse();
    } else if (widget.menuType == MenuType.privacyPolicy) {
      return const PrivacyPolicy();
    } else if (widget.menuType == MenuType.contactUs) {
      return const ContactUs();
    } else if (widget.menuType == MenuType.account) {
      return const MyAccount();
    } else if (widget.menuType == MenuType.language) {
      return const ChangeLanguage();
    } else if (widget.menuType == MenuType.premium) {
      return PremiumPage(navBarItems: navBarItems);
    } else if (widget.menuType == MenuType.seeAllPage) {
      // Sample sample = Sample(attributeA: widget.a, attributeB: "");
      // print(widget.a);
      // jsonDecode(widget.a);
      // print(sample.attributeA.toString());
      return SeeAllPage(
        genre: widget.a,
        title: "aa",
      );
    } else if (widget.menuType == MenuType.seeAllSongPage) {
      // Sample sample = Sample(attributeA: widget.a, attributeB: "");
      // print(widget.a);
      // jsonDecode(widget.a);
      // print(sample.attributeA.toString());
      return SeeAllPageSongs(
          songs: widget.a, title: "aa", isSubscribed: isSubscribed);
    }
    return const Dashboard();
  }

  setLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    String languageCode = prefs.getString('BSTILL_LANG') ?? "en";
    // String languageName = prefs.getString('BSTILL_LANG_NAME') ?? "EN";
    if (languageCode.contains('_')) {
      var symbol = [];
      symbol.addAll(languageCode.split('_'));
      provider.setLocale(Locale(symbol.first, symbol.last));
    } else {
      provider.setLocale(Locale(languageCode));
    }
    if (languageCode == 'zh_Cn') {
      languageCode.replaceAll('zh_Cn', '简体');
      // print(languageCode + '123');
    }
  }
// getAllSongsFromAlbum(AlbumModel album) {
//   getIt<PlayerManager>().addPlaylist(album.songs);
//   getIt<PlayerManager>().play();
// }
}
