import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SmallPlayerController extends StatefulWidget {
  final WeSlideController weSlideController;
  const SmallPlayerController({Key? key, required this.weSlideController})
      : super(key: key);

  @override
  SmallPlayerControllerState createState() => SmallPlayerControllerState();
  //SongDetailState createStates() => SongDetailState();
}

// class SongDetailState extends State<SongDetail> {

// }

class SmallPlayerControllerState extends State<SmallPlayerController> {
  final pageManager = getIt<PlayerManager>();
  double coverImageSize = 40;
  bool fullScreen = false;

  @override
  Widget build(BuildContext context) {
    final WeSlideController smallPlayer = widget.weSlideController;

    return ValueListenableBuilder<bool>(
        valueListenable: pageManager.playStateNotifier,
        builder: (_, value, __) {
          return value == false
              ? Container()
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  onEnd: () {},
                  color: AppTheme.singleton.primaryBackgroundColor.lighten(),
                  height: 80,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ValueListenableBuilder<PlayingMediaModel?>(
                                  valueListenable:
                                      pageManager.currentSongChangeNotifier,
                                  builder: (_, modal, __) {
                                    return modal != null
                                        ? CachedNetworkImage(
                                            imageUrl: modal.image,
                                            height: 45,
                                            width: 45,
                                            fit: BoxFit.cover,
                                          ).round(5)
                                        : Container();
                                  },
                                ).vP16,
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            ValueListenableBuilder<PlayingMediaModel?>(
                              valueListenable:
                                  pageManager.currentSongChangeNotifier,
                              builder: (_, modal, __) {
                                return SizedBox(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          modal?.name ?? '',
                                          style: TextStyles.body.lightColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Text(
                                          modal?.artistName ?? '',
                                          style:
                                              TextStyles.bodySm.subTitleColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ));
                              },
                            ).vP8,
                            const Spacer(),
                            const PlayButton(size: 40),
                            // .setPadding(left: 10, right: 10),
                          ],
                        ).hp(16),
                        onTap: () {
                          setState(() {
                            smallPlayer.show();
                          });
                        },
                      ),

                      // fullScreen == true ? const Spacer() : Container(),
                      const Spacer(),
                      const AudioProgressBarForSmallPlayer(),
                    ],
                  ).p(0),
                ).topRounded(20);
        });
  }

  showActionSheet(SongModel song) async {
    List<SongAction> allActions =
        SongActionsManager.actionsForSong(song, context);

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
  }

  performAction(SongAction action, SongModel song) {
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
                    playlistId: '');
              });
        }
        return;
      case SongActionType.addToQueue:
        getIt<PlayerManager>().add(song);
        return;
      case SongActionType.play:
        getIt<PlayerManager>().addPlaylist([song]);
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
            //print("Show toast");
            AppUtil.showToast(message: "Added to Liked Song", context: context);
            song.isLiked = true;
          } else {
            getIt<FirebaseManager>().unlikeSong(song.id);
            //print("Show toast");
            AppUtil.showToast(
                message: "Removed from Liked Song", context: context);
            song.isLiked = false;
          }
        }
        setState(() {});
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
                        remove: false,
                        song: song,
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

class FullScreenPlayerController extends StatefulWidget {
  //final String songId;
  const FullScreenPlayerController({
    Key? key,
  }) : super(key: key);

  @override
  FullScreenPlayerControllerState createState() =>
      FullScreenPlayerControllerState();
}

