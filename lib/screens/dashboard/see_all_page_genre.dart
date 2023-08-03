import 'package:flutter/cupertino.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

import '../../components/genre/genre_card_see_all.dart';

class SeeAllPage extends StatefulWidget {
  final genre;
  final String title;
  const SeeAllPage({super.key, required this.genre, required this.title});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  List<GenreModel> genreModel = [];
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    setState(() {
      widget.genre['a'].toString();
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
                title: widget.genre['b'],
                backTapHandler: () {
                  Navigator.of(context).pop();
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.genre['a'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return PlayIconHoveringWidget(
                    child: GenreCardSeeAll(genre: widget.genre['a'][index]),
                    tapHandler: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        context.push(
                            '/searched_genre_music/${widget.genre['a'][index].id}',
                            extra: widget.genre['a'][index].name);
                      } else {
                        context.go('/account');
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
