import 'package:flutter/foundation.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SongChangeNotifier extends ValueNotifier<PlayingMediaModel?> {
  SongChangeNotifier() : super(_initialValue);
  static const _initialValue = null;
}