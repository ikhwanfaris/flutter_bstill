import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SongTile extends StatefulWidget {
  final SongModel song;
  final bool fromPlaylistPage;
  final String playlistId;
  const SongTile({
    Key? key,
    required this.song,
    required this.fromPlaylistPage,
    required this.playlistId,
  }) : super(key: key);

  @override
  SongTileState createState() => SongTileState();
}

class SongTileState extends State<SongTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            imageUrl: widget.song.image,
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
                            widget.song.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.title.lightColor,
                          ),
                          Text(
                            widget.song.artistsName.join(','),
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
                showActionSheet(
                    widget.song, widget.fromPlaylistPage, widget.playlistId);
              })
            ],
          ).rP4,
        ],
      ),
    ).round(12);
  }

  showActionSheet(SongModel song, bool fromPlaylistPage, String playlistId) {
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    getIt<FirebaseManager>().checkIfLikedSong(song.id).then((status) {
      song.isLiked = status;
      EasyLoading.dismiss();
      List<SongAction> allActions = [];
      if (fromPlaylistPage == false) {
        allActions = SongActionsManager.actionsForSong(song, context);
      } else {
        allActions =
            SongActionsManager.actionsForSongFromPlylist(song, context);
      }

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
                message: AppLocalizations.of(context)!.addLikeSong,
                context: context);
          } else {
            getIt<FirebaseManager>().unlikeSong(song.id);
            song.isLiked = false;
            // AppUtil.showToast(
            //     message: "Removed from Liked Song", context: context);
            AppUtil.showToast(
                message: AppLocalizations.of(context)!.removeLikeSong,
                context: context);
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
                    // removeSongFromPlaylist(song, widget.playlistId);
                  },
                  playlistId: widget.playlistId,
                );
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
                      playlistId: '',
                    );
                  });
            },
          );
        });
  }

  removeSongFromPlaylist(SongModel song, String playlistId) {
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
                        playlistId: playlistId,
                        createNewTapHandler: () {
                          showCreatePlaylist(song);
                        });
                  });
            },
          );
        });
  }
}

class ArtistSongTile extends StatelessWidget {
  final SongModel song;
  final bool? canDelete;
  final bool? isSelected;
  final VoidCallback? deleteCallback;

  const ArtistSongTile(
      {Key? key,
      required this.song,
      this.canDelete,
      this.isSelected,
      this.deleteCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: song.image,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ).round(10),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.name,
              style: TextStyles.titleM.lightColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  color: AppTheme.singleton.themeColor,
                  child: Text(
                    song.genreName.toUpperCase(),
                    style: TextStyles.bodySm.lightColor,
                  ).p4,
                ).round(5),
                const SizedBox(
                  width: 10,
                ),
                // Text(
                //   song.date,
                //   style: TextStyles.bodySm.subTitleColor.semiBold,
                // ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  color: AppTheme.singleton.themeColor.withOpacity(0.5),
                  child: const ThemeIconWidget(
                    ThemeIcon.edit,
                    size: 20,
                  ).ripple(() {
                    deleteCallback!();
                  }).p8,
                ).round(10),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: AppTheme.singleton.themeColor.withOpacity(0.5),
                  child: const ThemeIconWidget(
                    ThemeIcon.delete,
                    size: 20,
                  ).ripple(() {
                    deleteCallback!();
                  }).p8,
                ).round(10),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class SongTileWithArtistInfo extends StatelessWidget {
  final SongModel song;
  final bool? canDelete;
  final bool? isSelected;
  final VoidCallback? editCallback;
  final VoidCallback? deleteCallback;

  const SongTileWithArtistInfo(
      {Key? key,
      required this.song,
      this.canDelete,
      this.isSelected,
      this.editCallback,
      this.deleteCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: song.image,
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        ).round(10),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.name,
              style: TextStyles.titleM.lightColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: song.artist?.image ??
                      'https://images.unsplash.com/photo-1652509140600-5c72b9993fe7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0MXx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ).circular,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  song.artist?.name ?? 'Artist name',
                  style: TextStyles.bodySm.lightColor.semiBold,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  color: AppTheme.singleton.themeColor,
                  child: Text(
                    song.genreName.toUpperCase(),
                    style: TextStyles.bodySm.lightColor,
                  ).p4,
                ).round(5),
                const SizedBox(
                  width: 10,
                ),
                // Text(
                //   'added on ${song.date}',
                //   style: TextStyles.bodySm.subTitleColor.semiBold,
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                Container(
                  color: AppTheme.singleton.themeColor.withOpacity(0.5),
                  child: const ThemeIconWidget(
                    ThemeIcon.edit,
                    size: 20,
                  ).p8,
                ).round(10).ripple(() {
                  editCallback!();
                }),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: AppTheme.singleton.themeColor.withOpacity(0.5),
                  child: const ThemeIconWidget(
                    ThemeIcon.delete,
                    size: 20,
                  ).p8,
                ).round(10).ripple(() {
                  deleteCallback!();
                }),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class MediaTile extends StatefulWidget {
  final PlayingMediaModel song;
  final Function() selectionHandler;

  const MediaTile(
      {Key? key, required this.song, required this.selectionHandler})
      : super(key: key);

  @override
  MediaTileState createState() => MediaTileState();
}

class MediaTileState extends State<MediaTile> {
  late Function() selectionHandler;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    selectionHandler = widget.selectionHandler;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ThemeIconWidget(
                      isSelected == false
                          ? ThemeIcon.unSelectedRadio
                          : ThemeIcon.selectedRadio,
                      color: AppTheme.singleton.lightColor,
                      size: 20,
                    ).ripple(() {
                      setState(() {
                        if (isSelected == false) {
                          isSelected = true;
                        } else {
                          isSelected = false;
                        }
                      });
                      selectionHandler();
                    }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.song.name,
                          style: TextStyles.body.bold.fontColor,
                        ),
                        Text(
                          widget.song.artistName,
                          style: TextStyles.bodySm.semiBold.merge(TextStyle(
                              color: const Color(0XFF3c516e).lighten(0.3))),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ).vP8;
  }
}
