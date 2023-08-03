import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/components/song/artist_card.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class ArtistDetail extends StatefulWidget {
  final String artistId;
  final int index;

  const ArtistDetail({Key? key, required this.artistId, required this.index})
      : super(key: key);

  @override
  ArtistDetailState createState() => ArtistDetailState();
}

class ArtistDetailState extends State<ArtistDetail> {
  late String artistId;
  List<SongModel> allSongs = [];
  List<ArtistModel> similarArtists = [];
  ArtistModel? artist;

  @override
  void initState() {
    artistId = widget.artistId;
    getArtistDetail();
    getAllSongs();
    super.initState();
  }

  getSimilarArtists() {
    getIt<FirebaseManager>()
        .getAllArtists(genreId: artist!.genreId)
        .then((result) {
      similarArtists = result;
      setState(() {});
    });
  }

  getArtistDetail() {
    getIt<FirebaseManager>().getArtist(artistId).then((result) {
      artist = result;
      checkIfFollowing();
      getSimilarArtists();
      setState(() {});
    });
  }

  checkIfFollowing() {
    getIt<FirebaseManager>().checkIfFollowingArtist(artistId).then((result) {
      artist!.isFollowing = result;
      setState(() {});
    });
  }

  getAllSongs() {
    getIt<FirebaseManager>().getAllSongsByArtist(artistId).then((result) {
      allSongs = result;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return artist == null
        ? Container()
        : Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // DashboardNavigationBar().vP25,
                    artistImage(),
                    const SizedBox(
                      height: 20,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        artistBasicInfo(),
                        const SizedBox(
                          height: 40,
                        ),
                        buttonsView(),
                        const SizedBox(
                          height: 25,
                        ),
                        allSongs.isNotEmpty
                            ? Column(
                                children: [
                                  songsView(),
                                  const SizedBox(height: 50),
                                ],
                              )
                            : Container(),
                        artistsBio(),
                        const SizedBox(height: 50),
                        similarArtistView(),
                        const SizedBox(height: 50),
                      ],
                    ).hP16,
                  ],
                ),
              ),
              BackNavBar(backTapHandler: () {
                context.pop();
              })
            ],
          );
  }

  Widget artistImage() {
    return CachedNetworkImage(
      imageUrl: artist!.image,
      fit: BoxFit.cover,
      height: 400,
      width: double.infinity,
    );
  }

  Widget artistBasicInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artist!.name,
              style: TextStyles.titleMedium.bold.lightColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  '${artist!.formattedTotalFollowers()} ${AppLocalizations.of(context)?.followers}',
                  style: TextStyles.bodySm.semiBold.subTitleColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '•',
                  style: TextStyles.title.subTitleColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${artist!.formattedTotalListeners()} ${AppLocalizations.of(context)?.listeners}',
                  style: TextStyles.bodySm.semiBold.subTitleColor,
                ),
              ],
            ),
            // const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget similarArtistView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.similarArtists,
          style: TextStyles.title.bold.lightColor,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 165,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: similarArtists.length,
              itemBuilder: (BuildContext ctx, int index) {
                return artistViewForDesktop(similarArtists[index]).ripple(() {
                  context.push('/artist_detail/${similarArtists[index].id}',
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

  Widget buttonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                    color: artist!.isFollowing
                        ? AppTheme.singleton.yellow.darken()
                        : Colors.transparent,
                    child: Text(
                      artist!.isFollowing
                          ? AppLocalizations.of(context)!.unFollow
                          : AppLocalizations.of(context)!.follow,
                      style: artist!.isFollowing
                          ? TextStyles.bodySm.lightColor.bold
                          : TextStyles.bodySm.lightColor,
                    ).setPadding(top: 8, bottom: 8, left: 16, right: 16))
                .round(20)
                .borderWithRadius(value: 1, radius: 20)
                .ripple(() {
              if (artist!.isFollowing == true) {
                unFollowArtist();
              } else {
                followArtist();
              }
              setState(() {});
            }),
          ],
        ),
      ],
    );
  }

  Widget artistsBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)?.about} ${artist!.name}',
          style: TextStyles.title.bold.lightColor,
        ),
        const SizedBox(height: 20),
        Text(
          artist!.bio,
          style: TextStyles.bodySm.semiBold.subTitleColor,
        ),
      ],
    );
  }

  Widget artistViewForDesktop(ArtistModel artist) {
    return Column(
      children: [
        CachedNetworkImage(
                imageUrl: artist.image,
                fit: BoxFit.cover,
                height: 120,
                width: 120)
            .circular,
        const SizedBox(
          height: 20,
        ),
        Text(
          artist.name,
          style: TextStyles.body.lightColor,
        )
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
            return ArtistPageCard(
              artistSongs: allSongs[index],
            ).ripple(() {
              getIt<PlayerManager>().updatePlaylist(
                  songs: allSongs, currentSong: allSongs[index]);
            });
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(
              height: 10,
            );
          }),
    );
  }

  // Widget songsView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         '${artist!.name} ${AppLocalizations.of(context)?.songs}',
  //         style: TextStyles.h3Style.lightColor,
  //       ),
  //       const SizedBox(height: 20),
  //       GridView.builder(
  //         physics: const NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         padding: EdgeInsets.zero,
  //         itemCount: allSongs.length,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             childAspectRatio: 1,
  //             crossAxisSpacing: 20,
  //             mainAxisSpacing: 20,
  //             crossAxisCount: 2),
  //         itemBuilder: (BuildContext context, int index) {
  //           return PlayIconHoveringWidget(
  //             child: ArtistPageCard(artistSongs: allSongs[index]),
  //             tapHandler: () {
  //               getIt<PlayerManager>().updatePlaylist(
  //                   songs: allSongs, currentSong: allSongs[index]);
  //               // context.push('/song_detail/${allSongs[index].id}');
  //             },
  //           );
  //         },
  //       ).vP25
  //     ],
  //   );
  // }

  followArtist() {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      artist!.isFollowing = true;
      artist!.totalFollowers += 1;
      getIt<FirebaseManager>().followArtist(artistId).then((value) {});
      UserProfileManager().refreshProfile();
    }
  }

  unFollowArtist() {
    if (UserProfileManager().user == null) {
      context.go('/login');
    } else {
      artist!.isFollowing = false;
      artist!.totalFollowers -= 1;
      getIt<FirebaseManager>().unFollowArtist(artistId).then((value) {});
      UserProfileManager().refreshProfile();
    }
  }
}
