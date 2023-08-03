import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class ArtistPageCard extends StatefulWidget {
  final SongModel artistSongs;
  final double? width;

  const ArtistPageCard({Key? key, required this.artistSongs, this.width})
      : super(key: key);

  @override
  ArtistTileState createState() => ArtistTileState();
}

class ArtistTileState extends State<ArtistPageCard> {
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
                            imageUrl: widget.artistSongs.image,
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
                            widget.artistSongs.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.title.lightColor,
                          ),
                          Text(
                            widget.artistSongs.artistsName.join(','),
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
                showActionSheet(widget.artistSongs);
              })
            ],
          ).rP4,
        ],
      ),
    ).round(12);
  }

  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Stack(
  //         children: [
  //           AspectRatio(
  //             aspectRatio: 1,
  //             child: CachedNetworkImage(
  //               imageUrl: artistSongs.image,
  //               width: width ?? double.infinity,
  //               fit: BoxFit.cover,
  //             ).round(10),
  //           ),
  //           Positioned(
  //               bottom: 0,
  //               left: 0,
  //               right: 0,
  //               child: Container(
  //                 height: 50,
  //                 color: AppTheme.singleton.grey.darken(0.25),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       artistSongs.name,
  //                       style: TextStyles.title.bold.lightColor,
  //                       textAlign: TextAlign.center,
  //                       maxLines: 1,
  //                     ),
  //                     Text(
  //                       artistSongs.artistsName.first,
  //                       style: TextStyles.body,
  //                       textAlign: TextAlign.center,
  //                       maxLines: 1,
  //                     ),
  //                   ],
  //                 ),
  //               ).bottomRounded(10))
  //         ],
  //       ),
  //       Expanded(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(top: 10.0),
  //               child: Expanded(
  //                 child: SizedBox(
  //                   width: 100,
  //                   height: 100,
  //                   child: Text(
  //                     artistSongs.name,
  //                     style: const TextStyle(
  //                       //overflow: TextOverflow.ellipsis,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 13,
  //                       overflow: TextOverflow.ellipsis,
  //                       color: Colors.red,
  //                     ),
  //                     maxLines: 1,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  showActionSheet(SongModel song) {
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
                    remove: false,
                    song: song,
                    playlistId: '',
                    createNewTapHandler: () {
                      showCreatePlaylist(song);
                    });
              });
        }
        return;
      case SongActionType.addToQueue:
        getIt<PlayerManager>().add(song);
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
          } else {
            getIt<FirebaseManager>().unlikeSong(song.id);
            song.isLiked = false;
          }
        }
        setState(() {});
        return;
      case SongActionType.playNext:
        return;
      case SongActionType.removeFromPlaylist:
        // if (UserProfileManager().user == null) {
        //   context.go('/login');
        // } else {
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return AddToPlaylist(
        //           remove: true,
        //           song: song,
        //           createNewTapHandler: () {
        //             // removeSongFromPlaylist(song, widget.playlistId);
        //           },
        //           playlistId: widget.playlistId,
        //         );
        //       });
        // }
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
                        playlistId: '',
                        createNewTapHandler: () {
                          showCreatePlaylist(song);
                        });
                  });
            },
          );
        });
  }
}