class FullScreenPlayerControllerState
    extends State<FullScreenPlayerController> {
  // SongModel? song;
  // late String songId;
  final pageManager = getIt<PlayerManager>();
  double coverImageSize = 40;
  var timer = Timer(const Duration(minutes: 0), (() {}));
  var interval = Timer.periodic(const Duration(seconds: 1), (timer) {});
  var intervalLeft = 0;

  @override
// void initState() {
//     songId = widget.songId;
//     print('This is Song when started in controller page' + songId);
//     getSongDetail();
//     super.initState();
//   }

  // checkIfLikedSong() {
  //   getIt<FirebaseManager>().checkIfLikedSong(widget.songId).then((result) {
  //     song!.isLiked = result;
  //     setState(() {});
  //   });
  // }

  // getSongDetail() {
  //   getIt<FirebaseManager>().getSong(widget.songId).then((result) {
  //     song = result;
  //     checkIfLikedSong();
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppTheme.singleton.fontColor,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ThemeIconWidget(
              //   ThemeIcon.close,
              //   color: AppTheme.singleton.lightColor,
              //   size: 25,
              // ),
              const Spacer(),
              UserProfileManager().auth.currentUser != null &&
                      UserProfileManager().user!.active_subscription.isNotEmpty
                  ? ValueListenableBuilder<PlayingMediaModel?>(
                      valueListenable: pageManager.currentSongChangeNotifier,
                      builder: (_, modal, __) {
                        return ThemeIconWidget(
                          ThemeIcon.moreVertical,
                          color: AppTheme.singleton.lightColor,
                          size: 25,
                        ).ripple(() async {
                          await getIt<FirebaseManager>()
                              .getSong(modal!.id)
                              .then((song) {
                            showActionSheet(song!);
                          });
                        });
                      })
                  : Container()
            ],
          ).setPadding(top: Platform.isAndroid ? 25 : 40).ripple(() {}),
          const Spacer(),
          ValueListenableBuilder<PlayingMediaModel?>(
            valueListenable: pageManager.currentSongChangeNotifier,
            builder: (_, modal, __) {
              return Center(
                child: CachedNetworkImage(
                  // color: Colors.transparent,
                  imageUrl: modal!.image,
                  fit: BoxFit.cover,
                  // width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                ).round(5),
              );
            },
          ).vP16,
          const Spacer(),
          ValueListenableBuilder<PlayingMediaModel?>(
            valueListenable: pageManager.currentSongChangeNotifier,
            builder: (_, modal, __) {
              var currentSongLiked =
                  UserProfileManager().auth.currentUser != null
                      ? UserProfileManager().user!.likedSongs
                      : [];
              //print(currentSongLiked.length);
              var currentSongId = modal!.id;
              //print(currentSongId);
              var songStatus = currentSongLiked
                  .filter((element) => element == currentSongId)
                  .toList();

              // var isFreeSong =
              //print(songStatus.isNotEmpty.toString() + '123455');
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(modal.name,
                                      style: TextStyles.h3Style.fontColor),
                                  Text(modal.artistName,
                                      style: TextStyles.title.semiBold.merge(
                                          TextStyle(
                                              color: const Color(0XFF3c516e)
                                                  .lighten(0.3)))),

                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Spacer(),
                                  // const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      UserProfileManager().auth.currentUser != null &&
                              UserProfileManager()
                                  .user!
                                  .active_subscription
                                  .isNotEmpty
                          ? ThemeIconWidget(
                                  size: 25,
                                  songStatus.isNotEmpty
                                      ? ThemeIcon.favFilled
                                      : ThemeIcon.fav,
                                  color: songStatus.isNotEmpty
                                      ? AppTheme.singleton.redColor
                                      : AppTheme.singleton.lightColor)
                              .p8
                              .ripple(() {
                              //print(modal?.id);

                              if (songStatus.isNotEmpty) {
                                getIt<FirebaseManager>()
                                    .unlikeSong(modal.id)
                                    .then((value) => {
                                          //print( 'unlike Song'),
                                          setState(() {
                                            songStatus = [];
                                          }),

                                          AppUtil.showToast(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .removeLikeSong,
                                              context: context),
                                        });
                              } else {
                                getIt<FirebaseManager>()
                                    .likeSong(modal.id)
                                    .then((value) => {
                                          setState(() {
                                            songStatus = [modal.id];
                                          }),
                                          AppUtil.showToast(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .addLikeSong,
                                              context: context),
                                        });
                              }
                              // setState(() {

                              // });
                            })
                          : Container()
                    ],
                  ),
                ],
              );
            },
          ).vP8,
          const AudioProgressBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ShuffleButton(),
              // SizedBox(width: fullScreen == true ? 10 : 0),
              // const SizedBox(
              //   width: 25,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: pageManager.timerActivated
                          ? Colors.white
                          : const Color.fromRGBO(135, 154, 210, 1),
                      border: Border.all(
                        color: pageManager.timerActivated
                            ? const Color.fromRGBO(135, 154, 210, 1)
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                    ),
                    child: ThemeIconWidget(
                      ThemeIcon.clock,
                      color: pageManager.timerActivated
                          ? const Color.fromRGBO(135, 154, 210, 1)
                          : AppTheme.singleton.lightColor,
                      size: 25,
                    ).ripple(() {
                      if (pageManager.timerActivated) {
                        promptCancelTimer();
                      } else {
                        selectTimer();
                      }
                    }).setPadding(top: 5, left: 5, right: 5, bottom: 5),
                  ).setPadding(right: 15, top: intervalLeft > 0 ? 15 : 0),
                  intervalLeft > 0
                      ? Text(AppLocalizations.of(context)!
                              .timerleftDesc(intervalLeft))
                          .setPadding(right: 15, top: 2)
                      : Container()
                ],
              ),
              const PreviousSongButton(),
              // SizedBox(width: fullScreen == true ? 15 : 0),
              const PlayButton(size: 55).setPadding(left: 15, right: 15),
              // SizedBox(width: fullScreen == true ? 15 : 0),
              const NextSongButton().setPadding(right: 15),
              // SizedBox(width: fullScreen == true ? 10 : 0),
              Container(
                  decoration: BoxDecoration(
                    // color: Colors.transparent,
                    color: const Color.fromRGBO(135, 154, 210, 1),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                  ),
                  child: const RepeatButton()),
            ],
          ),
          // fullScreen == true ? const Spacer() : Container(),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ThemeIconWidget(
                ThemeIcon.playlists,
                color: AppTheme.singleton.lightColor,
                size: 25,
              ).ripple(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const PlayerPlaylist();
                    },
                    fullscreenDialog: true));
              })
            ],
          ),
        ],
      ).p(16),
    );
  }

  showActionSheet(SongModel song) async {
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    getIt<FirebaseManager>().checkIfLikedSong(song.id).then((status) {
      song.isLiked = status;
      EasyLoading.dismiss();
      List<SongAction> allActions =
          SongActionsManager.actionsForSong(song, context);

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

  performAction(SongAction action, SongModel song) {
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
                    playlistId: '');
              });
        }
        return;
      case SongActionType.addToQueue:
        getIt<PlayerManager>().add(song);
        return;
      case SongActionType.play:
        getIt<PlayerManager>().addPlaylist([song]);
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
        //print('This is the Song ID' + song.id);
        if (UserProfileManager().user == null) {
          context.go('/login');
        } else {
          if (song.isLiked == false) {
            getIt<FirebaseManager>().likeSong(song.id);

            AppUtil.showToast(
                message: AppLocalizations.of(context)!.addLikeSong,
                context: context);

            song.isLiked = true;
          } else {
            getIt<FirebaseManager>().unlikeSong(song.id);

            AppUtil.showToast(
                message: AppLocalizations.of(context)!.removeLikeSong,
                context: context);
            song.isLiked = false;

            //song.isLiked = true;
          }
        }
        setState(() {});
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

  selectTimer() {
    var timerList = [
      {'label': AppLocalizations.of(context)!.mins5, 'value': 5},
      {'label': AppLocalizations.of(context)!.mins10, 'value': 10},
      {'label': AppLocalizations.of(context)!.mins15, 'value': 15},
      {'label': AppLocalizations.of(context)!.mins30, 'value': 30},
      {'label': AppLocalizations.of(context)!.mins45, 'value': 45},
      {'label': AppLocalizations.of(context)!.mins60, 'value': 60}
    ];

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          ...timerList.map((e) => Container(
                color: AppTheme.singleton.primaryBackgroundColor.lighten(),
                child: CupertinoActionSheetAction(
                  child: Text(
                    e['label']!.toString(),
                    style: TextStyles.body.subTitleColor,
                  ),
                  onPressed: () {
                    print(e['value']);
                    toggleTimer(int.parse(e['value'].toString()), e['label']);
                    Navigator.pop(context);
                  },
                ),
              )),
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

    return;
  }

  promptCancelTimer() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          Container(
            color: AppTheme.singleton.primaryBackgroundColor.lighten(),
            child: CupertinoActionSheetAction(
              child: Text(
                AppLocalizations.of(context)!.setNewTimer,
                style: TextStyles.body.subTitleColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                selectTimer();
              },
            ),
          ),
          Container(
            color: AppTheme.singleton.primaryBackgroundColor.lighten(),
            child: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                cancelTimer();
                setState(() {});
              },
              child: Text(
                AppLocalizations.of(context)!.cancelTimer,
                style: TextStyles.body.subTitleColor,
              ),
            ),
          ),
        ],
      ),
    );
    return;
  }

  toggleTimer(duration, label) {
    setState(() {
      pageManager.timerActivated = true;
    });
    GFToast.showToast(AppLocalizations.of(context)!.sleepTimerSet, context,
        toastPosition: GFToastPosition.TOP,
        textStyle: TextStyles.bodySm.lightColor,
        toastDuration: 3,
        backgroundColor: AppTheme().successColor,
        trailing:
            Icon(Icons.check_circle_outline, color: AppTheme().lightColor));

    var secondsLeft = Duration(minutes: duration).inSeconds;
    interval = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft = secondsLeft - 1;
        intervalLeft = Duration(seconds: secondsLeft).inMinutes + 1;
        print(intervalLeft);
      });
    });

    timer = Timer(
      Duration(minutes: duration),
      () {
        pageManager.pause();
        setState(() {
          pageManager.timerActivated = false;
          intervalLeft = 0;
        });
        interval.cancel();
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.haveAGoodNight),
              content: Text(
                AppLocalizations.of(context)!.timerUp,
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        print('paused');
      },
    );
  }

  cancelTimer() {
    interval.cancel();
    timer.cancel();
    setState(() {
      pageManager.timerActivated = false;
      intervalLeft = 0;
    });
    print('cancelled');
    GFToast.showToast(AppLocalizations.of(context)!.timerCancelled, context,
        toastPosition: GFToastPosition.TOP,
        textStyle: TextStyles.bodySm.lightColor,
        toastDuration: 3,
        backgroundColor: AppTheme().successColor,
        trailing:
            Icon(Icons.check_circle_outline, color: AppTheme().lightColor));
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

class AudioProgressBarForSmallPlayer extends StatelessWidget {
  const AudioProgressBarForSmallPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: AppTheme.singleton.lightColor,
            height: 3,
            width: value.current > const Duration(minutes: 0)
                ? MediaQuery.of(context).size.width *
                    (value.current / value.total)
                : 0,
          ),
        );
      },
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}
