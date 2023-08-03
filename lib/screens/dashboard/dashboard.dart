import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Section {
  Section({required this.heading, required this.items, required this.dataType});

  String heading;
  List<dynamic> items = [];
  DataType dataType = DataType.playlists;
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<BannerModel> banners = [];

  List sections = [];
  bool isLoading = false;
  bool isLoadingSongs = false;
  var isSubscribedSeeds = false;
  var isSubscribedStore = false;

  @override
  void initState() {
    loadData();
    super.initState();
    // EasyLoading.show(status: AppLocalizations.of(context)?.loading);
  }

  loadData() async {
    // print("dashboard");
    // getAllBanners();
    setState(() {
      isLoading = true;
    });
    checkSubscription();

    sections = await getIt<FirebaseManager>().getHomePageData(context: context);
    setState(() {
      sections = sections;
    });
    // .then((result) {
    //   // EasyLoading.dismiss();
    //   sections = result;
    setState(() {
      isLoading = false;
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.singleton.navigationBarColor,
          height: Platform.isIOS ? 100 : 85,
          child: Row(
            children: [
              Container(
                color: Colors.transparent,
                height: 37,
                width: 100,
                child: Image.asset(
                  'assets/images/bstill-text-logo.png',
                  fit: BoxFit.fill,
                ),
              ),
              // ClipRRect(
              //   borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              //   child: InkWell(
              //     onTap: () => {context.go('/liked-songs')},
              //     child: Container(
              //       padding: const EdgeInsets.all(6.0),
              //       decoration: BoxDecoration(
              //         color: Colors.transparent,
              //         borderRadius: BorderRadius.circular(30.0),
              //         border: Border.all(
              //           color: AppTheme.singleton.fontColor,
              //           style: BorderStyle.solid,
              //           width: 1.0,
              //         ),
              //       ),
              //       height: 30,
              //       width: 30,
              //       child: Image.asset('assets/images/button-favourite.png',
              //           fit: BoxFit.contain),
              //     ),
              //   ),
              // ),
            ],
            // ),
          ).setPadding(left: 16, top: Platform.isIOS ? 50 : 30, right: 16),
        ),
        Container(child: dashBoardView())
      ],
    );
  }

  Widget dashBoardView() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-m-2.png'),
            // opacity: 0.7,
            fit: BoxFit.cover,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  banners.isNotEmpty ? sliderView() : Container(),
                  // IconButton(onPressed: onPressed, icon: const Icon(Icons.favorite)),
                  isLoading
                      ? Center(
                          child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )))
                      : musicCollectionView(),

                  // const SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget musicCollectionView() {
    return SizedBox(
      height: sections.length * 250,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sections.length,
        itemBuilder: (BuildContext ctx, int index) {
          Section section = sections[index];
          switch (section.dataType) {
            // case DataType.playlists:
            // return playlistSection(sections[index], context, 0);
            case DataType.artists:
              return artistSection(sections[index], context, 0);
            case DataType.album:
              return albumSection(sections[index], context, 0);
            case DataType.genre:
              return genreSection(sections[index], context, 0);
            case DataType.songs:
              return !isLoadingSongs
                  ? songsSection(sections[index], context, 0,
                      isSubscribedStore == true || isSubscribedSeeds == true)
                  : const CircularProgressIndicator();
            case DataType.freeSongs:
              return songsSection(sections[index], context, 0, true);
            default:
              return Container();
          }
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(
            height: 30,
          );
        },
      ),
    );
  }

  Widget sliderView() {
    return banners.isNotEmpty
        ? SizedBox(
            height: 180,
            child: CarouselSlider(
              items: banners
                  .map((element) => CachedNetworkImage(
                        imageUrl: element.image,
                        fit: BoxFit.cover,
                        height: 160,
                        // width: MediaQuery.of(context).size.width * 0.5,
                      ).round(20).p8.ripple(() {
                        bannerTapped(element);
                      }))
                  .toList(),
              options: CarouselOptions(
                height: 180,
                // aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (page, reason) {},
                scrollDirection: Axis.horizontal,
              ),
            )

            // InfiniteCarousel.builder(
            //   itemCount: banners.length,
            //   itemExtent: MediaQuery.of(context).size.width * 0.8,
            //   center: true,
            //   anchor: 0.0,
            //   velocityFactor: 0.2,
            //   onIndexChanged: (index) {},
            //   controller: controller,
            //   axisDirection: Axis.horizontal,
            //   loop: true,
            //   itemBuilder: (context, itemIndex, realIndex) {
            //     return ;
            //   },
            // ),
            )
        : Container();
  }

  bannerTapped(BannerModel banner) {
    if (banner.type == 1) {
      context.push('/song_detail/${banner.itemId}', extra: 0);
    }
    if (banner.type == 2) {
      context.push('/playlist_detail/${banner.itemId}', extra: 0);
    }
    if (banner.type == 3) {
      context.push('/album_detail/${banner.itemId}', extra: 0);
    }
  }

  getAllBanners() {
    getIt<FirebaseManager>().getAllBanners().then((result) {
      banners = result;
      setState(() {});
    });
  }

  checkSubscription() async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      try {
        setState(() {
          isLoadingSongs = true;
        });
        await UserProfileManager().refreshProfile();
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        isSubscribedSeeds =
            UserProfileManager().user!.active_subscription != '' &&
                (UserProfileManager().user!.subscribeVia == 'EFOREST_SEEDS' ||
                    UserProfileManager().user?.subscribeVia == 'EF2_FRUITS') &&
                UserProfileManager().user!.subscribeStatus == 'A';
        isSubscribedStore = customerInfo.activeSubscriptions.isNotEmpty;

        setState(() {
          isLoadingSongs = false;
        });
        if (isSubscribedStore == true || isSubscribedSeeds == true) {
          return true;
        } else {
          return false;
        }

        // access latest customerInfo
      } on PlatformException catch (e) {
        // Error fetching customer info
        print(e);
        setState(() {
          isLoadingSongs = false;
        });
        return false;
      }
    }
  }

  // onPressed() {
  //   context.push('/reset_password');
  // }
}
