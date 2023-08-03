import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SearchedGenreMusic extends StatefulWidget {
  final String genreId;
  final String genreName;

  const SearchedGenreMusic(
      {Key? key, required this.genreId, required this.genreName})
      : super(key: key);

  @override
  _SearchedGenreMusicState createState() => _SearchedGenreMusicState();
}

class _SearchedGenreMusicState extends State<SearchedGenreMusic> {
  List sections = [];
  bool isLoadingSongs = false;
  var isSubscribedSeeds = false;
  var isSubscribedStore = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    getIt<FirebaseManager>()
        .getHomePageData(genreId: widget.genreId, context: context)
        .then((result) {
      sections = result;
      setState(() {});
    });
    checkSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-m-3.png'),
          // opacity: 0.7,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          BackNavBar(
              centerTitle: true,
              title: widget.genreName,
              backTapHandler: () {
                context.pop();
              }),
          Expanded(child: dashBoardView())
        ],
      ),
    );
  }

  Widget dashBoardView() {
    return musicCollectionView();
  }

  Widget musicCollectionView() {
    return SingleChildScrollView(
      child: SizedBox(
        height: sections.length * 270,
        child: ListView.separated(
            // padding: const EdgeInsets.only(top: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sections.length,
            itemBuilder: (BuildContext ctx, int index) {
              Section section = sections[index];
              switch (section.dataType) {
                // case DataType.playlists:
                // return playlistSection(sections[index], context, 1);
                case DataType.artists:
                  return artistSection(sections[index], context, 1);
                case DataType.album:
                  return albumSection(sections[index], context, 1);
                case DataType.songs:
                  return !isLoadingSongs
                      ? songsSection(
                          sections[index],
                          context,
                          0,
                          isSubscribedStore == true ||
                              isSubscribedSeeds == true)
                      : const CircularProgressIndicator();
                default:
                  return Container();
              }
            },
            separatorBuilder: (BuildContext ctx, int index) {
              return const SizedBox(
                height: 50,
              );
            }),
      ),
    );
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
}
