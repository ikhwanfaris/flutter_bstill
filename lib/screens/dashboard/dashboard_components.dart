import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

import '../../components/genre/genre_card.dart';

// Trending Playlist
// Widget playlistSection(Section section, BuildContext context, int tabIndex) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             section.heading,
//             style: TextStyles.titleBold.fontColor,
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           // Container(
//           //   height: 5,
//           //   width: section.heading.length * 6,
//           //   color: AppTheme.singleton.themeColor,
//           // ).round(5)
//         ],
//       ).lP16,
//       SizedBox(
//         height: 180,
//         child: ListView.separated(
//           padding: const EdgeInsets.only(left: 16),
//           scrollDirection: Axis.horizontal,
//           itemCount: section.items.length < 10 ? section.items.length : 10,
//           itemBuilder: (BuildContext ctx, int index) {
//             return SizedBox(
//                 width: 120,
//                 height: 120,
//                 child: PlayIconHoveringWidget(
//                   child: PlaylistCard(playlist: section.items[index]),
//                   tapHandler: () {
//                     if (FirebaseAuth.instance.currentUser != null) {
//                       context.push(
//                           '/playlist_detail/${section.items[index].id}/',
//                           extra: tabIndex);
//                     } else {
//                       context.go('/account');
//                     }
//                   },
//                 ));
//           },
//           separatorBuilder: (BuildContext ctx, int index) {
//             return const SizedBox(width: 20);
//           },
//         ),
//       ),
//     ],
//   );
// }

// Trending Album
Widget albumSection(Section section, BuildContext context, int tabIndex) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: TextStyles.titleBold.fontColor,
          ),
          // TextButton(
          //   style: ButtonStyle(
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          //   ),
          //   onPressed: () { },
          //   child: Text('TextButtonss'),
          // ),
          const SizedBox(
            height: 5,
          ),

          // Container(
          //   height: 5,
          //   width: section.heading.length * 6,
          //   color: AppTheme.singleton.themeColor,
          // ).round(5)
        ],
      ).lP16,
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 160,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length < 10 ? section.items.length : 10,
          itemBuilder: (BuildContext ctx, int index) {
            return SizedBox(
                width: 120,
                child: PlayIconHoveringWidget(
                  // child: Text(section.items[index].id),
                  child: AlbumCard(album: section.items[index]),

                  tapHandler: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      context.push('/album_detail/${section.items[index].id}',
                          extra: tabIndex);
                    } else {
                      context.go('/account');
                    }
                  },
                ));
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    ],
  );
}

// Genres
Widget genreSection(Section section, BuildContext context, int tabIndex) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.heading,
                  style: TextStyles.titleBold.fontColor,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ).lP16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      // Sample sample = Sample(
                      //     attributeA: section.items,
                      //     attributeB: section.heading);
                      // print(sample.attributeA);
                      context.push('/seeallpage', extra: {
                        "a": section.items,
                        "b": section.heading,
                        'isSubcribed': isSubscribed
                      });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SeeAllPage(
                      //       genre: section.items as List<GenreModel>,
                      //       title: section.heading,
                      //     ),
                      //   ),
                      // );
                    } else {
                      context.go('/account');
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.seeAll,
                    style: TextStyles.bodySm.bold.fontColor.merge(
                        const TextStyle(overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ],
            ).lP16,
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 155,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length < 10 ? section.items.length : 10,
          itemBuilder: (BuildContext ctx, int index) {
            return SizedBox(
                width: 120,
                height: 100,
                child: PlayIconHoveringWidget(
                  child: GenreCard(genre: section.items[index]),
                  tapHandler: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      context.push(
                          '/searched_genre_music/${section.items[index].id}',
                          extra: section.items[index].name);
                    } else {
                      context.go('/account');
                    }
                  },
                ));
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    ],
  );
}

