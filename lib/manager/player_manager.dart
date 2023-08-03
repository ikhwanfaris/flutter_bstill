import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final currentSongChangeNotifier = SongChangeNotifier();
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final playlistMediaNotifier = ValueNotifier<List<PlayingMediaModel>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final playStateNotifier = ValueNotifier<bool>(false);
  final currentSongIndex = ValueNotifier<num>(0);
  final _audioHandler = getIt<AudioHandler>();
  var timerActivated = false;

  String lastListenSongId = '';

  // Events: Calls coming from the UI
  void init() {
    addPlaylist([]);
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    // _listenToListenedSong();
    _listenToCurrentSongIndex();
  }

  closePlayer() {
    _audioHandler.pause();

    // _audioHandler.customAction('dispose');
    playStateNotifier.value = false;
    // removeAll();
    _audioHandler.stop();
  }

  bool isPlaying() {
    return _audioHandler.queue.value.isNotEmpty;
  }

  List<PlayingMediaModel> currentPlaylistMedia() {
    final playingMediaList = _audioHandler.queue.value
        .map((e) => PlayingMediaModel(
            id: e.id,
            name: e.title,
            artistName:
                (e.extras?['artistsName'] as List<String>? ?? ['loading'])
                    .first,
            image: e.extras?['image'] ?? '',
            allArtists: e.extras?['artistsId'] ?? []))
        .toList();

    return playingMediaList;
  }

  Future<void> addPlaylist(List<SongModel> songs) async {
    final mediaItems = songs
        .map((song) => MediaItem(
            id: song.id,
            album: song.artistsName.first,
            title: song.name,
            extras: song.toJson(),
            artist: song.artistsName.first,
            artUri: Uri.parse(song.image)))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  Future<void> addPlaylistandPaly(SongModel songs) async {
    skipToQueueItem(songs.id);
    Timer(const Duration(seconds: 1), () {
      play();
    });
  }

  Future<void> updatePlaylist(
      {required List<SongModel> songs, required SongModel? currentSong}) async {
    pause();
    List<PlayingMediaModel> allSongs = [];
    allSongs = getIt<PlayerManager>().currentPlaylistMedia();
    // print("allSongs.isNotEmpty");
    // print(allSongs.isNotEmpty);
    final index = _audioHandler.queue.value
        .indexWhere((element) => element.id == currentSong?.id);
    // print("index 1 " + index.toString());
    if (allSongs.isNotEmpty && index != -1) {
      // print("allSongs.isNotEmpty");
      if (currentSong != null) {
        // print("currentSong != null");
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("SONG INDEX IN PLAYLIST");
        // print(index);
        Timer(const Duration(microseconds: 500), () {
          // print("_audioHandler.skipToQueueItem(index) if ");
          _audioHandler.skipToQueueItem(index);
        });
      }
    } else {
      // print("else");
      allSongs = getIt<PlayerManager>().currentPlaylistMedia();
      // for (var i = 0; i < allSongs.length; i++) {
      //   print(allSongs[i].id);
      // }
      removeAll();
      // print(currentSong);
      // print(currentSong!.id);

      final mediaItems = songs
          .map((song) => MediaItem(
              id: song.id,
              album: song.artistsName.first,
              title: song.name,
              extras: song.toJson(),
              artist: song.artistsName.first,
              artUri: Uri.parse(song.image)))
          .toList();

      await _audioHandler.addQueueItems(mediaItems);
      allSongs = getIt<PlayerManager>().currentPlaylistMedia();
      // for (var i = 0; i < allSongs.length; i++) {
      //   print(allSongs[i].id);
      // }

      if (currentSong != null) {
        // print("currentSong != null");
        // print(currentSong);
        // print(currentSong.id);
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index1 = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("else SONG INDEX IN PLAYLIST");

        Timer(const Duration(milliseconds: 500), () {
          _audioHandler.skipToQueueItem(index1);
          // print("_audioHandler.skipToQueueItem(index) else ");
        });
      }
    }

    Timer(const Duration(milliseconds: 1000), () {
      play();
    });
  }

  Future<void> updatePlaylist2(
      {required List<SongModel> songs, required SongModel? currentSong}) async {
    removeAll();

    final mediaItems = songs
        .map((song) => MediaItem(
            id: song.id,
            album: song.artistsName.first,
            title: song.name,
            extras: song.toJson(),
            artist: song.artistsName.first,
            artUri: Uri.parse(song.image)))
        .toList();

    await _audioHandler.addQueueItems(mediaItems);
    // for (var i = 0; i < allSongs.length; i++) {
    //   print(allSongs[i].id);
    // }

    if (currentSong != null) {
      final index1 = _audioHandler.queue.value
          .indexWhere((element) => element.id == currentSong.id);

      // print(index1);
      // Timer(const Duration(milliseconds: 500), () {

      _audioHandler.skipToQueueItem(index1);
      // print("_audioHandler.skipToQueueItem(index) else ");
      // });
    }

    Timer(const Duration(milliseconds: 1), () {
      play();
    });
  }

  Future<void> updatePlaylistAndPlay(
      {required List<SongModel> songs, required SongModel? currentSong}) async {
    List<PlayingMediaModel> allSongs = [];
    allSongs = getIt<PlayerManager>().currentPlaylistMedia();
    // print("allSongs.isNotEmpty");
    // print(allSongs.isNotEmpty);
    if (allSongs.isNotEmpty) {
      if (currentSong != null) {
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("SONG INDEX IN PLAYLIST");
        // print(index);
        Timer(const Duration(microseconds: 1), () {
          _audioHandler.skipToQueueItem(index);
        });
        Timer(const Duration(microseconds: 2), () {
          play();
        });
      }
    } else {
      removeAll();
      // print(currentSong);
      // print(currentSong!.id);

      final mediaItems = songs
          .map((song) => MediaItem(
              id: song.id,
              album: song.artistsName.first,
              title: song.name,
              extras: song.toJson(),
              artist: song.artistsName.first,
              artUri: Uri.parse(song.image)))
          .toList();

      await _audioHandler.addQueueItems(mediaItems);

      if (currentSong != null) {
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("SONG INDEX IN PLAYLIST");
        // print(index);
        Timer(const Duration(milliseconds: 500), () {
          _audioHandler.skipToQueueItem(index);
        });
      }
    }

    Timer(const Duration(milliseconds: 500), () {
      play();
    });
  }

  Future<void> emptyPlaylistAndPlayPlaylist(
      {required List<SongModel> songs, required SongModel? currentSong}) async {
    List<PlayingMediaModel> allSongs = [];
    allSongs = getIt<PlayerManager>().currentPlaylistMedia();
    // print("allSongs.isNotEmpty");
    // print(allSongs.isNotEmpty);
    if (allSongs.isNotEmpty == true) {
      removeAll();
      // print(currentSong);
      // print(currentSong!.id);

      final mediaItems = songs
          .map((song) => MediaItem(
              id: song.id,
              album: song.artistsName.first,
              title: song.name,
              extras: song.toJson(),
              artist: song.artistsName.first,
              artUri: Uri.parse(song.image)))
          .toList();

      await _audioHandler.addQueueItems(mediaItems);

      if (currentSong != null) {
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("SONG INDEX IN PLAYLIST");
        // print(index);
        Timer(const Duration(milliseconds: 500), () {
          _audioHandler.skipToQueueItem(index);
        });
      }
    } else {
      removeAll();
      // print(currentSong);
      // print(currentSong!.id);

      final mediaItems = songs
          .map((song) => MediaItem(
              id: song.id,
              album: song.artistsName.first,
              title: song.name,
              extras: song.toJson(),
              artist: song.artistsName.first,
              artUri: Uri.parse(song.image)))
          .toList();

      await _audioHandler.addQueueItems(mediaItems);

      if (currentSong != null) {
        // print("currentSong NOT NULL");
        // print("mediaId");
        // print(currentSong.id);
        final index = _audioHandler.queue.value
            .indexWhere((element) => element.id == currentSong.id);
        // print("SONG INDEX IN PLAYLIST");
        // print(index);
        Timer(const Duration(milliseconds: 500), () {
          _audioHandler.skipToQueueItem(index);
        });
      }
    }

    Timer(const Duration(milliseconds: 500), () {
      play();
    });
  }

  void _listenToChangesInPlaylist() {
    print("_listenToChangesInPlaylist");
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        // currentSongTitleNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    print("_listenToPlaybackState");
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
        playStateNotifier.value = true;
      } else {
        _audioHandler.seek(Duration.zero);
        // _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentSongIndex() {
    print("_listenToCurrentSongIndex");
    String a = "";
    // Song played currently
    _audioHandler.mediaItem.listen((mediaItem) {
      // print("now playing");
      // print(mediaItem?.title.toString());

      if (mediaItem!.title.toString() != "null") {
        a = mediaItem.title.toString();
        // print(a);
      }
    });

    //All song in queue
    _audioHandler.queue.listen((List<MediaItem> queue) {
      for (var i = 0; i < queue.length; i++) {
        if (queue[i].title == a) {
          // print("i.toString()");
          // print(i.toString());
          currentSongIndex.value = i;
          // print(" currentSongIndex.value");
          // print(currentSongIndex.value.toString());
          //pause();

          Timer(const Duration(seconds: 1), () {
            play();
            //   playlistMediaNotifier.value =
            //       getIt<PlayerManager>().currentPlaylistMedia();
          });
        }
      }
    });
  }

  void _listenToCurrentPosition() {
    print("_listenToCurrentPosition");
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    print("_listenToBufferedPosition");
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    print("_listenToTotalDuration");
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    print("_listenToChangesInSong");
    _audioHandler.mediaItem.listen((mediaItem) {
      final song = PlayingMediaModel(
        id: mediaItem?.id ?? '',
        name: mediaItem?.title ?? '',
        artistName:
            (mediaItem?.extras?['artistsName'] as List<String>? ?? ['loading'])
                .first,
        image: mediaItem?.extras?['image'] ?? '',
        allArtists: mediaItem?.extras?['artistsId'] ?? [],
      );
      currentSongChangeNotifier.value = song; //?.title ?? '';

      if (lastListenSongId != song.id) {
        // increase song stream count
        getIt<FirebaseManager>()
            .increaseSongListener(SongModel.fromJson(mediaItem!.extras!));
        lastListenSongId = song.id;

        //test remove
        // final index = _audioHandler.queue.value
        //     .indexWhere((element) => element.id == song.id);
        // _audioHandler.removeQueueItemAt(index);
      }
      // print("_listenToChangesInSong");
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    final repeatPlaylist = repeatButtonNotifier.value;

    if (repeatPlaylist == RepeatState.repeatPlaylist) {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = false;
    } else if (repeatPlaylist == RepeatState.repeatSong) {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = false;
    } else if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();

  void next() => _audioHandler.skipToNext();

  void nextShuffle() {
    print("skipp");
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    _audioHandler.skipToNext();
    //_audioHandler.skipToPrevious();
    Timer(const Duration(microseconds: 10), () {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    });
  }

  void previousShuffle() {
    print("previous");
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    //_audioHandler.skipToNext();
    _audioHandler.skipToPrevious();
    Timer(const Duration(microseconds: 10), () {
      _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    });
  }

  void playspecificSong(String mediaId) {
    // final index = _audioHandler.queue.value
    //     .indexWhere((element) => element.id == mediaId);
    // print("index");
    // print(index);
    _audioHandler.playFromMediaId(mediaId);
    Timer(const Duration(seconds: 1), () {
      play();
    });
  }

  void skipToQueueItem(String mediaId) {
    // print("mediaId");
    // print(mediaId);
    final index = _audioHandler.queue.value
        .indexWhere((element) => element.id == mediaId);
    // print("SONG INDEX IN PLAYLIST");
    // print(index);
    _audioHandler.skipToQueueItem(index);
  }

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        _updateSkipButtons();
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add(SongModel song) async {
    final mediaItem = MediaItem(
        id: song.id,
        album: song.artistsName.first,
        title: song.name,
        extras: song.toJson(),
        artist: song.artist?.name,
        artUri: Uri.parse(song.image));
    _audioHandler.addQueueItem(mediaItem);
  }

  void removeMedia(PlayingMediaModel media) {
    final index = _audioHandler.queue.value
        .indexWhere((element) => element.id == media.id);
    _audioHandler.removeQueueItemAt(index);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void removeAll() {
    while (_audioHandler.queue.value.isNotEmpty) {
      final lastIndex = _audioHandler.queue.value.length - 1;
      if (lastIndex < 0) return;
      _audioHandler.removeQueueItemAt(lastIndex);
    }
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
