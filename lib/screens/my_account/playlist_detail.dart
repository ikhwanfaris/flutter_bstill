import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistDetail extends StatefulWidget {
  final String playlistId;
  final int index;

  const PlaylistDetail(
      {Key? key, required this.playlistId, required this.index})
      : super(key: key);

  @override
  PlaylistDetailState createState() => PlaylistDetailState();
}

class PlaylistDetailState extends State<PlaylistDetail> {
  PlaylistModel? playlist;
  late String playlistId;

  List<SongModel> allSongs = [];
  List<ArtistModel> artists = [];

  int selectedSegment = 0;
  PopupMenuItem? updateNameItem;

  @override
  void initState() {
    playlistId = widget.playlistId;
    getPlaylistDetail();
    super.initState();
  }

  getPlaylistDetail() {
    getIt<FirebaseManager>().getPlaylist(playlistId).then((result) {
      playlist = result;
      checkIfFollowing();
      getPlaylistCreatedUser();

      getAllSongs();
      setState(() {});
    });
  }

  checkIfFollowing() {
    getIt<FirebaseManager>()
        .checkIfFollowingPlaylist(playlistId)
        .then((result) {
      playlist!.isFollowing = result;
      setState(() {});
    });
  }

  getPlaylistCreatedUser() {
    if (playlist!.addedBy != null) {
      getIt<FirebaseManager>().getUser(playlist!.addedBy!).then((result) {
        playlist?.createdBy = result;
        setState(() {});
      });
    }
  }

  getAllSongs() {
    List<String> songsId = List.from(playlist!.songsId);

    getIt<FirebaseManager>().getMultipleSongsByIds(songsId).then((result) {
      allSongs = result;
      playlist!.songs = allSongs;
      getAllArtists();
      setState(() {});
    });
  }

