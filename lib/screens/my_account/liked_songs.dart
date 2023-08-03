import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class LikedSongs extends StatefulWidget {
  const LikedSongs({Key? key}) : super(key: key);

  @override
  LikedSongsState createState() => LikedSongsState();
}

class LikedSongsState extends State<LikedSongs> {
  List<SongModel> allSongs = [];
  List<String> songsList = [];
  List<SongModel> a = [];
  bool isLoading = false;
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
    await getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-m-4.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
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
                  ),
                ),
              )
            : Column(
                children: [
                  BackNavBar(
                    title: AppLocalizations.of(context)!.likedSongs,
                    centerTitle: true,
                    backTapHandler: () async {
                      // context.pop();
                      // Navigator.of(context).pop();
                      context.go('/account');
                    },
                  ),
                  allSongs.isNotEmpty
                      ? Column(
                          children: [
                            basicInfo(),
                            songsView(),
                            const SizedBox(height: 30),
                          ],
                        ).hP16
                      : Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bg-m-4.png'),
                              // opacity: 0.7,
                              fit: BoxFit.cover,
                            ),
                          ),
                          //color: AppTheme.singleton.primaryBackgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              Image.asset(
                                'assets/images/no_data.png',
                                width: MediaQuery.of(context).size.width * 0.8,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                AppLocalizations.of(context)!.noDataFound,
                                style: TextStyles.h3Style.bold.lightColor,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.noLikedSong,
                                style: TextStyles.title.semiBold.lightColor,
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget songImage() {
    return allSongs.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: allSongs.first.image,
            fit: BoxFit.cover,
            height: 250,
            width: MediaQuery.of(context).size.width,
          )
        : Container(
            color: Colors.transparent,
            height: 200,
            width: 400,
          );
  }

