import 'package:flutter/foundation.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistChangeNotifier extends ValueNotifier<List<PlayingMediaModel>> {
  PlaylistChangeNotifier() : super(_initialValue);
  static final _initialValue = [
    PlayingMediaModel(id: '', name: '', artistName: '', image: '',allArtists: [])
  ];
}
