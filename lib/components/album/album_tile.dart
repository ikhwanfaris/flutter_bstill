import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AlbumTile extends StatelessWidget {
  final AlbumModel album;

  const AlbumTile({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl:album.image,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ).circular,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(album.name, style: TextStyles.title.bold),
            Text('${album.songsId.length} songs', style: TextStyles.body.subTitleColor),
          ],
        ),
      ],
    );
  }
}