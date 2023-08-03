import 'package:flutter/cupertino.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

import '../../components/song/song_card_see_all.dart';

class SeeAllPageSongs extends StatefulWidget {
  final songs;
  final String title;
  final bool isSubscribed;

  const SeeAllPageSongs(
      {super.key,
      required this.songs,
      required this.title,
      required this.isSubscribed});

  @override
  State<SeeAllPageSongs> createState() => _SeeAllPageSongsState();
}

class _SeeAllPageSongsState extends State<SeeAllPageSongs> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    setState(() {
      widget.songs['a'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-m-3.png'),
            // opacity: 0.7,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            BackNavBar(
                centerTitle: true,
                title: widget.songs['b'],
                backTapHandler: () {
                  Navigator.of(context).pop();
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.songs['a'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return PlayIconHoveringWidget(
                    child: SongCardSeeAll(
                      song: widget.songs['a'][index],
                      width: 200,
                      isSubscribed: widget.songs['isSubscribed'],
                    ),
                    tapHandler: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        widget.songs['isSubscribed'] == true
                            ? await getIt<PlayerManager>().updatePlaylist(
                                songs: widget.songs['a'],
                                currentSong: widget.songs['a'][index])
                            : GFToast.showToast(
                                AppLocalizations.of(context)?.subscribeToUse,
                                context,
                                toastPosition: GFToastPosition.TOP,
                                textStyle: TextStyles.body.white,
                                backgroundColor: AppTheme().fontColor,
                              );
                      } else {
                        if (widget.songs['isSubscribed'] == true) {
                          await getIt<PlayerManager>().updatePlaylist(
                              songs: widget.songs['a'],
                              currentSong: widget.songs['a'][index]);
                        } else {
                          context.go('/account');
                        }
                      }
                    },
                  );
                },
              ).p25,
            )
          ],
        ),
      ),
    );
  }
}
