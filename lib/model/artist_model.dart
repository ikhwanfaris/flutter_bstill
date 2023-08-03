import 'package:music_streaming_mobile/helper/common_import.dart';

class ArtistModel {
  String id;
  String name;
  String? email;
  String image;
  String? phone;
  String bio;
  int totalAlbums;
  int totalSongs;
  int totalFollowers;
  int totalListeners;
  int searchedCount;

  bool isFollowing = false;
  String language;
  String genreName;
  String genreId;

  int status;

  String formattedTotalFollowers() {
    if (totalFollowers > 1000) {
      return NumberFormat('#,##,000').format(totalFollowers);
    } else {
      return '$totalFollowers';
    }
  }

  String formattedTotalListeners() {
    if (totalListeners > 1000) {
      return NumberFormat('#,##,000').format(totalListeners);
    } else {
      return '$totalListeners';
    }
  }

  // String albums;

  ArtistModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.phone,
    required this.bio,
    required this.totalAlbums,
    required this.totalSongs,
    required this.totalFollowers,
    required this.totalListeners,
    required this.language,
    required this.genreName,
    required this.genreId,
    required this.status,
    required this.searchedCount,

    // required this.albums,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) => ArtistModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        bio: json["bio"] ?? '',
        email: json["email"] ?? '',
        image: json["image"] ?? '',
        phone: json["phone"] ?? '',
        totalAlbums: json["totalAlbums"] ?? 0,
        totalSongs: json["totalSongs"] ?? 0,
        totalFollowers: json["followersCount"] ?? 0,
        totalListeners: json["totalListeners"] ?? 0,
        searchedCount: json["searchedCount"] ?? 0,

        language: json["language"],
        genreName: json["genreName"],
        genreId: json["genreId"],
        status: json["status"],
        // albums: json["albums"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bio": bio,
        "email": email,
        "image": image,
        "phone": phone,
        "totalAlbums": totalAlbums,
        "totalSongs": totalSongs,
        "followersCount": totalFollowers,
        "totalListeners": totalListeners,
        "language": language,
        "genreName": genreName,
        "genreId": genreId,
        "status": status,
      };
}
