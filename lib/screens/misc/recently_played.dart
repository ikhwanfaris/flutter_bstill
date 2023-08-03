import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<String> filters = [
    //AppLocalizations.of(context)!.artists,
    AppLocalizations.of(context)!.songs,
    AppLocalizations.of(context)!.albums,
    AppLocalizations.of(context)!.playlists,
  ];

  List<ArtistModel> allArtists = [];
  List<SongModel> allSongs = [];
  List<AlbumModel> allAlbums = [];
  List<PlaylistModel> allPlaylists = [];

  int selectedTab = 0;

  @override
  void initState() {
    loadAlbums();
    loadArtists();
    loadSongs();
    loadPlaylists();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.singleton.navigationBarColor,
      appBar: BackNavigationBar(
        title: AppLocalizations.of(context)?.recentlyPlayed,
        backTapHandler: () {
          context.pop();
        },
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.separated(
                padding: const EdgeInsets.only(left: 16, right: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return loadFilter(index);
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    width: 15,
                  );
                },
                itemCount: filters.length),
          ),
          Expanded(child: loadView().hP16)
        ],
      ),
    );
  }

  Widget loadFilter(int index) {
    return ChoiceChip(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.singleton.lightColor, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppTheme.singleton.primaryBackgroundColor,
      selectedColor: selectedTab == index
          ? AppTheme.singleton.themeColor
          : Colors.transparent,
      label: Text(
        filters[index],
        style: TextStyles.bodySm.bold.lightColor,
      ),
      selected: selectedTab == index,
      onSelected: (status) {
        setState(() {
          selectedTab = index;
        });
      },
    );
  }

  // Widget loadView() {
  //   if (selectedTab == 0) {
  //     return artistsView();
  //   } else if (selectedTab == 1) {
  //     return songsView();
  //   } else if (selectedTab == 2) {
  //     return albumsView();
  //   } else if (selectedTab == 3) {
  //     return playlistsView();
  //   }
  //   return playlistsView();
  // }


Widget loadView() {
    if (selectedTab == 0) {
      return songsView();
    } else if (selectedTab == 1) {
      return albumsView();
    } else if (selectedTab == 2) {
      return playlistsView();
    }
    return playlistsView();
  }
  // Widget artistsView() {
  //   return ListView.separated(
  //     padding: const EdgeInsets.only(top: 20, bottom: 20),
  //     itemCount: allArtists.length,
  //     itemBuilder: (ctx, index) {
  //       return ArtistHorizontalTile(artist: allArtists[index]).ripple(() {
  //         context.push('/artist_detail/${allArtists[index].id}', extra: 4);
  //       });
  //     },
  //     separatorBuilder: (ctx, index) {
  //       return Container(
  //         height: 0.2,
  //         color: AppTheme.singleton.dividerColor,
  //       ).vP16;
  //     },
  //   );
  // }

  Widget albumsView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: allAlbums.length,
      itemBuilder: (ctx, index) {
        return AlbumTile(album: allAlbums[index]).ripple(() {
          context.push('/album_detail/${allAlbums[index].id}', extra: 4);
        });
      },
      separatorBuilder: (ctx, index) {
        return Container(
          height: 0.2,
          color: AppTheme.singleton.dividerColor,
        ).vP16;
      },
    );
  }

  Widget songsView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: allSongs.length,
      itemBuilder: (ctx, index) {
        return SongTile(
          song: allSongs[index],
          fromPlaylistPage: false,
          playlistId: '',
        ).ripple(() {
          getIt<PlayerManager>()
              .updatePlaylist(songs: allSongs, currentSong: allSongs[index]);

          // context.push('/song_detail/${allSongs[index].id}',extra: 4);
        });
      },
      separatorBuilder: (ctx, index) {
        return Container(
          height: 0.2,
          color: AppTheme.singleton.dividerColor,
        ).vP16;
      },
    );
  }

  Widget playlistsView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: allPlaylists.length,
      itemBuilder: (ctx, index) {
        return PlaylistTile(playlist: allPlaylists[index]).ripple(() {
          context.push('/playlist_detail/${allPlaylists[index].id}', extra: 4);
        });
      },
      separatorBuilder: (ctx, index) {
        return Container(
          height: 0.2,
          color: AppTheme.singleton.dividerColor,
        ).vP16;
      },
    );
  }

  loadSongs() {
    getIt<FirebaseManager>().getRecentlyPlayedSongs().then((songs) {
      setState(() {
        allSongs = songs.toSet().toList();
      });
    });
  }

  loadArtists() {
    getIt<FirebaseManager>().getRecentlyPlayedArtists().then((artists) {
      setState(() {
        allArtists = artists.toSet().toList();
      });
    });
  }

  loadAlbums() {
    getIt<FirebaseManager>().getRecentlyPlayedAlbums().then((albums) {
      setState(() {
        allAlbums = albums.toSet().toList();
      });
    });
  }

  loadPlaylists() {
    getIt<FirebaseManager>().getRecentlyPlayedPlaylists().then((playlists) {
      setState(() {
        allPlaylists = playlists.toSet().toList();
      });
    });
  }
}
