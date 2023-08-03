import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

Widget artistView(ArtistModel artist) {
  return Column(
    children: [
      CachedNetworkImage(imageUrl:artist.image, fit: BoxFit.cover, height: 80, width: 80)
          .circular,
      const SizedBox(
        height: 20,
      ),
      Text(
        artist.name,
        style: TextStyles.body.lightColor,
      )
    ],
  );
}

