import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class GenreCard extends StatelessWidget {
  final GenreModel genre;

  const GenreCard({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: genre.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ).round(10),
            ),
            // Text(
            //   album.name,
            //   style: TextStyles.title.bold.lightColor,
            //   maxLines: 1,
            //   textAlign: TextAlign.center,
            // ),
            // Positioned(
            //     bottom: 0,
            //     left: 0,
            //     right: 0,
            //     child: Container(
            //       color: AppTheme.singleton.grey.darken(0.25),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Text(
            //             album.name,
            //             style: TextStyles.title.bold.lightColor,
            //             maxLines: 1,
            //             textAlign: TextAlign.center,
            //           ),
            //           Text('${album.songsId.length} ${AppLocalizations.of(context)?.songs}',
            //               style: TextStyles.body.subTitleColor),
            //         ],
            //       ).setPadding(left: 4, right: 4, top: 8, bottom: 8),
            //     ).bottomRounded(10)
            //   )
          ],
        ),
        // Expanded(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(top: 10.0),
        //         child: SizedBox(
        //           width: 100,
        //           height: 100,
        //           child: Text(
        //             genre.name,
        //             style: const TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 13,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             maxLines: 1,
        //             textAlign: TextAlign.center,
        //           ),
        //         ),
        //       ),
        //       // Text('${album.songsId.length} ${AppLocalizations.of(context)?.songs}',
        //       //   // style: TextStyles.body.subTitleColor),
        //       // ),
        //     ],
        //   ),
        // ),
      ],
    ).round(10);
  }
}