  getAllArtists() {
    List<String> artistsId = List.from(allSongs.map((e) => e.artistsId.first));

    getIt<FirebaseManager>()
        .getMultipleArtistsByIds(artistsId: artistsId)
        .then((result) {
      artists = result;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return playlist == null
        ? Container()
        : Container(
            // height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-m-4.png'),
                // opacity: 0.7,
                fit: BoxFit.cover,
              ),
            ),
            //color: AppTheme.singleton.primaryBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackNavBar(
                    title: playlist!.name,
                    centerTitle: true,
                    backTapHandler: () {
                      GoRouter.of(context).pop();
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PlaylistImage(
                    //   playlist: playlist!,
                    //   height: 250,
                    //   width: double.infinity,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        albumBasicInfo().hP16,
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 10),
                          child: Container(
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
                            getIt<PlayerManager>().updatePlaylist(
                                songs: allSongs, currentSong: null);
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // buttonsView().hP16,
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: songsView(playlistId).p16),
              ],
            ),
          );
  }

  Widget albumBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          playlist!.name,
          style: TextStyles.titleMedium.bold.lightColor,
        ),
        Text(
          '${allSongs.length} ${AppLocalizations.of(context)?.songs}',
          style: TextStyles.body.bold.lightColor,
        ),
      ],
    );
  }

  Widget buttonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              color: AppTheme.singleton.redColor,
              child: Row(
                children: [
                  ThemeIconWidget(
                    ThemeIcon.play,
                    color: AppTheme.singleton.lightColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.playNow,
                    style: TextStyles.bodySm.lightColor,
                  )
                ],
              ).p8.ripple(() {
                // getIt<PlayerManager>()
                //     .updatePlaylist(songs: playlist!.songs, currentSong: null);
                getIt<PlayerManager>().emptyPlaylistAndPlayPlaylist(
                    songs: playlist!.songs, currentSong: null);
                getIt<FirebaseManager>().increasePlaylistListener(playlist!);
              }),
            ).round(25),
            const SizedBox(
              width: 10,
            ),
            Container(
                height: 40,
                color: playlist!.isFollowing
                    ? AppTheme.singleton.yellow.darken()
                    : Colors.transparent,
                child: Center(
                  child: Text(
                    playlist!.isFollowing
                        ? AppLocalizations.of(context)!.unFollow
                        : AppLocalizations.of(context)!.follow,
                    style: playlist!.isFollowing
                        ? TextStyles.bodySm.subTitleColor
                        : TextStyles.bodySm.lightColor,
                  ).hP16,
                )).borderWithRadius(value: 1, radius: 25).ripple(() {
              if (playlist!.isFollowing == true) {
                unFollowPlaylist();
                playlist!.isFollowing = false;
                playlist!.totalFollowers -= 1;
              } else {
                followPlaylist();
                playlist!.isFollowing = true;
                playlist!.totalFollowers += 1;
              }
              setState(() {});
            }),
          ],
        ),
        // const Spacer(),
        Row(
          children: [
            popupMenuItems(),
          ],
        )
      ],
    );
  }

  Widget artistsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 170,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: artists.length,
              itemBuilder: (BuildContext ctx, int index) {
                return artistView(artists[index]).ripple(() {
                  context.push('/artist_detail/${artists[index].id}',
                      extra: widget.index);
                });
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  width: 20,
                );
              }),
        )
      ],
    );
  }

  Widget songsView(String playlistId) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: allSongs.length,
        itemBuilder: (BuildContext ctx, int index) {
          return SongTile(
                  song: allSongs[index],
                  fromPlaylistPage: true,
                  playlistId: playlistId)
              .ripple(() {
            getIt<PlayerManager>()
                .updatePlaylist(songs: allSongs, currentSong: allSongs[index]);
          });
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(
            height: 10,
          );
        });
  }

  Widget popupMenuItems() {
    return PopupMenuButton(
        color: AppTheme.singleton.primaryBackgroundColor.lighten(),
        child: ThemeIconWidget(ThemeIcon.moreVertical,
                color: AppTheme.singleton.lightColor)
            .p8
            .borderWithRadius(
                value: 1, radius: 25, color: AppTheme.singleton.lightColor),
        // Callback that sets the selected popup menu item.
        onSelected: (item) {
          setState(() {
            // _selectedMenu = item.name;
          });
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuEntry> items = [];

          if (playlist!.fromAdmin == false) {
            items.add(PopupMenuItem(
              // value: Menu.itemOne,
              child: Text(
                AppLocalizations.of(context)!.updatePlaylistName,
                style: TextStyles.body.lightColor,
              ),
              onTap: () {
                Timer(const Duration(seconds: 1), () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SavePlaylist(
                          playlist: playlist!,
                          playlistSaved: () {
                            getPlaylistDetail();
                          },
                        );
                      });
                });
              },
            ));
          }

          items.add(PopupMenuItem(
            // value: Menu.itemOne,
            child: Text(
              getIt<PlayerManager>().isPlaying() == true
                  ? AppLocalizations.of(context)!.addToQueue
                  : AppLocalizations.of(context)!.play,
              style: TextStyles.body.lightColor,
            ),
            onTap: () {
              getIt<PlayerManager>().isPlaying() == true
                  ? getIt<PlayerManager>().addPlaylist(playlist!.songs)
                  : getIt<PlayerManager>().updatePlaylist(
                      songs: playlist!.songs, currentSong: null);
            },
          ));

          items.add(PopupMenuItem(
            // value: Menu.itemThree,
            child: Text(AppLocalizations.of(context)!.savePlaylist,
                style: TextStyles.body.lightColor),
            onTap: () {
              if (UserProfileManager().user == null) {
                Timer(const Duration(seconds: 1), () {
                  context.go('/login');
                });
              } else {
                getIt<FirebaseManager>().saveToPlaylist(playlist!);
              }
            },
          ));

          return items;
        });
  }

  followPlaylist() {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      getIt<FirebaseManager>().followPlaylist(playlistId).then((value) {});
      UserProfileManager().refreshProfile();
    }
  }

  unFollowPlaylist() {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      getIt<FirebaseManager>().unFollowPlaylist(playlistId).then((value) {});
      UserProfileManager().refreshProfile();
    }
  }
}
