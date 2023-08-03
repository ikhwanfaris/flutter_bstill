import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class GenreTile extends StatelessWidget {
  final GenreModel genre;

  const GenreTile({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl:genre.image,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ).circular,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(genre.name, style: TextStyles.title.bold),
            //Text('${album.songsId.length} songs', style: TextStyles.body.subTitleColor),
          ],
        ),
      ],
    );
  }
}