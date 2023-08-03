class UserModel {
  String id;
  // String phone;
  List<String> followingArtists;
  List<String> followingPlaylists;
  List<String> likedSongs;
  // List<String> prefLanguages;

  List<String> songsHistory;
  List<String> albumsHistory;
  List<String> playlistHistory;

  int status;
  int isSubscribed;
  int freeTrialLeft;
  String active_subscription;
  String? expiryDate;
  String subscribeVia;
  String subscribeStatus;

  UserModel(
      {required this.id,
      // required this.phone,
      // required this.description,
      required this.followingArtists,
      required this.followingPlaylists,
      required this.likedSongs,
      required this.songsHistory,
      required this.albumsHistory,
      required this.playlistHistory,
      // required this.prefLanguages,
      required this.status,
      required this.isSubscribed,
      required this.freeTrialLeft,
      required this.active_subscription,
      required this.expiryDate,
      required this.subscribeVia,
      required this.subscribeStatus});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"] == null ? "" : json['id'],
        // phone: json["phone"],
        followingArtists: json["followingArtists"] == null
            ? []
            : (json["followingArtists"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        followingPlaylists: json["followingPlaylists"] == null
            ? []
            : (json["followingPlaylists"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        likedSongs: json["likedSongs"] == null
            ? []
            : (json["likedSongs"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        songsHistory: json["songListenHistory"] == null
            ? []
            : (json["songListenHistory"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        albumsHistory: json["albumListenHistory"] == null
            ? []
            : (json["albumListenHistory"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        playlistHistory: json["playlistListenHistory"] == null
            ? []
            : (json["playlistListenHistory"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        // prefLanguages: json["languagePref"] == null
        //     ? ["English"]
        //     : (json["languagePref"] as List<dynamic>)
        //         .map((e) => e.toString())
        //         .toList(),
        status: json["status"] == null ? 0 : int.parse(json['status']),
        isSubscribed: json["isSubscribed"] ?? 0,
        freeTrialLeft: json['freeTrialLeft'] ?? 0,
        active_subscription: json['active_subscription'] ?? '',
        expiryDate: json["expiry_date"] ?? '',
        subscribeVia: json["subscribe_via"] ?? "",
        subscribeStatus: json['subscribeStatus'] ?? 'I');
  }
}
