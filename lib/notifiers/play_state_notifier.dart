import 'package:flutter/foundation.dart';

class PlayStateNotifier extends ValueNotifier<PlayStateState> {
  PlayStateNotifier() : super(_initialValue);
  static const _initialValue = PlayStateState.idle;
}

enum PlayStateState {
  paused,
  playing,
  loading,
  idle
}