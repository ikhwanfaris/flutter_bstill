import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  String randomString = base64UrlEncode(values);
  return randomString.replaceAll('=', '');
}

class FirebaseResponse {
  bool? status;
  String? message;
  Object? result;

  FirebaseResponse(this.status, this.message);
}

class FirebaseManager {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseResponse? response;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Day dairy notes
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference artistsCollection =
      FirebaseFirestore.instance.collection('artists');

  CollectionReference playlistsCollection =
      FirebaseFirestore.instance.collection('playlists');

  CollectionReference albumsCollection =
      FirebaseFirestore.instance.collection('album');
  CollectionReference songsCollection =
      FirebaseFirestore.instance.collection('song');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference banners =
      FirebaseFirestore.instance.collection('banners');
  CollectionReference packages =
      FirebaseFirestore.instance.collection('packages');
  CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');
  CollectionReference contact =
      FirebaseFirestore.instance.collection('contact');
  CollectionReference genres = FirebaseFirestore.instance.collection('genres');
  CollectionReference languages =
      FirebaseFirestore.instance.collection('languages');
  CollectionReference settings =
      FirebaseFirestore.instance.collection('settings');
  CollectionReference counter =
      FirebaseFirestore.instance.collection('counter');
  CollectionReference subscriptions =
      FirebaseFirestore.instance.collection('subscriptions');

  Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseResponse> updateUserLanguagePref(
      List<LanguageModel> languages) async {
    DocumentReference doc = userCollection.doc(auth.currentUser!.uid);

    await doc.update(
        {'languagePref': languages.map((e) => e.name).toList()}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updateFollowingArtist(List<String> artistsId) async {
    DocumentReference doc = userCollection.doc(auth.currentUser!.uid);

    await doc.update({'followingArtists': artistsId}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updateRecentlyPlayedArtists(
      ArtistModel artist) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedArtists')
        .doc(artist.id);
    var artistJson = artist.toJson();
    artistJson['listenedAt'] = FieldValue.serverTimestamp();

    await doc.set(artistJson).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> insertUser(String id, String phone) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = userCollection.doc(id);
    DocumentReference counterDoc = counter.doc('counter');

    batch.set(doc, {'id': id, 'phone': phone, 'status': 1});
    batch.update(counterDoc, {'listeners': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  login(
      {required String phoneNumber,
      required Function(String) verificationIdHandler}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('4 == ${e.code}');
        if (e.code == 'invalid-phone-number') {}
      },
      codeSent: (String verificationId, int? resendToken) {
        print('3');
        verificationIdHandler(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('5');
      },
    );
  }

  verifyOTP(String smsCode, String verificationID,
      Function(bool, bool) callback) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          insertUser(
              userCredential.user!.uid, userCredential.user!.phoneNumber!);
          callback(true, true);
        } else {
          await userCollection.doc(userCredential.user!.uid).get().then((doc) {
            if (doc.data() == null) {
              insertUser(
                  userCredential.user!.uid, userCredential.user!.phoneNumber!);
            }
          }).catchError((error) {
            response = FirebaseResponse(false, error);
          });
          callback(true, false);
        }
        UserProfileManager().refreshProfile();
      } else {
        callback(false, false);
      }
    } catch (e) {
      callback(false, false);
    }
  }

  Future<UserModel?> getUser(String id) async {
    UserModel? user;
    await userCollection.doc(id).get().then((doc) {
      user = UserModel.fromJson(doc.data() == null
          ? {'recentlyPlayedSongs': []}
          : doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return user;
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    UserModel? user;
    await userCollection
        .where('phone', isEqualTo: phone)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        user = UserModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return user;
  }

  Future<FirebaseResponse> insertNewPlaylist(String playlistName) async {
    String playlistId = getRandString(10);
    DocumentReference doc = playlistsCollection.doc(playlistId);

    var playlist = {
      'id': playlistId,
      'name': playlistName,
      'addedBy': auth.currentUser!.uid,
      'status': 1
    };

    await doc.set(playlist).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updatePlaylistName(
      String playlistId, String playlistName) async {
    DocumentReference doc = playlistsCollection.doc(playlistId);

    var playlist = {
      'name': playlistName,
    };

    await doc.update(playlist).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> saveToPlaylist(PlaylistModel playlist) async {
    DocumentReference doc = playlistsCollection.doc(playlist.id);

    var playlistJson = playlist.toJson();

    await doc.set(playlistJson).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> saveAlbumToPlaylist(AlbumModel album) async {
    DocumentReference doc = playlistsCollection.doc(album.id);

    var playlistJson = {
      'id': album.id,
      'name': album.name,
      'addedBy': auth.currentUser!.uid,
      'addedByName': auth.currentUser!.phoneNumber,
      'image': album.image,
      // 'artists': album.artistsId,
      'songs': album.songsId,
      'status': 1
    };

    await doc.set(playlistJson).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<String> playlistImage(List<String> songsId) async {
    String playlistImage = '';
    List<SongModel> songsList = [];

    // await getMultipleSongsByIds(songsId).then((song) {
    //   playlistImage = song.first.image;
    // });
    songsList = await getMultipleSongsByIds(songsId);
    playlistImage = songsList[0].image;

    return playlistImage;
  }

  Future<FirebaseResponse> addSongToPlaylist(
      {required String songId, required String playlistId}) async {
    DocumentReference doc = playlistsCollection.doc(playlistId);

    await doc.update({
      'songs': FieldValue.arrayUnion([songId])
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> removeSongFromPlaylist(
      {required String songId, required String playlistId}) async {
    DocumentReference doc = playlistsCollection.doc(playlistId);

    await doc.update({
      'songs': FieldValue.arrayRemove([songId])
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> followArtist(String artistId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference artist = artistsCollection.doc(artistId);
    CollectionReference artistFollowers =
        artistsCollection.doc(artistId).collection('followers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var artistFollowerCollection = artistFollowers.doc(auth.currentUser!.uid);
    // var currentUserFollowingCollection =
    //     followingArtistCollection.doc(artistId);

    batch.set(artistFollowerCollection, {'userId': auth.currentUser!.uid});
    batch.update(currentUserDoc, {
      'followingArtists': FieldValue.arrayUnion([artistId])
    });
    batch.update(artist, {'followersCount': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> unFollowArtist(String artistId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference artist = artistsCollection.doc(artistId);
    CollectionReference artistFollowers =
        artistsCollection.doc(artistId).collection('followers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var artistFollowerCollection = artistFollowers.doc(auth.currentUser!.uid);

    batch.delete(artistFollowerCollection);
    batch.update(currentUserDoc, {
      'followingArtists': FieldValue.arrayRemove([artistId])
    });
    batch.update(artist, {'followersCount': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<ArtistModel>> getAllArtists({String? genreId}) async {
    List<ArtistModel> artistsList = [];

    await UserProfileManager().refreshProfile();

    Query query = artistsCollection.where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }
    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }
    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        artistsList
            .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return artistsList;
  }

  Future<List<ArtistModel>> getTrendingArtists({String? genreId}) async {
    List<ArtistModel> artistsList = [];

    Query query = artistsCollection
        .orderBy('totalListeners', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        artistsList
            .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      print(error);
      response = FirebaseResponse(false, error);
    });

    return artistsList;
  }

  Future<List<ArtistModel>> getTopSearchedArtists(String? genreId) async {
    List<ArtistModel> artistsList = [];

    Query query = artistsCollection
        .orderBy('searchedCount', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        artistsList
            .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return artistsList;
  }

  Future<List<ArtistModel>> getRecentlyPlayedArtists({String? genreId}) async {
    List<ArtistModel> artistsList = [];

    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedArtists');

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) async {
      for (var doc in snapshot.docs) {
        artistsList
            .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
      }

      List<String> artistIds = artistsList.map((e) => e.id).toList();
      artistsList = await getMultipleArtistsByIds(artistsId: artistIds);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return artistsList;
  }

  Future<List<ArtistModel>> searchArtists(String text) async {
    List<ArtistModel> artistsList = [];
    await artistsCollection
        .where("keywords", arrayContainsAny: [text])
        .where('status', isEqualTo: 1)
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            artistsList
                .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return artistsList;
  }

  Future<List<ArtistModel>> getFollowingArtists(List<String> artistIds) async {
    List<ArtistModel> artistsList = [];

    await artistsCollection
        .where("id", whereIn: artistIds)
        .where('status', isEqualTo: 1)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        artistsList
            .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return artistsList;
  }

  Future<List<ArtistModel>> getMultipleArtistsByIds(
      {required List<String> artistsId, String? genreId}) async {
    List<String> copiedArtistsId = List.from(artistsId);

    List<ArtistModel> artistsList = [];

    while (copiedArtistsId.isNotEmpty) {
      List<String> firstTenArtists = [];

      if (copiedArtistsId.length > 10) {
        firstTenArtists = copiedArtistsId.sublist(0, 10);
      } else {
        firstTenArtists = copiedArtistsId.sublist(0, copiedArtistsId.length);
      }

      Query query = artistsCollection
          .where("id", whereIn: firstTenArtists)
          .where('status', isEqualTo: 1);

      if (genreId != null) {
        query = query.where('genreId', isEqualTo: genreId);
      }

      await query.get().then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          artistsList
              .add(ArtistModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });

      if (copiedArtistsId.length > 10) {
        copiedArtistsId.removeRange(0, 10);
      } else {
        copiedArtistsId.clear();
      }
    }

    return artistsList;
  }

  Future<List<SongModel>> getMultipleSongsByIds(List<String> songsId) async {
    List<SongModel> songsList = [];

    while (songsId.isNotEmpty) {
      List<String> firstTenSongsId = [];

      if (songsId.length > 10) {
        firstTenSongsId = songsId.sublist(0, 10);
      } else {
        firstTenSongsId = songsId.sublist(0, songsId.length);
      }
      await songsCollection
          .where("id", whereIn: firstTenSongsId)
          .where('status', isEqualTo: 1)
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });

      if (songsId.length > 10) {
        songsId.removeRange(0, 10);
      } else {
        songsId.clear();
      }
    }
    // for (var i = 0; i < songsList.length; i++) {
    //    print(songsList[i].image.toString());
    // }

    return songsList;
  }

  Future<FirebaseResponse> likeSong(String songId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference songDoc = songsCollection.doc(songId);
    CollectionReference songsLikedByUsers =
        songsCollection.doc(songId).collection('likedByUsers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var songsLikedByUserCollection =
        songsLikedByUsers.doc(auth.currentUser!.uid);

    batch.set(songsLikedByUserCollection, {'userId': auth.currentUser!.uid});

    currentUserDoc
        .get()
        .then((value) => {if (value.get('likedSongs') != null) {}});
    // print(value.get('likedSongs')));
    batch.update(currentUserDoc, {
      'likedSongs': FieldValue.arrayUnion([songId]),
      'lastUpdatedAt': FieldValue.serverTimestamp()
    });
    batch.update(songDoc, {'likesCount': FieldValue.increment(1)});
    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    await UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> unlikeSong(String songId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference artist = songsCollection.doc(songId);
    CollectionReference songsLikedByUsers =
        songsCollection.doc(songId).collection('likedByUsers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var songsLikedByUserCollection =
        songsLikedByUsers.doc(auth.currentUser!.uid);

    batch.delete(songsLikedByUserCollection);
    batch.update(currentUserDoc, {
      'likedSongs': FieldValue.arrayRemove([songId])
    });
    batch.update(artist, {'followersCount': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    await UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> increaseSongSearchCount(SongModel song) async {
    DocumentReference songDoc = songsCollection.doc(song.id);

    await songDoc
        .update({'searchedCount': FieldValue.increment(1)}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> increaseSongListener(SongModel song) async {
    final batch = FirebaseFirestore.instance.batch();

    // increase counter of listeners in artist collection
    increaseArtistsListener(song.artistsId);

    // update recently listened artists collection

    for (String artistId in song.artistsId) {
      getArtist(artistId).then((artist) {
        if (artist != null) {
          updateRecentlyPlayedArtists(artist);
        }
      });
    }

    DocumentReference songDoc = songsCollection.doc(song.id);

    DocumentReference currentUsersSongListenHistoryDoc = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedSongs')
        .doc(getRandString(15));

    var songJson = song.toJson();
    songJson['listenedAt'] = FieldValue.serverTimestamp();
    batch.set(currentUsersSongListenHistoryDoc, songJson);
    batch.update(songDoc, {'totalStreams': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> increasePlaylistListener(
      PlaylistModel playlist) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference playlistDoc = playlistsCollection.doc(playlist.id);

    DocumentReference currentUsersPlaylistListenHistoryDoc = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedPlaylists')
        .doc(getRandString(15));

    var playlistJson = playlist.toJson();
    playlistJson['listenedAt'] = FieldValue.serverTimestamp();

    batch.set(currentUsersPlaylistListenHistoryDoc, playlistJson);
    batch.update(playlistDoc, {'totalStreams': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> increasePlaylistSearchCount(
      PlaylistModel playlist) async {
    DocumentReference doc = playlistsCollection.doc(playlist.id);

    await doc.update({'searchedCount': FieldValue.increment(1)}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    List<PlaylistModel> playlists = [];

    await UserProfileManager().refreshProfile();

    Query query = playlistsCollection;

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    await query
        .where("byAdmin", isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        playlists
            .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlists;
  }

  Future<List<PlaylistModel>> getTopPlaylists({String? genreId}) async {
    List<PlaylistModel> playlists = [];

    Query query = playlistsCollection
        .where("byAdmin", isEqualTo: true)
        .orderBy('totalStreams', descending: true);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where("genreId", isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        playlists
            .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlists;
  }

  Future<List<PlaylistModel>> getTrendingPlaylists({String? genreId}) async {
    List<PlaylistModel> playlists = [];

    Query query = playlistsCollection
        .where("byAdmin", isEqualTo: true)
        .orderBy('totalStreams', descending: true)
        .orderBy('createdAt');

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where("genreId", isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        playlists
            .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlists;
  }

  Future<List<PlaylistModel>> getRecentlyPlayedPlaylists() async {
    List<PlaylistModel> playlists = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedPlaylists')
        .get()
        .then((QuerySnapshot snapshot) async {
      for (var doc in snapshot.docs) {
        playlists
            .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
      }

      List<String> ids = playlists.map((e) => e.id).toList();
      playlists = await getMultiplePlaylistsByIds(ids);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlists;
  }

  Future<List<PlaylistModel>> searchPlaylists(String text) async {
    List<PlaylistModel> playlists = [];

    await playlistsCollection
        .where("byAdmin", isEqualTo: true)
        .where("keywords", arrayContainsAny: [text])
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            playlists.add(
                PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return playlists;
  }

  Future<List<BannerModel>> getAllBanners() async {
    List<BannerModel> bannersList = [];

    await UserProfileManager().refreshProfile();

    Query query = banners;

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        bannersList
            .add(BannerModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return bannersList;
  }

  Future<List<PlaylistModel>> getMyPlaylists() async {
    List<PlaylistModel> playlists = [];

    await playlistsCollection
        .where("addedBy", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        playlists
            .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlists;
  }

  Future<FirebaseResponse> followPlaylist(String playlistId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference playlist = playlistsCollection.doc(playlistId);
    CollectionReference playlistFollowers =
        playlistsCollection.doc(playlistId).collection('followers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var playlistFollowerCollection =
        playlistFollowers.doc(auth.currentUser!.uid);
    // var currentUserFollowingCollection =
    //     followingArtistCollection.doc(artistId);

    batch.set(playlistFollowerCollection, {'userId': auth.currentUser!.uid});
    batch.update(currentUserDoc, {
      'followingPlaylists': FieldValue.arrayUnion([playlistId])
    });
    batch.update(playlist, {'followersCount': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> unFollowPlaylist(String playlistId) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference playlist = playlistsCollection.doc(playlistId);
    CollectionReference playlistFollowers =
        playlistsCollection.doc(playlistId).collection('followers');

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    var playlistFollowerCollection =
        playlistFollowers.doc(auth.currentUser!.uid);

    batch.delete(playlistFollowerCollection);
    batch.update(currentUserDoc, {
      'followingPlaylists': FieldValue.arrayRemove([playlistId])
    });
    batch.update(playlist, {'followersCount': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    UserProfileManager().refreshProfile();
    return response!;
  }

  Future<PlaylistModel?> getPlaylist(String id) async {
    PlaylistModel? playlist;

    await playlistsCollection.doc(id).get().then((doc) {
      playlist = PlaylistModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return playlist;
  }

  Future<List<PlaylistModel>> getMultiplePlaylistsByIds(
      List<String> playlistsId) async {
    List<PlaylistModel> artistsList = [];

    while (playlistsId.isNotEmpty) {
      List<String> firstTenPlaylists = [];

      if (playlistsId.length > 10) {
        firstTenPlaylists = playlistsId.sublist(0, 10);
      } else {
        firstTenPlaylists = playlistsId.sublist(0, playlistsId.length);
      }
      await playlistsCollection
          .where("id", whereIn: firstTenPlaylists)
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          artistsList
              .add(PlaylistModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });

      if (playlistsId.length > 10) {
        playlistsId.removeRange(0, 10);
      } else {
        playlistsId.clear();
      }
    }

    return artistsList;
  }

  Future<List<SongModel>> getAllSongs() async {
    List<SongModel> songsList = [];

    await UserProfileManager().refreshProfile();

    Query query = songsCollection;

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query
    //       .where("language", whereIn: UserProfileManager().user?.prefLanguages)
    //       .where('status', isEqualTo: 1);
    // }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<List<SongModel>> getTopSongs({String? genreId}) async {
    List<SongModel> songsList = [];

    Query query = songsCollection
        .orderBy('totalStreams', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<List<SongModel>> getTrendingSongs(String? genreId) async {
    List<SongModel> songsList = [];

    Query query = songsCollection
        .orderBy('totalStreams', descending: true)
        .where('status', isEqualTo: 1)
        .where('free_song', isEqualTo: false)
        .orderBy('createdAt');

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<List<SongModel>> getTopSearchedSongs({String? genreId}) async {
    List<SongModel> songsList = [];

    Query query = songsCollection
        .orderBy('searchedCount', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<List<SongModel>> getRecentlyPlayedSongs({String? genreId}) async {
    List<SongModel> songsList = [];

    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedSongs')
        .where('free_song', isNotEqualTo: true);
    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) async {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      List<String> songIds = songsList.map((e) => e.id).toSet().toList();
      songsList = await getMultipleSongsByIds(songIds);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<List<SongModel>> searchSongs(String text) async {
    List<SongModel> songsList = [];

    await songsCollection
        .where("keywords", arrayContainsAny: [text])
        .where('status', isEqualTo: 1)
        .where('free_song', isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            songsList
                .add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return songsList;
  }

  Future<List<SongModel>> getAllSongsByArtist(String artistId) async {
    List<SongModel> songsList = [];
    await songsCollection
        .where("artistsId", arrayContainsAny: [artistId])
        .where('status', isEqualTo: 1)
        .where('free_song', isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            songsList
                .add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return songsList;
  }

  Future<List<SongModel>> getAllSongsByGenre(String genreId) async {
    List<SongModel> songsList = [];

    await songsCollection
        .where('genreId', isEqualTo: genreId)
        .where('status', isEqualTo: 1)
        .where('free_song', isEqualTo: false)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songsList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songsList;
  }

  Future<SongModel?> getSong(String id) async {
    SongModel? song;

    await songsCollection.doc(id).get().then((doc) {
      song = SongModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return song;
  }

  Future<List<AlbumModel>> getAllAlbums() async {
    List<AlbumModel> albumsList = [];

    Query query = albumsCollection.where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        albumsList.add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return albumsList;
  }

  Future<List<AlbumModel>> getTopAlbums({String? genreId}) async {
    List<AlbumModel> albumsList = [];

    Query query = albumsCollection
        .orderBy('totalStreams', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        albumsList.add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return albumsList;
  }

  Future<List<AlbumModel>> getTrendingAlbums({String? genreId}) async {
    List<AlbumModel> albumsList = [];

    Query query = albumsCollection
        .orderBy('totalStreams', descending: true)
        .where('status', isEqualTo: 1)
        .orderBy('createdAt');

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        albumsList.add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return albumsList;
  }

  Future<List<GenreModel>> getTrendingGenre({String? genreId}) async {
    List<GenreModel> genreList = [];

    Query query = albumsCollection
        .orderBy('name', descending: true)
        .where('status', isEqualTo: 1);

    // if (UserProfileManager().user?.prefLanguages != null) {
    //   query = query.where("language",
    //       whereIn: UserProfileManager().user?.prefLanguages);
    // }

    if (genreId != null) {
      query = query.where('genreId', isEqualTo: genreId);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        genreList.add(GenreModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return genreList;
  }

  Future<List<AlbumModel>> getRecentlyPlayedAlbums() async {
    List<AlbumModel> albumsList = [];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedAlbums')
        .get()
        .then((QuerySnapshot snapshot) async {
      for (var doc in snapshot.docs) {
        albumsList.add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
      }

      List<String> ids = albumsList.map((e) => e.id).toList();
      albumsList = await getMultipleAlbumsByIds(ids);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return albumsList;
  }

  Future<FirebaseResponse> increaseAlbumListener(AlbumModel album) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference albumDoc = albumsCollection.doc(album.id);

    DocumentReference currentUsersAlbumListenHistoryDoc = FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recentlyPlayedAlbums')
        .doc(getRandString(15));

    var albumJson = album.toJson();
    albumJson['listenedAt'] = FieldValue.serverTimestamp();

    batch.set(currentUsersAlbumListenHistoryDoc, albumJson);
    batch.update(albumDoc, {'totalStreams': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    UserProfileManager().refreshProfile();
    return response!;
  }

  Future<FirebaseResponse> increaseAlbumSearchCount(AlbumModel album) async {
    DocumentReference doc = albumsCollection.doc(album.id);

    await doc.update({'searchedCount': FieldValue.increment(1)}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<AlbumModel>> searchAlbums(String text) async {
    List<AlbumModel> albumsList = [];

    await albumsCollection
        .where("keywords", arrayContainsAny: [text])
        .where('status', isEqualTo: 1)
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            albumsList
                .add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return albumsList;
  }

  Future<List<AlbumModel>> getMultipleAlbumsByIds(List<String> albumIds) async {
    List<AlbumModel> albumList = [];

    while (albumIds.isNotEmpty) {
      List<String> firstTenAlbums = [];

      if (albumIds.length > 10) {
        firstTenAlbums = albumIds.sublist(0, 10);
      } else {
        firstTenAlbums = albumIds.sublist(0, albumIds.length);
      }
      await albumsCollection
          .where("id", whereIn: firstTenAlbums)
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          albumList
              .add(AlbumModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });

      if (albumIds.length > 10) {
        albumIds.removeRange(0, 10);
      } else {
        albumIds.clear();
      }
    }

    return albumList;
  }

  Future<AlbumModel?> getAlbum(String id) async {
    AlbumModel? album;
    await albumsCollection.doc(id).get().then((doc) {
      album = AlbumModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return album;
  }

  increaseArtistsListener(List<String> artistsId) async {
    for (String artistId in artistsId) {
      DocumentReference artistsListenersDoc = artistsCollection
          .doc(artistId)
          .collection('listeners')
          .doc(auth.currentUser!.uid);

      DocumentReference artistsDoc = artistsCollection.doc(artistId);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(artistsListenersDoc);

        if (snapshot.exists == false) {
          transaction
              .set(artistsListenersDoc, {"userId": auth.currentUser!.uid});
          transaction
              .update(artistsDoc, {"totalListeners": FieldValue.increment(1)});
        }
      }).then(
        (value) => {},
        onError: (e) => {},
      );
    }
  }

  Future<FirebaseResponse> increaseArtistSearchCount(ArtistModel artist) async {
    DocumentReference doc = artistsCollection.doc(artist.id);

    await doc.update({'searchedCount': FieldValue.increment(1)}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<ArtistModel?> getArtist(String id) async {
    ArtistModel? artist;

    await artistsCollection.doc(id).get().then((doc) {
      artist = ArtistModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return artist;
  }

  Future<bool> checkIfFollowingArtist(String id) async {
    bool isFollowing = false;
    CollectionReference followingArtistCollection =
        artistsCollection.doc(id).collection('followers');

    await followingArtistCollection
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      isFollowing = snapshot.docs.isNotEmpty;
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return isFollowing;
  }

  Future<bool> checkIfListenerOfArtist(String artistId) async {
    bool isListeningAlready = false;
    CollectionReference listingArtistCollection =
        artistsCollection.doc(auth.currentUser!.uid).collection('listening');

    await listingArtistCollection
        .where('artistId', isEqualTo: artistId)
        .get()
        .then((QuerySnapshot snapshot) {
      isListeningAlready = snapshot.docs.isNotEmpty;
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return isListeningAlready;
  }

  Future<bool> checkIfFollowingPlaylist(String id) async {
    bool isFollowing = false;
    CollectionReference followingArtistCollection =
        playlistsCollection.doc(id).collection('followers');

    await followingArtistCollection
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      isFollowing = snapshot.docs.isNotEmpty;
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return isFollowing;
  }

  Future<bool> checkIfLikedSong(String id) async {
    bool isLiked = false;
    CollectionReference collection =
        songsCollection.doc(id).collection('likedByUsers');

    await collection
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      isLiked = snapshot.docs.isNotEmpty;
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return isLiked;
  }

  Future<FirebaseResponse> reportAbuse(
      String id, String name, DataType type) async {
    String reportId = '${id}_${auth.currentUser!.uid}';

    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = reports.doc(reportId);
    DocumentReference playlistDoc = playlistsCollection.doc(id);
    DocumentReference songDoc = songsCollection.doc(id);
    DocumentReference artistDoc = artistsCollection.doc(id);

    var reportData = {
      'id': id,
      'name': name,
      'type': type == DataType.playlists
          ? 1
          : type == DataType.songs
              ? 2
              : type == DataType.artists
                  ? 3
                  : 4
    };

    batch.set(doc, reportData);

    if (type == DataType.playlists) {
      batch.update(playlistDoc, {'reportCount': FieldValue.increment(1)});
    }
    if (type == DataType.songs) {
      batch.update(songDoc, {'reportCount': FieldValue.increment(1)});
    }
    if (type == DataType.artists) {
      batch.update(artistDoc, {'reportCount': FieldValue.increment(1)});
    }

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> sendContactusMessage(
      String name, String email, String phone, String message) async {
    String id = getRandString(15);
    DocumentReference doc = contact.doc(id);
    await doc.set({
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'status': 1
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<LanguageModel>> getAllLanguages() async {
    List<LanguageModel> languagesList = [];

    await languages.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        languagesList
            .add(LanguageModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return languagesList;
  }

  Future<List<GenreModel>> getAllGenres() async {
    List<GenreModel> genresList = [];

    await genres
        .where('status', isEqualTo: 1)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        genresList.add(GenreModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return genresList;
  }

  Future<List<GenreModel>> searchGenres(String text) async {
    List<GenreModel> genresList = [];

    await genres
        .where("keywords", arrayContainsAny: [text])
        .get()
        .then((QuerySnapshot snapshot) {
          for (var doc in snapshot.docs) {
            genresList
                .add(GenreModel.fromJson(doc.data() as Map<String, dynamic>));
          }
        })
        .catchError((error) {
          response = FirebaseResponse(false, error);
        });

    return genresList;
  }

  Future<List<SongModel>> getAllFreeSongs() async {
    List<SongModel> songList = [];

    await songsCollection
        .where('free_song', isEqualTo: true)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        songList.add(SongModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return songList;
  }

  Future<List<Section>> getHomePageData(
      {String? genreId, required BuildContext context}) async {
    List<Section> sections = [];

    await UserProfileManager().refreshProfile();

    List<GenreModel> genresList = [];
    getAllGenres().then((value) {
      genresList = value;
      //  for (var element in genresList) {
      //       getTrendingGenre(genreId: element.id);
      //     }
    });

    if (UserProfileManager().user == null) {
      var responses = await Future.wait([
        getTrendingSongs(genreId), //1
        //getTrendingArtists(genreId: genreId),//2
        getTrendingAlbums(genreId: genreId), //3
        //getTopSongs(genreId: genreId),//4
        //getTopSearchedSongs(genreId: genreId),//5
        //getTrendingPlaylists(genreId: genreId),//6
        //getTopSearchedArtists(genreId),//7
        //getTopPlaylists(genreId: genreId),//8
        getTopAlbums(genreId: genreId), //9
        getAllGenres(), //10
        getAllFreeSongs()
      ]);

      if (responses[4].isNotEmpty) {
        sections.add(Section(
            // heading: 'Trending albums',
            heading: AppLocalizations.of(context)!.songsPreview,
            items: responses[4],
            dataType: DataType.freeSongs));
      }
      if (responses[0].isNotEmpty) {
        sections.add(Section(
            // heading: 'Trending songs',
            heading: AppLocalizations.of(context)!.trendingSong,
            items: responses[0],
            dataType: DataType.songs));
      }
      // if (responses[1].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Trending artists',
      //       items: responses[1],
      //       dataType: DataType.artists));
      // }
      // if (responses[2].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played genre',
      //       items: responses[2],
      //       dataType: DataType.genre));
      // }
      if (responses[1].isNotEmpty) {
        sections.add(Section(
            // heading: 'Trending albums',
            heading: AppLocalizations.of(context)!.trendingAlbums,
            items: responses[1],
            dataType: DataType.album));
      }
      // if (responses[4].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played songs',
      //       items: responses[4],
      //       dataType: DataType.songs));
      // }
      // if (responses[5].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most searched songs',
      //       items: responses[5],
      //       dataType: DataType.songs));
      // }
      // if (responses[6].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Trending playlists',
      //       items: responses[6],
      //       dataType: DataType.playlists));
      // }
      // if (responses[7].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Top searched artists',
      //       items: responses[7],
      //       dataType: DataType.artists));
      // }
      // if (responses[8].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played playlists',
      //       items: responses[8],
      //       dataType: DataType.playlists));
      // }
      if (responses[2].isNotEmpty) {
        sections.add(Section(
            // heading: 'Most played albums',
            heading: AppLocalizations.of(context)!.mostPlayAlbum,
            items: responses[2],
            dataType: DataType.album));
      }
      // if (responses[9].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played albums',
      //       items: responses[9],
      //       dataType: DataType.genre));
      // }
      if (responses[3].isNotEmpty) {
        sections.add(Section(
            // heading: 'Genre',
            heading: AppLocalizations.of(context)!.genre,
            items: responses[3],
            dataType: DataType.genre));
      }
    } else {
      var responses = await Future.wait([
        // getMultipleArtistsByIds(
        //     artistsId: UserProfileManager().user!.followingArtists,
        //     genreId: genreId),//0
        // getRecentlyPlayedArtists(genreId: genreId),//1
        getRecentlyPlayedSongs(genreId: genreId), //2
        getTrendingSongs(genreId), //3
        // getTrendingArtists(genreId: genreId),//4
        getTrendingAlbums(genreId: genreId), //5
        // getTopSongs(genreId: genreId),//6
        // getTopSearchedSongs(genreId: genreId),//7
        // getTrendingPlaylists(genreId: genreId),//8
        // getTopSearchedArtists(genreId),//9
        // getTopPlaylists(genreId: genreId),//10
        getTopAlbums(genreId: genreId), //11
        getAllGenres(), //12
        getAllFreeSongs(),
      ]);

      // if (responses[0].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Favourite artists',
      //       items: responses[0],
      //       dataType: DataType.artists));
      // }
      // if (responses[1].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Recently played artists',
      //       items: responses[1],
      //       dataType: DataType.artists));
      // }
      if (responses[5].isNotEmpty &&
          UserProfileManager().user!.active_subscription.isEmpty) {
        sections.add(Section(
            // heading: 'Trending albums',
            heading: AppLocalizations.of(context)!.songsPreview,
            items: responses[5],
            dataType: DataType.freeSongs));
      }
      if (responses[0].isNotEmpty) {
        sections.add(Section(
            // heading: 'Recently played songs',
            heading: AppLocalizations.of(context)!.recentPlayedSong,
            items: responses[0],
            // genreId == null ? responses[2].toSet().toList() : responses[2],
            dataType: DataType.songs));
      }
      if (responses[1].isNotEmpty) {
        sections.add(Section(
            // heading: 'Trending songs',
            heading: AppLocalizations.of(context)!.trendingSong,
            items: responses[1],
            dataType: DataType.songs));
      }
      // if (responses[4].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Trending artists',
      //       items: responses[4],
      //       dataType: DataType.artists));
      // }
      if (responses[2].isNotEmpty) {
        sections.add(Section(
            // heading: 'Trending albums',
            heading: AppLocalizations.of(context)!.trendingAlbums,
            items: responses[2],
            dataType: DataType.album));
      }
      // if (responses[6].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played songs',
      //       items: responses[6],
      //       dataType: DataType.songs));
      // }
      // if (responses[7].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most searched songs',
      //       items: responses[7],
      //       dataType: DataType.songs));
      // }
      // if (responses[8].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Trending playlists',
      //       items: responses[8],
      //       dataType: DataType.playlists));
      // }
      // if (responses[9].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Top searched artists',
      //       items: responses[9],
      //       dataType: DataType.artists));
      // }
      // if (responses[10].isNotEmpty) {
      //   sections.add(Section(
      //       heading: 'Most played playlists',
      //       items: responses[10],
      //       dataType: DataType.playlists));
      // }
      if (responses[3].isNotEmpty) {
        sections.add(Section(
            // heading: 'Most played albums',
            heading: AppLocalizations.of(context)!.mostPlayAlbum,
            items: responses[3],
            dataType: DataType.album));
      }
      if (responses[4].isNotEmpty) {
        sections.add(Section(
            // heading: 'Genre',
            heading: AppLocalizations.of(context)!.genre,
            items: responses[4],
            dataType: DataType.genre));
      }
    }

    return sections;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    UserModel? user;
    await userCollection
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        user = UserModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return user;
  }

  Future<FirebaseResponse> insertPaidStatus(String userId) async {
    DocumentReference<Map<String, dynamic>> doc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    var json = {
      'freeTrialLeft': 1,
      'active_subscription': '',
      'lastUpdatedAt': FieldValue.serverTimestamp()
    };

    await doc.set(json).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updatePaidStatus(
    int status,
    DateTime? expiry,
    String subscribeVia,
    String subscribeDuration,
    DateTime? subscribeDate,
    int isExpired,
  ) async {
    DocumentReference<Map<String, dynamic>> userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);

    var subscriptionId = getRandString(10);

    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid);
    var freeTrialleft = 0;
    var expiryDate = expiry;
    await currentUserDoc.get().then((value) {
      var data = value.data() as Map;
      freeTrialleft = data['freeTrialLeft'];

      if (freeTrialleft > 0) {
        expiryDate?.add(const Duration(days: 7));
      }
      // print(freeTrialleft);
    });

    DocumentReference<Map<String, dynamic>> doc = FirebaseFirestore.instance
        .collection('subscriptions')
        .doc(subscriptionId);

    print(await userDoc.get());
    var json = {
      // 'isSubscribed': status,
      'end_date': expiryDate,
      'subscription_via': subscribeVia, // PLAY_STORE/APP_STORE/EFOREST
      'duration': subscribeDuration, // yearly, monthly
      'start_date': subscribeDate,
      'status': 'A',
      'last_updated': FieldValue.serverTimestamp(),
      'user_id': auth.currentUser!.uid,
      'txn_id': ''
    };

    var userJson = {
      'active_subscription': subscriptionId,
      'freeTrialLeft': freeTrialleft > 0 ? (freeTrialleft - 1) : freeTrialleft
    };

    await userDoc
        .update(userJson)
        .then((value) async => {
              await doc.set(json).then((value) {
                response = FirebaseResponse(true, null);
              }).catchError((error) {
                print(error);
                response = FirebaseResponse(false, error);
              })
            })
        .catchError((error) {
      print(error);
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  checkSubscriptionStatus(subscription) async {
    try {
      DocumentReference doc = subscriptions.doc(subscription);
      await doc.get().then((value) async {
        Map data = value.data() as Map;

        if (data['subscription_via'] != '' ||
            data['subscription_via'] != null) {
          UserProfileManager().user?.subscribeVia = data['subscription_via'];

          // print(UserProfileManager().user?.subscribeVia);
          if ((UserProfileManager().user?.subscribeVia == 'EFOREST_SEEDS' ||
              UserProfileManager().user?.subscribeVia == 'EF2_FRUITS')) {
            UserProfileManager().user?.expiryDate =
                DateFormat('dd-MM-yyyy').format((data['end_date'].toDate()));
            UserProfileManager().user?.subscribeStatus = data['status'];
          }
        }
      });
      return;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkIfShowSeedsPayment() async {
    try {
      DocumentReference doc = settings.doc('settings');
      return await doc.get().then((value) async {
        Map data = value.data() as Map;
        return data['showSeedsPayment'] as bool;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }
}
