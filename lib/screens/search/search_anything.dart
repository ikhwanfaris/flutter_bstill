import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SearchAnything extends StatefulWidget {
  final List<ArtistModel> artists;
  final List<SongModel> songs;
  final List<GenreModel> genres;
  final List<AlbumModel> albums;
  final List<PlaylistModel> playlists;

  const SearchAnything(
      {Key? key,
      required this.artists,
      required this.songs,
      required this.genres,
      required this.albums,
      required this.playlists})
      : super(key: key);

  @override
  SearchAnythingState createState() => SearchAnythingState();
}

class SearchAnythingState extends State<SearchAnything> {
  List<String> filters = [
    LocalizationString.artists,
    LocalizationString.songs,
    LocalizationString.albums,
    LocalizationString.playlists,
    LocalizationString.genres
  ];
  //  List<String> filters = [
  //   AppLocalizations.of(context)!.artists,
  //   AppLocalizations.of(context)!.songs,
  //   AppLocalizations.of(context)!.albums,
  //   AppLocalizations.of(context)!.playlists,
  //   AppLocalizations.of(context)!.genres
  // ];
  //The instance member 'context' can't be accessed in an initializer.
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    filters = [
      AppLocalizations.of(context)!.artists,
      AppLocalizations.of(context)!.songs,
      AppLocalizations.of(context)!.albums,
      AppLocalizations.of(context)!.playlists,
      AppLocalizations.of(context)!.genres
    ];

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          color: AppTheme.singleton.navigationBarColor,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: ListView.separated(
                    padding: const EdgeInsets.all(16),
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
        ));
  }

  Widget loadFilter(int index) {
    print('black123');
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

  Widget loadView() {
    if (selectedTab == 0) {
      return artistsView();
    } else if (selectedTab == 1) {
      return songsView();
    } else if (selectedTab == 2) {
      return albumsView();
    } else if (selectedTab == 3) {
      return playlistsView();
    }
    return genresView();
  }

  Widget artistsView() {
    if (widget.artists.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: widget.artists.length,
        itemBuilder: (ctx, index) {
          return ArtistHorizontalTile(artist: widget.artists[index]).ripple(() {
            getIt<FirebaseManager>()
                .increaseArtistSearchCount(widget.artists[index]);

            context.push('/artist_detail/${widget.artists[index].id}',
                extra: 1);
          });
        },
        separatorBuilder: (ctx, index) {
          return Container(
            height: 0.2,
            color: AppTheme.singleton.dividerColor,
          ).vP16;
        },
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.noDataFound,
        style: TextStyles.h3Style.bold.fontColor,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget albumsView() {
    if (widget.albums.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: widget.albums.length,
        itemBuilder: (ctx, index) {
          return AlbumTile(album: widget.albums[index]).ripple(() {
            getIt<FirebaseManager>()
                .increaseAlbumSearchCount(widget.albums[index]);
            context.push('/album_detail/${widget.albums[index].id}', extra: 1);
          });
        },
        separatorBuilder: (ctx, index) {
          return Container(
            height: 0.2,
            color: AppTheme.singleton.dividerColor,
          ).vP16;
        },
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.noDataFound,
        style: TextStyles.h3Style.bold.fontColor,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget songsView() {
    if (widget.songs.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: widget.songs.length,
        itemBuilder: (ctx, index) {
          return SongTile(
            song: widget.songs[index],
            fromPlaylistPage: false,
            playlistId: "",
          ).ripple(() {
            getIt<FirebaseManager>()
                .increaseSongSearchCount(widget.songs[index]);

            context.push('/song_detail/${widget.songs[index].id}');
          });
        },
        separatorBuilder: (ctx, index) {
          return Container(
            height: 0.2,
            color: AppTheme.singleton.dividerColor,
          ).vP16;
        },
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.noDataFound,
        style: TextStyles.h3Style.bold.fontColor,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget playlistsView() {
    if (widget.playlists.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        itemCount: widget.playlists.length,
        itemBuilder: (ctx, index) {
          return PlaylistTile(playlist: widget.playlists[index]).ripple(() {
            getIt<FirebaseManager>()
                .increasePlaylistSearchCount(widget.playlists[index]);

            context.push('/playlist_detail/${widget.playlists[index].id}',
                extra: 1);
          });
        },
        separatorBuilder: (ctx, index) {
          return Container(
            height: 0.2,
            color: AppTheme.singleton.dividerColor,
          ).vP16;
        },
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.noDataFound,
        style: TextStyles.h3Style.bold.fontColor,
        textAlign: TextAlign.center,
      );
    }
  }

  Widget genresView() {
    if (widget.genres.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.genres.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: AppTheme.singleton.primaryBackgroundColor.lighten(),
            child: Row(
              children: [
                Text(
                  widget.genres[index].name,
                  style: TextStyles.bodySm.lightColor,
                ),
                const Spacer(),
              ],
            ).p(12),
          ).round(15).ripple(() {
            context.push('/searched_genre_music/${widget.genres[index].id}');
          });
        },
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.noDataFound,
        style: TextStyles.h3Style.bold.fontColor,
        textAlign: TextAlign.center,
      );
    }
  }
}
