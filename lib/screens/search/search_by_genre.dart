import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SearchByGenre extends StatefulWidget {
  const SearchByGenre({Key? key}) : super(key: key);

  @override
  SearchByGenreState createState() => SearchByGenreState();
}

class SearchByGenreState extends State<SearchByGenre> {
  List<GenreModel> genres = [];

  List<ArtistModel> artists = [];
  List<SongModel> songs = [];
  List<GenreModel> searchedGenre = [];
  List<AlbumModel> albums = [];
  List<PlaylistModel> playlists = [];

  bool searchStarted = false;

  @override
  void initState() {
    getAllGenres();
    super.initState();
  }

  getAllGenres() {
    getIt<FirebaseManager>().getAllGenres().then((value) {
      setState(() {
        genres = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.singleton.navigationBarColor,
          height: Platform.isIOS ? 100 : 85,
          child: Row(
            children: [
              Container(
                color: Colors.transparent,
                height: 37,
                width: 100,
                child: Image.asset(
                  'assets/images/bstill-text-logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ).setPadding(left: 16, top: Platform.isIOS ? 50 : 30),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-m-2.png'),
                // opacity: 0.7,
                fit: BoxFit.cover,
              ),
            ),
            //color: AppTheme.singleton.primaryBackgroundColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SearchBarType3(
                  needBackButton: searchStarted,
                  radius: 5,
                  backgroundColor: AppTheme.singleton.lightColor,
                  textStyle: TextStyles.body.subTitleColor,
                  iconColor: AppTheme.singleton.lightColor,
                  onSearchCompleted: (text) {},
                  onSearchChanged: (text) {
                    searchStarted = true;

                    searchData(text);
                  },
                  onSearchStarted: () {
                    print('1r');
                    setState(() {
                      searchStarted = true;
                    });
                  },
                  onBackHandler: () {
                    setState(() {
                      searchStarted = false;
                    });
                  },
                ).hP16,
                searchStarted == false
                    ? Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          itemCount: genres.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: AppTheme.singleton.fontColor,
                              child: Center(
                                child: Text(
                                  genres[index].name,
                                  style: TextStyles.bodySm.lightColor,
                                ),
                              ).ripple(() {
                                context.push(
                                    '/searched_genre_music/${genres[index].id}',
                                    extra: genres[index].name);
                              }),
                            );
                          },
                        ).hP16,
                      )
                    : Expanded(
                        child: SearchAnything(
                        artists: artists,
                        songs: songs,
                        genres: searchedGenre,
                        albums: albums,
                        playlists: playlists,
                      ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  searchData(String text) {
    searchAlbums(text);
    searchArtists(text);
    searchPlaylists(text);
    searchSong(text);
    searchGenre(text);
  }

  searchArtists(String text) {
    getIt<FirebaseManager>().searchArtists(text).then((result) {
      setState(() {
        artists = result;
      });
    });
  }

  searchPlaylists(String text) {
    getIt<FirebaseManager>().searchPlaylists(text).then((result) {
      setState(() {
        playlists = result;
      });
    });
  }

  searchAlbums(String text) {
    getIt<FirebaseManager>().searchAlbums(text).then((result) {
      setState(() {
        albums = result;
      });
    });
  }

  searchGenre(String text) {
    getIt<FirebaseManager>().searchGenres(text).then((result) {
      setState(() {
        searchedGenre = result;
      });
    });
  }

  searchSong(String text) {
    getIt<FirebaseManager>().searchSongs(text).then((result) {
      setState(() {
        songs = result;
      });
    });
  }
}