// yicowi4315@glumark.com
// yicowi4315@glumark.coM
  Widget basicInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.likedSongs,
                style: TextStyles.titleMedium.bold.lightColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${allSongs.length} ${AppLocalizations.of(context)?.songs}',
                style: TextStyles.bodySm.bold.lightColor,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        buttonsView()
      ],
    );
  }

  Widget songsView() {
    return SizedBox(
      height: allSongs.length * 80,
      child: ListView.separated(
          padding: const EdgeInsets.only(top: 20),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allSongs.length,
          itemBuilder: (BuildContext ctx, int index) {
            return
                // SongTile(
                //   song: allSongs[index],
                // ).ripple(() {
                //   getIt<PlayerManager>().updatePlaylist(
                //       songs: allSongs, currentSong: allSongs[index]);
                // });
                Container(
              decoration: BoxDecoration(
                color: AppTheme.singleton.primaryBackgroundColor.lighten(),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CachedNetworkImage(
                                    imageUrl: allSongs[index].image,
                                    fit: BoxFit.cover,
                                    height: 60,
                                    width: 60)
                                .leftRounded(10),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allSongs[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.title.lightColor,
                                  ),
                                  Text(
                                    allSongs[index].artistsName.join(','),
                                    style: TextStyles.bodyExtraSm.subTitleColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ThemeIconWidget(
                        ThemeIcon.moreVertical,
                        color: AppTheme.singleton.lightColor,
                        size: 25,
                      ).ripple(() {
                        //actionSelectionHandler();
                        showActionSheet(allSongs[index]);
                      })
                    ],
                  ).rP4,
                ],
              ),
            ).round(12);
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(
              height: 10,
            );
          }),
    );
  }

  Widget buttonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              color: const Color.fromRGBO(135, 154, 210, 1),
              child: Row(
                children: [
                  ThemeIconWidget(
                    ThemeIcon.play,
                    size: 40,
                    color: AppTheme.singleton.lightColor,
                  ),
                ],
              ).p8,
            ).round(25).ripple(() {
              getIt<PlayerManager>()
                  .updatePlaylist(songs: allSongs, currentSong: null);
            }),
          ],
        ),
      ],
    );
  }

  getAllSongs() async {
    if (UserProfileManager().user != null) {
      var tempExpiryDate = UserProfileManager().user?.expiryDate.toString();
      print(tempExpiryDate);
      if (tempExpiryDate != null) {
        // DateTime expiryDate = DateFormat("dd-MM-yyyy").parse(tempExpiryDate);
        // var isExpired = expiryDate.isAfter(DateTime.now());
        // if (!isExpired) {
        songsList = List.from(UserProfileManager().user!.likedSongs);
        a = await getIt<FirebaseManager>().getMultipleSongsByIds(songsList);
        // print(a);
        setState(() {
          allSongs = a;
        });
        // }
        // print(allSongs);
      }
    }
    setState(() {
      isLoading = false;
    });
    // print(allSongs.length);
  }

  showActionSheet(SongModel song) {
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    getIt<FirebaseManager>().checkIfLikedSong(song.id).then((status) {
      song.isLiked = status;
      EasyLoading.dismiss();
      List<SongAction> allActions =
          SongActionsManager.actionsForLikedSong(song, context);

      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            for (SongAction action in allActions)
              Container(
                color: AppTheme.singleton.primaryBackgroundColor.lighten(),
                child: CupertinoActionSheetAction(
                  child: Text(
                    action.title,
                    style: TextStyles.body.subTitleColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    performAction(action, song);
                  },
                ),
              ),
            Container(
              color: AppTheme.singleton.primaryBackgroundColor.lighten(),
              child: CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyles.body.subTitleColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  performAction(SongAction action, SongModel song) async {
    switch (action.actionType) {
      case SongActionType.addToPlaylist:
        if (UserProfileManager().user == null) {
          context.go('/login');
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddToPlaylist(
                  song: song,
                  remove: false,
                  createNewTapHandler: () {
                    showCreatePlaylist(song);
                  },
                  playlistId: '',
                );
              });
        }
        return;
      case SongActionType.addToQueue:
        getIt<PlayerManager>().add(song);
        AppUtil.showToast(
            message: AppLocalizations.of(context)!.addedToQueue,
            context: context);
        return;
      case SongActionType.play:
        getIt<PlayerManager>().addPlaylist([song]);
        getIt<PlayerManager>().play();
        return;
      case SongActionType.reportAbuse:
        if (UserProfileManager().user == null) {
          context.go('/login');
        } else {
          getIt<FirebaseManager>()
              .reportAbuse(song.id, song.name, DataType.songs);
        }
        return;
      case SongActionType.download:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const DownloadSongPopup();
            });
        return;
      case SongActionType.viewSongDetail:
        context.push('/song_detail/${song.id}');
        return;

      case SongActionType.likeSong:
        if (UserProfileManager().user == null) {
          context.go('/login');
        } else {
          if (song.isLiked == false) {
            getIt<FirebaseManager>().likeSong(song.id);
            song.isLiked = true;
            // AppUtil.showToast(message: "Added to Liked Song", context: context);
            AppUtil.showToast(
                message: AppLocalizations.of(context)!.addedLikeSong,
                context: context);
            await initApp();
          } else {
            getIt<FirebaseManager>().unlikeSong(song.id);
            song.isLiked = false;
            // AppUtil.showToast(
            //     message: "Removed from Liked Song", context: context);
            AppUtil.showToast(
                message: AppLocalizations.of(context)!.removeLikeSong,
                context: context);
            await initApp();
          }
        }

        return;
      case SongActionType.playNext:
        return;
      case SongActionType.removeFromPlaylist:
        if (UserProfileManager().user == null) {
          context.go('/login');
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddToPlaylist(
                    remove: true,
                    song: song,
                    createNewTapHandler: () {
                      removeSongFromPlaylist(song);
                    },
                    playlistId: '');
              });
        }
        return;
      case SongActionType.sleepTimer:
        break;
    }
  }

  showCreatePlaylist(SongModel song) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SavePlaylist(
            playlistSaved: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddToPlaylist(
                        song: song,
                        remove: false,
                        createNewTapHandler: () {
                          showCreatePlaylist(song);
                        },
                        playlistId: '');
                  });
            },
          );
        });
  }

  removeSongFromPlaylist(SongModel song) {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SavePlaylist(
            playlistSaved: () {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddToPlaylist(
                        song: song,
                        remove: true,
                        createNewTapHandler: () {
                          showCreatePlaylist(song);
                        },
                        playlistId: '');
                  });
            },
          );
        });
  }
}
