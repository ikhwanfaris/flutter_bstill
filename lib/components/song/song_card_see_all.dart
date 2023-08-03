import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SongCardSeeAll extends StatelessWidget {
  final SongModel song;
  final double? width;
  final bool isSubscribed;

  const SongCardSeeAll(
      {Key? key, required this.song, this.width, required this.isSubscribed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.topCenter, children: [
          Opacity(
            opacity: !isSubscribed ? 0.7 : 1,
            child: CachedNetworkImage(
              imageUrl: song.image,
              width: width ?? double.infinity,
              height: 130,
              fit: BoxFit.cover,
            ).round(10),
            // )
          ),
          !isSubscribed
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Icon(
                      Icons.lock,
                      color: AppTheme.singleton.fontColor,
                    ),
                  ))
              : Container()
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            song.name,
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
      ],
    );
  }
}
