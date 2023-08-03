import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistModel playlist;

  const PlaylistTile({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PlaylistImage(
          playlist: playlist,
          height: 50,
          width: 50,
        ).circular,

        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(playlist.name, style: TextStyles.title.bold),
            Text('${playlist.songsId.length} songs',
                style: TextStyles.body.subTitleColor),
          ],
        ),
      ],
    );
  }
}
