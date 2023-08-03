import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AddToPlaylist extends StatefulWidget {
  final SongModel song;
  final VoidCallback createNewTapHandler;
  final bool remove;
  final String playlistId;
  const AddToPlaylist(
      {Key? key,
      required this.song,
      required this.createNewTapHandler,
      required this.remove,
      required this.playlistId})
      : super(key: key);

  @override
  AddToPlaylistState createState() => AddToPlaylistState();
}

class AddToPlaylistState extends State<AddToPlaylist> {
  List<PlaylistModel> playlists = [];
  PlaylistModel? playlist;
  late VoidCallback createNewTapHandler;
  late SongModel song;
  late bool remove;
  late String playlistId;

  @override
  void initState() {
    song = widget.song;
    createNewTapHandler = widget.createNewTapHandler;
    remove = widget.remove;
    playlistId = widget.playlistId;
    getAllPlaylists();
    getPlaylistDetail();
    super.initState();
  }

  getAllPlaylists() async {
    playlists = await getIt<FirebaseManager>().getMyPlaylists();
    setState(() {
      playlists = playlists;
    });

    return;
  }

  getPlaylistDetail() {
    if (playlistId != "") {
      getIt<FirebaseManager>().getPlaylist(playlistId).then((result) {
        playlist = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: remove == false
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.3,
        color: AppTheme.singleton.primaryBackgroundColor.lighten(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                remove == false
                    ? Text(
                        AppLocalizations.of(context)!.addToPlaylist,
                        style: TextStyles.title.bold.lightColor,
                      )
                    : Container(),
                ThemeIconWidget(
                  ThemeIcon.close,
                  color: AppTheme.singleton.lightColor,
                  size: 20,
                ).ripple(() {
                  Navigator.of(context).pop();
                })
              ],
            ),
            Container(
              height: 0.2,
              width: double.infinity,
              color: AppTheme.singleton.dividerColor,
            ).tP16,
            remove == false
                ? Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        itemCount: playlists.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return InkWell(
                            onTap: () async {
                              playlists = await getIt<FirebaseManager>()
                                  .getMyPlaylists();
                              setState(() {
                                playlists = playlists;
                              });
                              // addToPlaylist(playlists[index]);

                              if (playlists[index].songsId.contains(song.id) ==
                                  false) {
                                addToPlaylist(playlists[index]);
                              } else if (playlists[index]
                                      .songsId
                                      .contains(song.id) ==
                                  true) {
                                AppUtil.showToast(
                                    message: AppLocalizations.of(context)!
                                        .songsExistPlaylist,
                                    context: context);
                              }
                            },
                            child: Row(
                              children: [
                                PlaylistImage(
                                  playlist: playlists[index],
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(playlists[index].name,
                                        style: TextStyles
                                            .body.lightColor.lightBold),
                                    Text('${playlists[index].songsId.length}',
                                        style: TextStyles
                                            .bodySm.subTitleColor.lightBold),
                                  ],
                                ),
                                const Spacer(),
                                remove == false
                                    ? ThemeIconWidget(
                                        playlists[index]
                                                    .songsId
                                                    .contains(song.id) ==
                                                true
                                            ? ThemeIcon.checkMarkWithCircle
                                            : ThemeIcon.addCircle,
                                        color: AppTheme.singleton.lightColor,
                                        size: 25,
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext ctx, int index) {
                          return const SizedBox(height: 20);
                        }),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .removeFromPlaylistQuestion,
                              style: TextStyles.title.bold.lightColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            remove == false
                ? Column(
                    children: [
                      Container(
                        height: 0.2,
                        width: double.infinity,
                        color: AppTheme.singleton.dividerColor,
                      ).bP16,
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 250,
                          child: BorderButtonType1(
                            cornerRadius: 30,
                            text: AppLocalizations.of(context)?.createNew,
                            textStyle: TextStyles.title.bold.lightColor,
                            onPress: () async {
                              // Routemaster.of(context).pop();
                              // NavigationService.instance.goBack();
                              createNewTapHandler();
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      BorderButtonType1(
                        cornerRadius: 30,
                        backgroundColor: CommonColor.red,
                        text: AppLocalizations.of(context)?.remove,
                        textStyle: TextStyles.title.bold.lightColor,
                        onPress: () {
                          // Routemaster.of(context).pop();
                          // NavigationService.instance.goBack();
                          removeFromPlaylist(playlist!);
                          // createNewTapHandler();
                          // Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BorderButtonType1(
                        cornerRadius: 30,
                        text: AppLocalizations.of(context)?.cancel,
                        textStyle: TextStyles.title.bold.lightColor,
                        onPress: () {
                          // Routemaster.of(context).pop();
                          // NavigationService.instance.goBack();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
          ],
        ).p16,
      ).round(20).hP25,
    );
  }

  addToPlaylist(PlaylistModel playlist) async {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      getIt<FirebaseManager>()
          .addSongToPlaylist(songId: song.id, playlistId: playlist.id)
          .then((value) async {
        playlist.songsId.add(song.id);
        setState(() {});
        // AppUtil.showToast(message: "Added to Playlist", context: context);
        AppUtil.showToast(
            message: AppLocalizations.of(context)!.addedToPlaylist,
            context: context);
        await getAllPlaylists();
      });
    }
  }

  removeFromPlaylist(PlaylistModel playlist) async {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      getIt<FirebaseManager>()
          .removeSongFromPlaylist(songId: song.id, playlistId: playlist.id)
          .then((value) async {
        playlist.songsId.remove(song.id);
        setState(() {});
        // AppUtil.showToast(message: "Remove from Playlist", context: context);
        AppUtil.showToast(
            message: AppLocalizations.of(context)!.removeFromPlayList,
            context: context);
        await getAllPlaylists();
        Future.delayed(const Duration(milliseconds: 10)).then((value) {
          context.push('/account');
        });
      });
    }
  }
}
