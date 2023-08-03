import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class Artists extends StatefulWidget {
  final MenuType menuType;

  const Artists({Key? key, required this.menuType}) : super(key: key);

  @override
  ArtistsState createState() => ArtistsState();
}

class ArtistsState extends State<Artists> {
  TextEditingController search = TextEditingController();
  List<ArtistModel> artists = [];

  @override
  void initState() {
    getAllArtists();
    super.initState();
  }

  String heading() {
    switch (widget.menuType) {
      case MenuType.followedArtists:
        return AppLocalizations.of(context)!.followedPlaylists;
      default:
        return AppLocalizations.of(context)!.allPlaylists;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppTheme.singleton.primaryBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DashboardNavigationBar().vP25,
            Text(
              heading(),
              style: TextStyles.h1Style.lightColor.bold,
            ),
            const Divider(
              height: 50,
            ),
            Container(
              color: AppTheme.singleton.themeColor.withOpacity(0.05),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: artists.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return HoveringWidget(
                    child: ArtistCard(artist: artists[index]),
                    tapHandler: () {
                      context.go('/artist_detail/${artists[index].id}',
                          extra: 1);
                    },
                  );
                },
              ).p25,
            ).round(20),
          ],
        ),
      ).hP50,
    );
  }

  getAllArtists() {
    List<String> artistsIds = UserProfileManager().user?.followingArtists ?? [];

    getIt<FirebaseManager>()
        .getMultipleArtistsByIds(artistsId: artistsIds)
        .then((result) {
      artists = result;
      setState(() {});
    });
  }
}

class ArtistHeader extends StatelessWidget {
  final List<String> headers;

  const ArtistHeader({Key? key, required this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppTheme().themeColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (String header in headers) Text(header)],
      ).hP16,
    ).round(5);
  }
}
