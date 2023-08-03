import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SelectFavArtists extends StatefulWidget {
  final bool? isFirstTimeLogin;

  const SelectFavArtists({Key? key, this.isFirstTimeLogin}) : super(key: key);

  @override
  SelectFavArtistsState createState() => SelectFavArtistsState();
}

class SelectFavArtistsState extends State<SelectFavArtists> {
  List<ArtistModel> allArtists = [];
  List<ArtistModel> selectedArtists = [];
  late bool isFirstTimeLogin;

  @override
  void initState() {
    isFirstTimeLogin = widget.isFirstTimeLogin ?? false;
    getAllArtists();
    super.initState();
  }

  getAllArtists() {
    getIt<FirebaseManager>().getAllArtists().then((artists) {
      setState(() {
        allArtists = artists;

        for (ArtistModel artist in allArtists) {
          if (UserProfileManager().user!.followingArtists.contains(artist.id)) {
            selectedArtists.add(artist);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.singleton.navigationBarColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isFirstTimeLogin == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Text(AppLocalizations.of(context)!.selectArtistYouLike,
                          style: TextStyles.h2Style.bold.lightColor),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BackNavBar(
                    title: AppLocalizations.of(context)?.selectArtistYouLike,
                    backTapHandler: () {
                      print("yes");
                      context.pop();
                    },
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 0, bottom: 20),
              itemCount: allArtists.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 0,
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return CircleArtistCard(
                  artist: allArtists[index],
                  isSelected: selectedArtists.contains(allArtists[index]),
                  selectionCallback: () {
                    setState(() {
                      if (selectedArtists.contains(allArtists[index])) {
                        selectedArtists.remove(allArtists[index]);
                      } else {
                        selectedArtists.add(allArtists[index]);
                      }
                    });
                  },
                );
              },
            ).hP16,
          ),
          // const Spacer(),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: FilledButtonType1(
              text: AppLocalizations.of(context)?.submit,
              isEnabled: true,
              onPress: () {
                updateFavArtists();
              },
            ),
          ).hP16,
          const SizedBox(
            height: 25,
          ),
        ],
      ).hP16,
    );
  }

  updateFavArtists() {
    getIt<FirebaseManager>()
        .updateFollowingArtist(selectedArtists.map((e) => e.id).toList())
        .then((value) {
      if (isFirstTimeLogin == true) {
        context.go('/');
      } else {
        UserProfileManager().refreshProfile();
        context.pop();
      }
    });
  }
}
