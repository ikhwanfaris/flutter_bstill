import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SavePlaylist extends StatefulWidget {
  final VoidCallback playlistSaved;
  final PlaylistModel? playlist;

  const SavePlaylist({Key? key, required this.playlistSaved, this.playlist})
      : super(key: key);

  @override
  _SavePlaylistState createState() => _SavePlaylistState();
}

class _SavePlaylistState extends State<SavePlaylist> {
  TextEditingController playlistTf = TextEditingController();

  @override
  void initState() {
    if (widget.playlist != null) {
      playlistTf.text = widget.playlist!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        color: AppTheme.singleton.primaryBackgroundColor.lighten(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.playlist == null
                  ? AppLocalizations.of(context)!.createNewPlaylist
                  : AppLocalizations.of(context)!.updatePlaylist,
              style: TextStyles.title.bold.lightColor,
            ),
            Container(
              height: 0.2,
              width: double.infinity,
              color: AppTheme.singleton.dividerColor,
            ).vP16,
            Container(
              color: AppTheme.singleton.primaryBackgroundColor,
              child: InputField(
                textStyle: TextStyles.body.lightColor,
                controller: playlistTf,
                hintText: AppLocalizations.of(context)?.pleaseEnterPlaylistName,
              ),
            ).borderWithRadius(value: 1, radius: 5),
            Container(
              height: 0.2,
              width: double.infinity,
              color: AppTheme.singleton.dividerColor,
            ).vP16,
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 120,
                  child: BorderButtonType1(
                    text: AppLocalizations.of(context)?.cancel,
                    textStyle: TextStyles.title.bold.lightColor,
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: FilledButtonType1(
                    text: AppLocalizations.of(context)?.save,
                    onPress: () {
                      savePlaylist();
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
          ],
        ).p16,
      ).round(20).hP16,
    );
  }

  savePlaylist() {
    if (playlistTf.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterPlaylistName, true);
      return;
    }

    EasyLoading.show(status: AppLocalizations.of(context)?.loading);
    if (widget.playlist == null) {
      getIt<FirebaseManager>()
          .insertNewPlaylist(playlistTf.text)
          .then((result) {
        EasyLoading.dismiss();
        widget.playlistSaved();
      });
    } else {
      getIt<FirebaseManager>()
          .updatePlaylistName(widget.playlist!.id, playlistTf.text)
          .then((result) {
        EasyLoading.dismiss();
        widget.playlistSaved();
      });
    }
  }

  showMessage(String message, bool isError) {
    GFToast.showToast(message, context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: TextStyles.body,
        backgroundColor:
            isError == true ? AppTheme().redColor : AppTheme().successColor,
        trailing: Icon(
            isError == true ? Icons.error : Icons.check_circle_outline,
            color: AppTheme().lightColor));
  }
}
