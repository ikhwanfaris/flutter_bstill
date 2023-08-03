import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

enum SongActionType {
  play,
  playNext,
  likeSong,
  addToQueue,
  viewSongDetail,
  addToPlaylist,
  download,
  reportAbuse,
  removeFromPlaylist,
  sleepTimer,
  cancelTimer
}

class SongAction {
  String title;
  ThemeIcon icon;
  ThemeIcon selectedIcon;
  SongActionType actionType;
  bool isSelected;

  SongAction(
      {required this.title,
      required this.icon,
      required this.selectedIcon,
      required this.actionType,
      required this.isSelected});
}

class SongActionWidget extends StatefulWidget {
  const SongActionWidget({Key? key}) : super(key: key);

  @override
  _SongActionWidgetState createState() => _SongActionWidgetState();
}

class _SongActionWidgetState extends State<SongActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SongActionsManager {
  // This is Player Controller Page
  static List<SongAction> actionsForSong(SongModel song, context) {
    return [
      // SongAction(
      //     title: 'Play Next',
      //     icon: ThemeIcon.playNext,
      //     selectedIcon: ThemeIcon.playNext,
      //     actionType: SongActionType.playNext,
      //     isSelected: false),
      // SongAction(
      //     // title: song.isLiked == true ? 'Unlike Song' : 'Like Song',
      //     title: song.isLiked == true
      //         ? AppLocalizations.of(context)!.unlikeSong
      //         : AppLocalizations.of(context)!.likeSong,
      //     icon: ThemeIcon.fav,
      //     selectedIcon: ThemeIcon.favFilled,
      //     actionType: SongActionType.likeSong,
      //     isSelected: song.isLiked),

      SongAction(
          title: getIt<PlayerManager>().isPlaying() == true
              ? AppLocalizations.of(context)!.addToQueue
              : AppLocalizations.of(context)!.play,
          // title: getIt<PlayerManager>().isPlaying() == true
          //     ? AppLocalizations.of(context)!.addToQueue
          //     : AppLocalizations.of(context)!.play,
          //Error: Undefined name 'context'.
          icon: getIt<PlayerManager>().isPlaying() == true
              ? ThemeIcon.addToQueue
              : ThemeIcon.play,
          selectedIcon: ThemeIcon.addToQueue,
          actionType: getIt<PlayerManager>().isPlaying() == true
              ? SongActionType.addToQueue
              : SongActionType.play,
          isSelected: false),
      // SongAction(
      //     title: 'Copy to Clipboard',
      //     icon: ThemeIcon.copyToClipboard,
      //     selectedIcon: ThemeIcon.copyToClipboard,
      //     actionType: SongActionType.copyToClipboard,
      //     isSelected: false),
      // SongAction(
      //     title: 'View Song Detail',
      //     icon: ThemeIcon.reveal,
      //     selectedIcon: ThemeIcon.reveal,
      //     actionType: SongActionType.viewSongDetail,
      //     isSelected: false),
      SongAction(
          title: AppLocalizations.of(context)!.addToPlaylist,
          icon: ThemeIcon.addToPlaylist,
          selectedIcon: ThemeIcon.addToPlaylist,
          actionType: SongActionType.addToPlaylist,
          isSelected: false),
      // SongAction(
      //     title: getIt<PlayerManager>().timerActivated
      //         ? AppLocalizations.of(context)!.cancelTimer
      //         : AppLocalizations.of(context)!.sleepTimer,
      //     icon: ThemeIcon.addToPlaylist,
      //     selectedIcon: ThemeIcon.addToPlaylist,
      //     actionType: getIt<PlayerManager>().timerActivated
      //         ? SongActionType.cancelTimer
      //         : SongActionType.sleepTimer,
      //     isSelected: false),
      // SongAction(
      //     title: 'Remove from Playlist',
      //     icon: ThemeIcon.delete,
      //     selectedIcon: ThemeIcon.delete,
      //     actionType: SongActionType.removeFromPlaylist,
      //     isSelected: false),
      // SongAction(
      //     title: 'Download',
      //     icon: ThemeIcon.download,
      //     selectedIcon: ThemeIcon.download,
      //     actionType: SongActionType.download,
      //     isSelected: false),
      // SongAction(
      //     title: 'Report Abuse',
      //     icon: ThemeIcon.report,
      //     selectedIcon: ThemeIcon.report,
      //     actionType: SongActionType.reportAbuse,
      //     isSelected: false),
    ];
  }

