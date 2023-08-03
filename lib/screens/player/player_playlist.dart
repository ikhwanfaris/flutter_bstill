import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlayerPlaylist extends StatefulWidget {
  const PlayerPlaylist({Key? key}) : super(key: key);

  @override
  PlayerPlaylistState createState() => PlayerPlaylistState();
}

class PlayerPlaylistState extends State<PlayerPlaylist> {
  List<PlayingMediaModel> allSongs = [];
  List<PlayingMediaModel> selectedSongs = [];
  final _scrollController = ScrollController();
  final double _height = 80;
  final pageManager = getIt<PlayerManager>();
  int a = 1;
  @override
  void initState() {
    super.initState();
    setState(() {
      allSongs = pageManager.currentPlaylistMedia();
      // pageManager.playlistMediaNotifier.value = allSongs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppTheme.singleton.fontColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-m-2.png'),
            // opacity: 0.7,
            fit: BoxFit.cover,
          ),
        ),
        //backgroundColor: AppTheme.singleton.transparent,
        // backgroundColor: Colors.black,
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              children: [
                ThemeIconWidget(
                  ThemeIcon.close,
                  color: AppTheme.singleton.fontColor,
                  size: 25,
                ).ripple(() {
                  Navigator.of(context).pop();
                }),
                // ThemeIconWidget(
                //   ThemeIcon.addMusic,
                //   color: AppTheme.singleton.fontColor,
                //   size: 25,
                // ).ripple(() {
                //   _scrollToIndex(a);
                //   a++;
                // }),
              ],
            ).hP16,
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ValueListenableBuilder<PlayingMediaModel?>(
                          valueListenable:
                              pageManager.currentSongChangeNotifier,
                          builder: (_, modal, __) {
                            return SizedBox(
                                height: 110, child: nowPlaying(modal!));
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ValueListenableBuilder<num>(
                          valueListenable: pageManager.currentSongIndex,
                          builder: (_, modal, __) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(_height * modal,
                                  duration: const Duration(microseconds: 1),
                                  curve: Curves.easeIn);
                            });

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(modal.toString()),
                                Text(
                                  AppLocalizations.of(context)!.playingNext,
                                  style: TextStyles.body.bold.fontColor,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView.separated(
                                    controller: _scrollController,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: allSongs.length,
                                    itemBuilder: (ctx, index) {
                                      return index.toString() == "0"
                                          ? Container()
                                          : MediaTile(
                                              song: allSongs[index],
                                              selectionHandler: () {
                                                setState(() {
                                                  if (selectedSongs.contains(
                                                      allSongs[index])) {
                                                    selectedSongs.remove(
                                                        allSongs[index]);
                                                  } else {
                                                    selectedSongs
                                                        .add(allSongs[index]);
                                                  }
                                                });
                                              }).ripple(() {
                                              pageManager.skipToQueueItem(
                                                  allSongs[index].id);
                                            });
                                    },
                                    separatorBuilder: (ctx, index) {
                                      return const SizedBox(
                                        height: 5,
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          },
                        )
                        // ValueListenableBuilder<List<PlayingMediaModel>>(
                        //   valueListenable: pageManager.playlistMediaNotifier,
                        //   builder: (_, songs, __) {
                        //     return nextInQueue(songs);
                        //     // Text(songs!.length.toString());
                        //   },
                        // ),
                        // allSongs.length > 1
                        //     ?
                        // SizedBox(
                        //     height: (allSongs.length * 65) + 80,
                        // child:
                        //  // nextInQueue2(),
                        // )
                        // : Container(),
                      ],
                    ),
                  )
                ],
              ).hP16,
            ),
            selectedSongs.isNotEmpty
                ? Container(
                    height: 80,
                    color: AppTheme.singleton.primaryBackgroundColor.lighten(),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.remove,
                          style: TextStyles.title.bold.white,
                        ).ripple(() {
                          for (PlayingMediaModel song in selectedSongs) {
                            allSongs.removeWhere(
                                (element) => element.id == song.id);
                            pageManager.removeMedia(song);
                          }
                          selectedSongs = [];
                          setState(() {});
                        })
                      ],
                    ).hP16,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget nowPlaying(PlayingMediaModel song) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.nowPlaying,
          style: TextStyles.body.bold.fontColor,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            CachedNetworkImage(
                    imageUrl: song.image,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50)
                .round(10),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: TextStyles.body.bold.fontColor,
                  ),
                  Text(
                    song.artistName,
                    style: TextStyles.bodySm.semiBold.merge(
                        TextStyle(color: const Color(0XFF3c516e).lighten(0.3))),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ).ripple(() {})
      ],
    );
  }

  Widget nextInQueue(List<PlayingMediaModel> a) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.playingNext,
          style: TextStyles.body.bold.fontColor,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child:
              // Text(a.length.toString()),
              ListView.separated(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: a.length,
            itemBuilder: (ctx, index) {
              return
                  // Text([index].toString());
                  index.toString() == "0"
                      ? Container()
                      : MediaTile(
                          song: a[index],
                          selectionHandler: () {
                            setState(() {
                              if (selectedSongs.contains(a[index])) {
                                selectedSongs.remove(a[index]);
                              } else {
                                selectedSongs.add(a[index]);
                              }
                            });
                          }).ripple(() {
                          pageManager.skipToQueueItem(a[index].id);
                        });
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        )
      ],
    );
  }

  Widget nextInQueue2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.playingNext,
          style: TextStyles.body.bold.fontColor,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: allSongs.length,
            itemBuilder: (ctx, index) {
              return MediaTile(
                  song: allSongs[index],
                  selectionHandler: () {
                    setState(() {
                      if (selectedSongs.contains(allSongs[index])) {
                        selectedSongs.remove(allSongs[index]);
                      } else {
                        selectedSongs.add(allSongs[index]);
                      }
                    });
                  }).ripple(() {
                pageManager.skipToQueueItem(allSongs[index].id);
              });
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        )
      ],
    );
  }
}
