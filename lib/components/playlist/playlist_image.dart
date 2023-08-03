import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistImage extends StatefulWidget {
  final PlaylistModel playlist;
  final double height;
  final double width;

  const PlaylistImage(
      {Key? key,
      required this.playlist,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  _PlaylistImageState createState() => _PlaylistImageState();
}

class _PlaylistImageState extends State<PlaylistImage> {
  List<SongModel> songsList = [];
  String playlistImage = '';
  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {
    songsList = [];
    playlistImage = '';
    songsList = await getIt<FirebaseManager>()
        .getMultipleSongsByIds(widget.playlist.songsId);
    if (songsList.isNotEmpty) {
      playlistImage = songsList[0].image;
    } else {}
    setState(() {
      playlistImage = playlistImage.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return playlistImage == ""
        ? SizedBox(height: 20, width: 20, child: Container()
            // ThemeIconWidget(
            //   ThemeIcon.fav,
            //   color: AppTheme.singleton.redColor,
            //   size: widget.height / 2,
            // ),
            // CachedNetworkImage(
            //   imageUrl: widget.playlist.image!,
            //   fit: BoxFit.cover,
            //   height: widget.height,
            //   width: widget.width,
            // ).round(20),
            )
        : SizedBox(
            height: widget.height,
            width: widget.width,
            child: CachedNetworkImage(
              imageUrl: playlistImage,
              fit: BoxFit.cover,
              height: widget.height,
              width: widget.width,
            ).round(10),
          );
    // FutureBuilder<String>(
    //     future:
    //         getIt<FirebaseManager>().playlistImage(widget.playlist.songsId),
    //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return SizedBox(height: widget.height, width: widget.width);
    //         default:
    //           if (snapshot.hasError) {
    //             return Container(
    //               color:
    //                   AppTheme.singleton.primaryBackgroundColor.lighten(),
    //               height: widget.height,
    //               width: widget.width,
    //               child: Center(
    //                   child: Text(
    //                 snapshot.data.toString(),
    //                 style: const TextStyle(color: Colors.white),
    //               )
    //                   // ThemeIconWidget(
    //                   //   ThemeIcon.fav,
    //                   //   color: AppTheme.singleton.redColor,
    //                   //   size: widget.height / 2,
    //                   // ),
    //                   ),
    //             );
    //           } else {
    //             return SizedBox(
    //               height: widget.height,
    //               width: widget.width,
    //               child: CachedNetworkImage(
    //                 imageUrl: snapshot.data!,
    //                 fit: BoxFit.cover,
    //                 height: widget.height,
    //                 width: widget.width,
    //               ).round(10),
    //             );
    //           }
    //       }
    //     });
  }
}
