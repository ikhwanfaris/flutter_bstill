import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class Playlists extends StatefulWidget {
  final MenuType menuType;

  const Playlists({Key? key, required this.menuType}) : super(key: key);

  @override
  PlaylistsState createState() => PlaylistsState();
}

class PlaylistsState extends State<Playlists> {
  List<PlaylistModel> followingPlaylists = [];
  List<PlaylistModel> myPlaylists = [];
  bool isLoading = false;
  int selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {
    setState(() {
      isLoading = true;
    });
    await UserProfileManager().refreshProfile();
    await getAllPlaylists();
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  String heading() {
    return AppLocalizations.of(context)!.playlists;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: AppTheme.singleton.primaryBackgroundColor,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-m-3.png'),
          // opacity: 0.7,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackNavBar(
            centerTitle: true,
            title: AppLocalizations.of(context)!.myPlaylist,
            backTapHandler: () {
              context.go('/account');
            },
          ),
          const SizedBox(
            height: 10,
          ),
          // Text(
          //   AppLocalizations.of(context)!.myPlaylist,
          //   style: TextStyles.titleBold.fontColor,
          // ).lP16,
          const SizedBox(
            height: 20,
          ),
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
              : Expanded(child: playlistsView()),
        ],
      ),
    );
  }

  Widget playlistsView() {
    List<PlaylistModel> playlists =
        selectedSegment == 0 ? myPlaylists : followingPlaylists;

    return playlists.isNotEmpty
        ? GridView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 0, bottom: 50),
            itemCount: playlists.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return PlayIconHoveringWidget(
                child: PlaylistCard(playlist: playlists[index]),
                tapHandler: () {
                  context.push('/playlist_detail/${playlists[index].id}',
                      extra: 2);
                },
              );
            },
          ).hP16
        : Center(
            child: Text(
              AppLocalizations.of(context)!.noDataFound,
              style: TextStyles.h3Style.fontColor,
              textAlign: TextAlign.center,
            ),
          );
  }

  getAllPlaylists() {
    UserProfileManager().refreshProfile(completionHandler: () {
      List<String> playlistsIds =
          UserProfileManager().user?.followingPlaylists ?? [];

      getIt<FirebaseManager>()
          .getMultiplePlaylistsByIds(playlistsIds)
          .then((result) {
        followingPlaylists = result;

        setState(() {});
      });
    });

    getIt<FirebaseManager>().getMyPlaylists().then((result) {
      myPlaylists = result;
      setState(() {});
    });
  }
}
