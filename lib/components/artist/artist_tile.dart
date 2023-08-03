import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class ArtistHorizontalTile extends StatelessWidget {
  final ArtistModel artist;

  const ArtistHorizontalTile({Key? key, required this.artist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: artist.image,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ).circular,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(artist.name, style: TextStyles.title.bold),
            // Text('${artist.albums} albums', style: TextStyles.body.subTitleColor),
            // Text('10 albums', style: TextStyles.body.subTitleColor),
          ],
        ),
      ],
    );
  }
}

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;

  const ArtistCard({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: artist.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ).round(10)),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppTheme.singleton.fontColor,
                  child: Column(
                    children: [
                      Text(artist.name, style: TextStyles.title.bold),
                      Text(
                          '${artist.totalAlbums} albums | ${artist.totalSongs} songs',
                          style: TextStyles.body.subTitleColor),
                    ],
                  ).setPadding(left: 4, right: 4, top: 8, bottom: 8),
                ).bottomRounded(10))
          ],
        )
      ],
    ).round(10);
  }
}

class CircleArtistCard extends StatefulWidget {
  final ArtistModel artist;
  final bool isSelected;
  final VoidCallback? selectionCallback;

  const CircleArtistCard(
      {Key? key,
      required this.artist,
      required this.isSelected,
      this.selectionCallback})
      : super(key: key);

  @override
  CircleArtistCardState createState() => CircleArtistCardState();
}

class CircleArtistCardState extends State<CircleArtistCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: widget.artist.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ).circular),
                Text(
                  widget.artist.name,
                  //style: TextStyles.title.bold,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ).tP8,
              ],
            ),
            widget.isSelected == true
                ? Positioned(
                    child: ThemeIconWidget(
                    ThemeIcon.filledCheckMark,
                    color: AppTheme.singleton.fontColor,
                    size: 25,
                  ))
                : Container()
          ],
        ).ripple(() {
          // if(widget.selectionCallback != null){
          widget.selectionCallback!();
          // }
        })
      ],
    );
  }
}
