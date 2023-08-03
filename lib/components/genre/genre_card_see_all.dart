import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class GenreCardSeeAll extends StatelessWidget {
  final GenreModel genre;

  const GenreCardSeeAll({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: genre.image,
          width: double.infinity,
          height: 130,
          fit: BoxFit.cover,
        ).round(10),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            genre.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ).round(10);
  }
}
