import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;

  const PlaylistCard({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // AspectRatio(
            //   aspectRatio: 1,
            // child:
            SizedBox(
                width: 150,
                height: 150,
                child: Center(
                  child: PlaylistImage(
                    playlist: playlist,
                    height: 150,
                    width: 150,
                  ),
                )).alignCenter,
            // ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SizedBox(
                width: 100,
                child: Text(
                  playlist.name,
                  style: const TextStyle(
                    //overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
