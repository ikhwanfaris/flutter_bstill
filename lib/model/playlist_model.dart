import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistModel {
  String id;
  String name;
  String? addedBy;
  String? addedByName;

  String? image;
  String? about;

  // List<String> artistsId;
  List<String> songsId;
  int totalFollowers = 0;
  String? genreName;
  String? genreId;
  String? language;

  List<SongModel> songs = [];
  UserModel? createdBy;

  bool isFollowing = false;
  bool? fromAdmin = false;

  int status;
  int totalStreams;
  int searchedCount;

  PlaylistModel(
      {required this.id,
      required this.name,
      required this.fromAdmin,
      this.addedBy,
      required this.addedByName,
      // required this.artistsId,
      required this.songsId,
      required this.image,
      required this.about,
      required this.language,
      required this.status,
      required this.totalStreams,
      required this.searchedCount,
      this.genreId,
      this.genreName,
      required this.totalFollowers});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
        id: json["id"],
        name: json["name"],
        addedBy: json["addedBy"],
        addedByName: json["addedByName"],
        image: json["image"],
        about: json["about"],
        genreName: json["genreName"],
        genreId: json["genreId"],
        language: json["language"],
        fromAdmin: json["byAdmin"],
        // artistsId: json["artists"] == null
        //     ? []
        //     : (json["artists"] as List<dynamic>)
        //         .map((e) => e.toString())
        //         .toList(),
        songsId: json["songs"] == null
            ? []
            : (json["songs"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        totalFollowers: json["followersCount"] ?? 0,
        status: json["status"],
        totalStreams: json["totalStreams"] ?? 0,
        searchedCount: json["searchedCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'addedBy': addedBy,
        'addedByName': addedByName,
        'image': image,
        'about': about,
        'genreName': genreName,
        'genreId': genreId,
        'language': language,
        // "artists": (artistsId).map((e) => e.toString()).toList(),
        "songs": (songsId).map((e) => e.toString()).toList(),
        'followersCount': totalFollowers,
        'status': status,
      };

  String formattedTotalStreams() {
    if (totalStreams > 1000) {
      return NumberFormat('#,##,000').format(totalStreams);
    } else {
      return '$totalStreams';
    }
  }
}
