import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AlbumDetail extends StatefulWidget {
  final String albumId;
  final int index;

  const AlbumDetail({Key? key, required this.albumId, required this.index})
      : super(key: key);

  @override
  AlbumDetailState createState() => AlbumDetailState();
}

class AlbumDetailState extends State<AlbumDetail> {
  AlbumModel? album;
  late String albumId;

  List<SongModel> allSongs = [];
  List<ArtistModel> artists = [];
  List<AlbumModel> allAlbums = [];

  int selectedSegment = 0;

  @override
  void initState() {
    albumId = widget.albumId;
    getAlbumDetail();
    super.initState();
  }

  getAlbumDetail() {
    getIt<FirebaseManager>().getAlbum(albumId).then((result) {
      album = result;

      getAllSongs();
      setState(() {});
    });
  }

  getAllSongs() {
    List<String> songsList = List.from(album!.songsId);
    getIt<FirebaseManager>().getMultipleSongsByIds(songsList).then((result) {
      allSongs = result;
      album?.songs = allSongs;
      getAllArtists();
      setState(() {});
    });
  }

  getAllArtists() {
    List<String> artistsList =
        List.from(allSongs.map((e) => e.artistsId.first));

    getIt<FirebaseManager>()
        .getMultipleArtistsByIds(artistsId: artistsList)
        .then((result) {
      artists = result;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return album == null
        ? Container()
        : Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  //color: AppTheme.singleton.primaryBackgroundColor,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg-m-2.png'),
                      // opacity: 0.7,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          albumImage(),
                          const SizedBox(
                            height: 20,
                          ),
                          albumBasicInfo().hP16,
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buttonsView().hP16,
                      const SizedBox(
                        height: 50,
                      ),
                      HorizontalSegmentBar(
                        segments: [
                          AppLocalizations.of(context)!.songs,
                          //AppLocalizations.of(context)!.artists
                        ],
                        onSegmentChange: (index) {
                          setState(() {
                            selectedSegment = index;
                          });
                        },
                      ),
                      // selectedSegment == 0
                      //     ? songsView().p16
                      //     : artistsView().p16,
                      songsView().p16,
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
              BackNavBar(backTapHandler: () {
                context.pop();
              })
            ],
          );
  }

  Widget albumImage() {
    return CachedNetworkImage(
      imageUrl: album!.image,
      fit: BoxFit.cover,
      height: 400,
      width: double.infinity,
    );
  }

  Widget albumBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          album!.name,
          //style: TextStyles.titleMedium.bold.lightColor,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          album!.genreName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   children: [
        //     Text(
        //       album!.formattedTotalStreams(),
        //       style: TextStyle (
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 25,
        //       ),
        //     ),
        //     Text(
        //       ' ${AppLocalizations.of(context)?.streams}',
        //       style: TextStyle (
        //         color: Colors.black,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //       ),
        //     ).bP16,
        //   ],
        // ),
        const SizedBox(height: 20),
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
              color: AppTheme.singleton.redColor,
              child: Row(
                children: [
                  ThemeIconWidget(
                    ThemeIcon.play,
                    color: AppTheme.singleton.lightColor,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Play Now',
                    style: TextStyles.bodySm.lightColor,
                  )
                ],
              ).p8,
            ).round(25).ripple(() {
              getIt<PlayerManager>().addPlaylist(album!.songs);
              getIt<PlayerManager>().play();

              getIt<FirebaseManager>().increaseAlbumListener(album!);
            }),
            const SizedBox(
              width: 10,
            ),
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

  Widget popupMenuItems() {
    return PopupMenuButton(
        color: AppTheme.singleton.primaryBackgroundColor.lighten(),
        child: ThemeIconWidget(ThemeIcon.moreVertical,
                color: AppTheme.singleton.lightColor)
            .p8
            .borderWithRadius(
                value: 1, radius: 25, color: AppTheme.singleton.lightColor),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                // value: Menu.itemOne,
                child: Text(
                  getIt<PlayerManager>().isPlaying() == true
                      ? AppLocalizations.of(context)!.addToQueue
                      : AppLocalizations.of(context)!.play,
                  style: TextStyles.body.lightColor,
                ),
                onTap: () {
                  getIt<PlayerManager>().isPlaying() == true
                      ? getIt<PlayerManager>().addPlaylist(album!.songs)
                      : getIt<PlayerManager>().updatePlaylist(
                          songs: album!.songs, currentSong: null);

                  getIt<FirebaseManager>().increaseAlbumListener(album!);
                },
              ),
              PopupMenuItem(
                // value: Menu.itemThree,
                child: Text(
                  AppLocalizations.of(context)!.savePlaylist,
                  style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // context.pop();
                  if (UserProfileManager().user == null) {
                    Timer(const Duration(seconds: 1), () {
                      context.go('/login');
                    });
                  } else {
                    getIt<FirebaseManager>().saveAlbumToPlaylist(album!);
                  }
                },
              ),
            ]);
  }

  // Widget artistsView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 20),
  //       SizedBox(
  //         height: 170,
  //         child: ListView.separated(
  //             padding: EdgeInsets.zero,
  //             scrollDirection: Axis.horizontal,
  //             itemCount: artists.length,
  //             itemBuilder: (BuildContext ctx, int index) {
  //               return artistView(artists[index]).ripple(() {
  //                 context.go('/artist_detail/${artists[index].id}',
  //                     extra: widget.index);
  //               });
  //             },
  //             separatorBuilder: (BuildContext ctx, int index) {
  //               return const SizedBox(
  //                 width: 20,
  //               );
  //             }),
  //       )
  //     ],
  //   );
  // }

  Widget songsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: (allSongs.length * 70),
          child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allSongs.length,
              itemBuilder: (BuildContext ctx, int index) {
                return SongTile(
                        song: allSongs[index],
                        fromPlaylistPage: false,
                        playlistId: "")
                    .ripple(() {
                  getIt<PlayerManager>().emptyPlaylistAndPlayPlaylist(
                      songs: allSongs, currentSong: allSongs[index]);
                });
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  height: 20,
                );
              }),
        ),
      ],
    );
  }
}