// Recently Played Song // Trending Song
Widget songsSection(
    Section section, BuildContext context, int tabIndex, bool isSubscribed) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.heading,
                  style: TextStyles.titleBold.fontColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                // Container(
                //   height: 5,
                //   width: section.heading.length * 6,
                //   color: AppTheme.singleton.themeColor,
                // ).round(5)
              ],
            ).lP16,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      context.push('/seeallsongpage', extra: {
                        "a": section.items,
                        "b": section.heading,
                        'isSubscribed': isSubscribed
                      });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SeeAllPageSongs(
                      //       songs: section.items as List<SongModel>,
                      //       title: section.heading,
                      //     ),
                      //   ),
                      // );
                      // context.push(
                      //     '/searched_genre_music/${section.items[index].id}',
                      //     extra: section.items[index].name);
                    } else {
                      if (isSubscribed == true) {
                        context.push('/seeallsongpage', extra: {
                          "a": section.items,
                          "b": section.heading,
                          'isSubscribed': true
                        });
                      } else {
                        context.go('/account');
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.seeAll,
                    style: TextStyles.bodySm.bold.fontColor.merge(
                        const TextStyle(overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ],
            ).lP16,
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 155,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length < 10 ? section.items.length : 10,
          itemBuilder: (BuildContext ctx, int index) {
            return SizedBox(
              width: 120,
              height: 100,
              child: PlayIconHoveringWidget(
                // child: Text(section.items[index].id),
                child: SongCard(
                    song: section.items[index], isSubscribed: isSubscribed),
                tapHandler: () async {
                  // List<PlayingMediaModel> allSongs = [];
                  // allSongs = getIt<PlayerManager>().currentPlaylistMedia();
                  // print("length before");
                  // print(allSongs.length.toString());
                  if (FirebaseAuth.instance.currentUser != null) {
                    // print("pressed");
                    isSubscribed
                        ? await getIt<PlayerManager>().updatePlaylist(
                            songs: section.items as List<SongModel>,
                            currentSong: section.items[index])
                        : GFToast.showToast(
                            AppLocalizations.of(context)?.subscribeToUse,
                            context,
                            toastPosition: GFToastPosition.TOP,
                            textStyle: TextStyles.body.white,
                            backgroundColor: AppTheme().fontColor,
                          );
                  } else {
                    if (isSubscribed == true) {
                      await getIt<PlayerManager>().updatePlaylist(
                          songs: section.items as List<SongModel>,
                          currentSong: section.items[index]);
                    } else {
                      context.go('/account');
                    }
                  }
                  // await getIt<PlayerManager>().addPlaylistandPaly(
                  //   section.items[index],
                  // );

                  // getIt<PlayerManager>()
                  //     .playspecificSong(section.items[index].id);

                  // getIt<PlayerManager>().add(section.items[index].id);

                  // List<PlayingMediaModel> allSongs2 = [];
                  // allSongs2 = getIt<PlayerManager>().currentPlaylistMedia();
                  // print("length after");
                  // print(allSongs2.length.toString());
                  // getIt<PlayerManager>()
                  //     .skipToQueueItem(section.items[index].id);

                  // context.push('/song_detail/${section.items[index].id}',
                  //     extra: tabIndex);
                },
              ),
            );
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    ],
  );
}

// Recently Played Artist
Widget artistSection(Section section, BuildContext context, int tabIndex) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: TextStyles.titleBold.fontColor,
          ),
          const SizedBox(
            height: 5,
          ),
          // Container(
          //   child: const Text("See all"),
          //   height: 5,
          //   width: section.heading.length * 6,
          //   color: AppTheme.singleton.themeColor,
          // ).round(5)
        ],
      ).lP16,
      const SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 160,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length < 10 ? section.items.length : 10,
          itemBuilder: (BuildContext ctx, int index) {
            return SizedBox(
              width: 120,
              height: 120,
              child: CircleArtistCard(
                artist: section.items[index],
                isSelected: false,
                selectionCallback: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    context.push('/artist_detail/${section.items[index].id}',
                        extra: tabIndex);
                  } else {
                    context.go('/account');
                  }
                },
              ),
            );
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 20);
          },
        ),
      ),
    ],
  );
}

  // showMessage(String message, bool isError) {
  //   GFToast.showToast(message, context,
  //       toastPosition: GFToastPosition.BOTTOM,
  //       textStyle: TextStyles.body,
  //       backgroundColor:
  //           isError == true ? AppTheme().redColor : AppTheme().successColor,
  //       trailing: Icon(
  //           isError == true ? Icons.error : Icons.check_circle_outline,
  //           color: AppTheme().lightColor));
  // }