  // This is Liked Song Page
  static List<SongAction> actionsForLikedSong(SongModel song, context) {
    return [
      // SongAction(
      //     title: 'Play Next',
      //     icon: ThemeIcon.playNext,
      //     selectedIcon: ThemeIcon.playNext,
      //     actionType: SongActionType.playNext,
      //     isSelected: false),
      SongAction(
          // title: song.isLiked == true ? 'Unlike Song' : 'Like Song',
          title: song.isLiked == true
              ? AppLocalizations.of(context)!.unlikeSong
              : AppLocalizations.of(context)!.likeSong,
          icon: ThemeIcon.fav,
          selectedIcon: ThemeIcon.favFilled,
          actionType: SongActionType.likeSong,
          isSelected: song.isLiked),
      SongAction(
          title: getIt<PlayerManager>().isPlaying() == true
              ? LocalizationString.addToQueue
              : LocalizationString.play,
          // title: getIt<PlayerManager>().isPlaying() == true
          //     ? AppLocalizations.of(context)!.addToQueue
          //     : AppLocalizations.of(context)!.play,
          //Error: Undefined name 'context'.
          icon: getIt<PlayerManager>().isPlaying() == true
              ? ThemeIcon.addToQueue
              : ThemeIcon.play,
          selectedIcon: ThemeIcon.addToQueue,
          actionType: getIt<PlayerManager>().isPlaying() == true
              ? SongActionType.addToQueue
              : SongActionType.play,
          isSelected: false),
      // SongAction(
      //     title: AppLocalizations.of(context)!.sleepTimer,
      //     icon: ThemeIcon.addToPlaylist,
      //     selectedIcon: ThemeIcon.addToPlaylist,
      //     actionType: SongActionType.sleepTimer,
      //     isSelected: false),
      // SongAction(
      //     title: 'Copy to Clipboard',
      //     icon: ThemeIcon.copyToClipboard,
      //     selectedIcon: ThemeIcon.copyToClipboard,
      //     actionType: SongActionType.copyToClipboard,
      //     isSelected: false),
      // SongAction(
      //     title: 'View Song Detail',
      //     icon: ThemeIcon.reveal,
      //     selectedIcon: ThemeIcon.reveal,
      //     actionType: SongActionType.viewSongDetail,
      //     isSelected: false),
      // SongAction(
      //     title: 'Add to Playlist',
      //     icon: ThemeIcon.addToPlaylist,
      //     selectedIcon: ThemeIcon.addToPlaylist,
      //     actionType: SongActionType.addToPlaylist,
      //     isSelected: false),
      // SongAction(
      //     title: 'Remove from Playlist',
      //     icon: ThemeIcon.delete,
      //     selectedIcon: ThemeIcon.delete,
      //     actionType: SongActionType.removeFromPlaylist,
      //     isSelected: false),
      // SongAction(
      //     title: 'Download',
      //     icon: ThemeIcon.download,
      //     selectedIcon: ThemeIcon.download,
      //     actionType: SongActionType.download,
      //     isSelected: false),
      // SongAction(
      //     title: 'Report Abuse',
      //     icon: ThemeIcon.report,
      //     selectedIcon: ThemeIcon.report,
      //     actionType: SongActionType.reportAbuse,
      //     isSelected: false),
    ];
  }

  static List<SongAction> actionsForSongFromPlylist(SongModel song, context) {
    return [
      // SongAction(
      //     title: 'Play Next',
      //     icon: ThemeIcon.playNext,
      //     selectedIcon: ThemeIcon.playNext,
      //     actionType: SongActionType.playNext,
      //     isSelected: false),
      SongAction(
          title: song.isLiked == true
              ? AppLocalizations.of(context)!.unlikeSong
              : AppLocalizations.of(context)!.likeSong,
          // title: song.isLiked == true ? AppLocalizations.of(context)?.unlikeSong: AppLocalizations.of(context).likeSong,
          icon: ThemeIcon.fav,
          selectedIcon: ThemeIcon.favFilled,
          actionType: SongActionType.likeSong,
          isSelected: song.isLiked),

      SongAction(
          title: getIt<PlayerManager>().isPlaying() == true
              ? LocalizationString.addToQueue
              : LocalizationString.play,
          // title: getIt<PlayerManager>().isPlaying() == true
          //     ? AppLocalizations.of(context)!.addToQueue
          //     : AppLocalizations.of(context)!.play,
          icon: getIt<PlayerManager>().isPlaying() == true
              ? ThemeIcon.addToQueue
              : ThemeIcon.play,
          selectedIcon: ThemeIcon.addToQueue,
          actionType: getIt<PlayerManager>().isPlaying() == true
              ? SongActionType.addToQueue
              : SongActionType.play,
          isSelected: false),
      // SongAction(
      //     title: AppLocalizations.of(context)!.sleepTimer,
      //     icon: ThemeIcon.addToPlaylist,
      //     selectedIcon: ThemeIcon.addToPlaylist,
      //     actionType: SongActionType.sleepTimer,
      //     isSelected: false),
      // SongAction(
      //     title: 'Copy to Clipboard',
      //     icon: ThemeIcon.copyToClipboard,
      //     selectedIcon: ThemeIcon.copyToClipboard,
      //     actionType: SongActionType.copyToClipboard,
      //     isSelected: false),
      // SongAction(
      //     title: 'View Song Detail',
      //     icon: ThemeIcon.reveal,
      //     selectedIcon: ThemeIcon.reveal,
      //     actionType: SongActionType.viewSongDetail,
      //     isSelected: false),
      // SongAction(
      //     title: 'Add to Playlist',
      //     icon: ThemeIcon.addToPlaylist,
      //     selectedIcon: ThemeIcon.addToPlaylist,
      //     actionType: SongActionType.addToPlaylist,
      //     isSelected: false),
      // SongAction(
      //     title: song.isLiked == true
      //         ? AppLocalizations.of(context)!.unlikeSong
      //         : AppLocalizations.of(context)!.likeSong,
      //     // title: AppLocalizations.of(context)?.removeFromPlayList,
      //     icon: ThemeIcon.delete,
      //     selectedIcon: ThemeIcon.delete,
      //     actionType: SongActionType.removeFromPlaylist,
      //     isSelected: false),
      // SongAction(
      //     title: 'Download',
      //     icon: ThemeIcon.download,
      //     selectedIcon: ThemeIcon.download,
      //     actionType: SongActionType.download,
      //     isSelected: false),
      // SongAction(
      //     title: 'Report Abuse',
      //     icon: ThemeIcon.report,
      //     selectedIcon: ThemeIcon.report,
      //     actionType: SongActionType.reportAbuse,
      //     isSelected: false),
    ];
  }
}
