import 'package:music_streaming_mobile/helper/common_import.dart';

class SongModel {
  String id;
  String name;
  String about;

  // String date;
  String genreName;
  String genreId;
  String image;
  String file;
  int status;
  int totalStreams;
  int searchedCount;

  List<String> artistsId;
  List<String> artistsName;

  ArtistModel? artist;

  String? director;
  String? lyricist;
  String? music;
  String? composer;

  bool isLiked = false;
  String language;
  bool free_song = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  SongModel(
      {required this.id,
      required this.name,
      required this.about,
      required this.genreId,
      required this.genreName,
      // required this.date,
      required this.image,
      required this.file,
      required this.artistsId,
      required this.artistsName,
      required this.status,
      required this.totalStreams,
      required this.searchedCount,
      this.artist,
      this.director,
      this.lyricist,
      this.music,
      this.composer,
      required this.language,
      required this.free_song});

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
      id: json["id"],
      name: json["name"],
      about: json["about"],
      genreId: json["genreId"],
      genreName: json["genreName"],
      // albumId: json["albumId"],
      // albumName: json["albumName"],
      // date: json["date"],
      status: json["status"],
      totalStreams: json["totalStreams"] ?? 0,
      searchedCount: json["searchedCount"] ?? 0,
      image: json["image"],
      file: json["file"],
      artistsName: (json["artistsName"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      artistsId: (json["artistsId"] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      director: json["director"],
      lyricist: json["lyricist"],
      music: json["music"],
      composer: json["composer"],
      language: json["language"],
      free_song: json["free_song"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "about": about,
        "genreId": genreId,
        "genreName": genreName,
        // "albumId": albumId,
        // "albumName": albumName,
        // "date": date,
        "status": status,
        "totalStreams": totalStreams,
        "image": image,
        "file": file,
        "artistsName": (artistsName).map((e) => e.toString()).toList(),
        "artistsId": (artistsId).map((e) => e.toString()).toList(),
        "director": director,
        "lyricist": lyricist,
        "music": music,
        "composer": composer,
        "language": language,
        "free_song": free_song
      };

  String formattedTotalStreams() {
    if (totalStreams > 1000) {
      return NumberFormat('#,##,000').format(totalStreams);
    } else {
      return '$totalStreams';
    }
  }
}

class PlayingMediaModel {
  String id;
  String name;
  String artistName;
  String image;
  List<String> allArtists;

  bool isLiked = false;

  PlayingMediaModel(
      {required this.id,
      required this.name,
      required this.artistName,
      required this.image,
      required this.allArtists});
}
// class PlayingMediaModelA {
//   bool id;
//   List<String> allArtists;

//   PlayingMediaModelA(
//       {required this.id,
//       required this.allArtists});
// }
