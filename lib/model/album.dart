import 'package:music_streaming_mobile/helper/common_import.dart';

class AlbumModel {
  String id;
  String name;
  String about;
  String genreName;
  String genreId;
  String image;
  // String date;
  String? addedBy;
  String? addedByName;

  // List<String> artistsId = [];
  List<String> songsId = [];
  List<SongModel> songs = [];
  List<ArtistModel> artists = [];

  // List<SongModel> songs = [];
  String language;
  int status;
  int totalStreams;
  int searchedCount;

  AlbumModel({
    required this.id,
    required this.name,
    required this.addedBy,
    required this.addedByName,
    required this.about,
    required this.genreId,
    required this.genreName,
    required this.image,
    // required this.date,
    // required this.artistsId,
    required this.songsId,
    required this.language,
    required this.status,
    required this.totalStreams,
    required this.searchedCount,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        addedBy: json["addedBy"] ?? '',
        addedByName: json["addedByName"] ?? '',
        genreName: json["genreName"] ?? '',
        genreId: json["genreId"] ?? '',
        image: json["image"] ?? '',
        status: json["status"] ?? '',
        totalStreams: json["totalStreams"] ?? 0,
        searchedCount: json["searchedCount"] ?? 0,
        // date: json["date"] ?? '',
        about: json["about"] ?? '',
        language: json["language"] ?? '',
        // artistsId: (json["artists"] as List<dynamic>)
        //     .map((e) => e.toString())
        //     .toList(),
        songsId:
            (json["songs"] as List<dynamic>).map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "addedBy": addedBy,
        "addedByName": addedByName,
        "genreName": genreName,
        "genreId": genreId,
        "image": image,
        "status": status,
        "totalStreams": totalStreams,
        // "date": date,
        "about": about,
        "language": language,
        // "artists": (artistsId).map((e) => e.toString()).toList(),
        "songs": (songsId).map((e) => e.toString()).toList(),
      };

  String formattedTotalStreams() {
    if (totalStreams > 1000) {
      return NumberFormat('#,##,000').format(totalStreams);
    } else {
      return '$totalStreams';
    }
  }
}
