import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:flutter/material.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        ThemeIconWidget icon;
        switch (value) {
          case RepeatState.off:
            icon = ThemeIconWidget(
              ThemeIcon.repeat,
              color: AppTheme.singleton.lightColor,
              size: 25,
            );
            break;
          case RepeatState.repeatSong:
            icon = ThemeIconWidget(
              ThemeIcon.repeat_one,
              color: AppTheme.singleton.lightColor,
              size: 25,
            );
            break;
          case RepeatState.repeatPlaylist:
            icon = ThemeIconWidget(
              ThemeIcon.repeat,
              color: AppTheme.singleton.lightColor,
              size: 25,
            );
            break;
        }
        // return icon
        //     .ripple(
        //       () => pageManager.repeat,
        //     )
        //     .setPadding(top: 5, left: 5, right: 5, bottom: 5);
        return IconButton(
          constraints: BoxConstraints(),
          icon: icon,
          onPressed: pageManager.repeat,
          padding: const EdgeInsets.all(5),
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return ThemeIconWidget(
          ThemeIcon.prev,
          color: isFirst == true
              ? AppTheme.singleton.mediumLightColor
              : AppTheme.singleton.lightColor,
          size: 50,
        ).ripple(() {
          isFirst == true ? null : pageManager.previous();
          final repeatPlaylist = pageManager.repeatButtonNotifier.value;
          // print(isFirst.toString() + 'Previous Song is');
          if (repeatPlaylist.toString() == "RepeatState.repeatSong") {
            pageManager.previousShuffle();
          }
        });
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  final double size;

  const PlayButton({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return size == 40
                ? Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 32.0,
                    height: 32.0,
                    child: const CircularProgressIndicator(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(135, 154, 210, 1),
                      border: Border.all(
                        color: const Color.fromRGBO(135, 154, 210, 1),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                          topLeft: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0)),
                    ),
                    child: ThemeIconWidget(
                      ThemeIcon.pause,
                      color: AppTheme.singleton.lightColor,
                      size: size,
                    ).ripple(() {
                      pageManager.pause();
                    }));
          case ButtonState.paused:
            return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(135, 154, 210, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(135, 154, 210, 1),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: ThemeIconWidget(
                  ThemeIcon.play,
                  color: AppTheme.singleton.lightColor,
                  size: size,
                ).ripple(() {
                  pageManager.play();
                }));
          default:
            return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(135, 154, 210, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(135, 154, 210, 1),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: ThemeIconWidget(
                  ThemeIcon.pause,
                  color: AppTheme.singleton.lightColor,
                  size: size,
                ).ripple(() {
                  pageManager.pause();
                }));
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return ThemeIconWidget(
          ThemeIcon.next,
          color: isLast == true
              ? AppTheme.singleton.mediumLightColor
              : AppTheme.singleton.lightColor,
          size: 50,
        ).ripple(() {
          final repeatPlaylist = pageManager.repeatButtonNotifier.value;
          if (repeatPlaylist.toString() == "RepeatState.repeatSong") {
            pageManager.nextShuffle();
          }

          isLast == true ? null : pageManager.next();
        });
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: ThemeIconWidget(
            ThemeIcon.shuffle,
            color: isEnabled == true
                ? AppTheme.singleton.lightColor
                : AppTheme.singleton.mediumLightColor,
            size: 25,
          ),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
