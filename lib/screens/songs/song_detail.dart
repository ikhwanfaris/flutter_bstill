// import 'package:flutter/material.dart';
// import 'package:music_streaming_mobile/helper/common_import.dart';

// class SongDetail extends StatefulWidget {
//   final String songId;
//   final int index;

//   const SongDetail({Key? key, required this.songId, required this.index})
//       : super(key: key);

//   @override
//   SongDetailState createState() => SongDetailState();
// }

// class SongDetailState extends State<SongDetail> {
//   SongModel? song;
//   late String songId;

//   List<SongModel> similarSongs = [];
//   List<ArtistModel> artists = [];

//   @override
//   void initState() {
//     songId = widget.songId;
//     getSongDetail();
//     super.initState();
//   }

//   checkIfLikedSong() {
//     getIt<FirebaseManager>().checkIfLikedSong(songId).then((result) {
//       song!.isLiked = result;
//       setState(() {});
//     });
//   }

//   getSongDetail() {
//     getIt<FirebaseManager>().getSong(songId).then((result) {
//       song = result;
//       checkIfLikedSong();
//       getAllArtists();
//       getSimilarSongs();
//       setState(() {});
//     });
//   }

//   getSimilarSongs() {
//     getIt<FirebaseManager>().getAllSongsByGenre(song!.genreId).then((result) {
//       similarSongs = result;
//       setState(() {});
//     });
//   }

//   getAllArtists() {
//     getIt<FirebaseManager>()
//         .getMultipleArtistsByIds(artistsId: song!.artistsId)
//         .then((result) {
//       artists = result;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return song == null
//         ? Container()
//         : Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Container(
//                   color: AppTheme.singleton.primaryBackgroundColor,
//                   child: Column(
//                     children: [
//                       // DashboardNavigationBar().vP25,
//                       songImage(),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           songBasicInfo(),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           buttonsView(),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           artistsView(),
//                           const SizedBox(height: 20),
//                           similarSongs.isNotEmpty
//                               ? songsView().bP25
//                               : Container(),
//                           aboutSong(),
//                         ],
//                       ).hP16,

//                       const SizedBox(
//                         height: 100,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               BackNavBar(backTapHandler: () {
//                 GoRouter.of(context).pop();
//               })
//             ],
//           );
//   }

//   Widget artistsView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocalizations.of(context)!.artists,
//           style: TextStyles.title.bold.lightColor,
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           height: 125,
//           child: ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               itemCount: artists.length,
//               itemBuilder: (BuildContext ctx, int index) {
//                 return artistView(artists[index]).ripple(() {
//                   context.push('/artist_detail/${artists[index].id}',
//                       extra: widget.index);
//                 });
//               },
//               separatorBuilder: (BuildContext ctx, int index) {
//                 return const SizedBox(
//                   width: 10,
//                 );
//               }),
//         ),
//         const SizedBox(
//           height: 50,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             song?.lyricist != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.lyricist,
//                         style: TextStyles.title.semiBold.lightColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         song!.lyricist!,
//                         style: TextStyles.body.subTitleColor,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   )
//                 : Container(),
//             song?.director != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.director,
//                         style: TextStyles.title.semiBold.lightColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         song!.director!,
//                         style: TextStyles.body.subTitleColor,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   )
//                 : Container(),
//             song?.composer != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.composer,
//                         style: TextStyles.title.semiBold.lightColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         song!.composer!,
//                         style: TextStyles.body.subTitleColor,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   )
//                 : Container(),
//             song?.music != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)!.music,
//                         style: TextStyles.title.semiBold.lightColor,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         song!.music!,
//                         style: TextStyles.body.subTitleColor,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   )
//                 : Container(),
//           ],
//         )
//       ],
//     );
//   }

//   Widget songImage() {
//     return CachedNetworkImage(
//       imageUrl: song!.image,
//       fit: BoxFit.cover,
//       height: 280,
//       width: double.infinity,
//     );
//   }

//   Widget songBasicInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         // SizedBox(width: MediaQuery.of(context).size.width * 0.05),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 song!.name,
//                 style: TextStyles.titleMedium.bold.lightColor,
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 song!.artistsName.join(','),
//                 style: TextStyles.bodySm.semiBold.subTitleColor,
//               ),
//               const SizedBox(height: 15),
//               // Text(
//               //   song!.date,
//               //   style: TextStyles.bodySm.semiBold.subTitleColor,
//               // ),
//               // const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget aboutSong() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(AppLocalizations.of(context)!.aboutSong,
//             style: TextStyles.titleM.bold.lightColor),
//         const SizedBox(
//           height: 10,
//         ),
//         Text(song!.about, style: TextStyles.body.lightColor),
//         const SizedBox(
//           height: 50,
//         ),
//       ],
//     );
//   }

//   Widget similarSongsView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocalizations.of(context)!.otherSongs,
//           style: TextStyles.title.bold.lightColor,
//         ),
//         const SizedBox(height: 20),
//         SizedBox(
//           height: 120,
//           child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: similarSongs.length,
//               itemBuilder: (BuildContext ctx, int index) {
//                 return PlayIconHoveringWidget(
//                   child: SongCard(
//                     song: similarSongs[index],
//                     width: 120,
//                   ),
//                   tapHandler: () {
//                     getIt<PlayerManager>().updatePlaylistAndPlay(
//                         songs: similarSongs, currentSong: similarSongs[index]);

//                     // context.push('/song_detail/${similarSongs[index].id}');
//                   },
//                 );
//               },
//               separatorBuilder: (BuildContext ctx, int index) {
//                 return const SizedBox(
//                   width: 20,
//                 );
//               }),
//         )
//       ],
//     );
//   }

//   Widget buttonsView() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 40,
//               color: AppTheme.singleton.redColor,
//               child: Row(
//                 children: [
//                   ThemeIconWidget(
//                     ThemeIcon.play,
//                     color: AppTheme.singleton.lightColor,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     AppLocalizations.of(context)!.playNow,
//                     style: TextStyles.bodySm.lightColor,
//                   )
//                 ],
//               ).p8,
//             ).round(25).ripple(() {
//               getIt<PlayerManager>()
//                   .updatePlaylist(songs: [song!], currentSong: null);
//             }),
//             const SizedBox(
//               width: 10,
//             ),
//             ThemeIconWidget(
//                     song?.isLiked == true ? ThemeIcon.favFilled : ThemeIcon.fav,
//                     color: song?.isLiked == true
//                         ? AppTheme.singleton.redColor
//                         : AppTheme.singleton.lightColor)
//                 .p8
//                 .borderWithRadius(
//                     value: 1, radius: 25, color: AppTheme.singleton.lightColor)
//                 .ripple(() {
//               if (UserProfileManager().user == null) {
//                 context.go('/login');
//               } else {
//                 if (song?.isLiked == true) {
//                   getIt<FirebaseManager>().unlikeSong(songId);
//                   song?.isLiked = false;
//                 } else {
//                   getIt<FirebaseManager>().likeSong(songId);
//                   song?.isLiked = true;
//                 }
//               }
//               setState(() {});
//             }),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget songsView() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocalizations.of(context)!.similarSongs,
//           style: TextStyles.h3Style.lightColor,
//         ),
//         const SizedBox(height: 20),
//         GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           itemCount: similarSongs.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: 1,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20,
//               crossAxisCount: 2),
//           itemBuilder: (BuildContext context, int index) {
//             return SongCard(song: similarSongs[index]).ripple(() {
//               getIt<PlayerManager>().updatePlaylist(
//                   songs: similarSongs, currentSong: similarSongs[index]);
//             });
//           },
//         )
//       ],
//     );
//   }
// }
