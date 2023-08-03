import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SongCard extends StatelessWidget {
  final SongModel song;
  final double? width;
  final bool isSubscribed;

  const SongCard(
      {Key? key, required this.song, this.width, required this.isSubscribed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Opacity(
                  opacity: !isSubscribed ? 0.7 : 1,
                  child: CachedNetworkImage(
                    imageUrl: song.image,
                    width: width ?? double.infinity,
                    fit: BoxFit.cover,
                  ).round(10),
                )),
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
            // Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: Container(
            //       height: 50,
            //       color: AppTheme.singleton.grey.darken(0.25),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             song.name,
            //             style: TextStyles.title.bold.lightColor,
            //             textAlign: TextAlign.center,
            //             maxLines: 1,
            //           ),
            //           Text(
            //             song.artistsName.first,
            //             style: TextStyles.body,
            //             textAlign: TextAlign.center,
            //             maxLines: 1,
            //           ),
            //         ],
            //       ),
            //     ).bottomRounded(10))
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
