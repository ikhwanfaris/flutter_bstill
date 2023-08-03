import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class DownloadSongPopup extends StatefulWidget {
  const DownloadSongPopup({Key? key}) : super(key: key);

  @override
  DownloadSongPopupState createState() => DownloadSongPopupState();
}

class DownloadSongPopupState extends State<DownloadSongPopup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 400,
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1506157786151-b8491531f063?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fG11c2ljfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 400,
              height: 250,
              color: AppTheme.singleton.primaryBackgroundColor.lighten(),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      AppLocalizations.of(context)!.downloadAppMessage,
                      style: TextStyles.h3Style.lightColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.downloadAppLongMessage,
                      style: TextStyles.body.subTitleColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/common/appstore.jpg',
                          width: 120,
                        ).ripple(() {
                          // html.window.open(AppConfig.iOSApplink, 'Musicy');
                        }),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          'assets/common/google_play_store.jpg',
                          width: 120,
                        ).ripple(() {
                          // html.window.open(AppConfig.androidApplink, 'Musicy');
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ).hp(20),
            )
          ],
        ),
      ).round(25),
    );
  }
}
