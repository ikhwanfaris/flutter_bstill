import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/l10n/l10n.dart';
import 'package:music_streaming_mobile/provider/locale_provider.dart';

//- Remove Queue from my Playlist after tapping played now

class ChangeLanguage extends StatefulWidget {
  final bool? isFirstTimeLogin;
  final VoidCallback? languagePrefChangeBlock;

  const ChangeLanguage(
      {Key? key, this.isFirstTimeLogin, this.languagePrefChangeBlock})
      : super(key: key);

  @override
  ChangeLanguageState createState() => ChangeLanguageState();
}

class ChangeLanguageState extends State<ChangeLanguage> {
  var selectedLanguages = 'en';

  late bool isFirstTimeLogin;

  bool showMaximumLanguagesMessage = false;

  @override
  void initState() {
    isFirstTimeLogin = widget.isFirstTimeLogin ?? false;

    super.initState();
    getLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg-m-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          const SizedBox(height: 40.0),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              color: AppTheme.singleton.fontColor,
              onPressed: () {
                // context.pop();
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.selectLanguages,
              style: TextStyles.h2Style.fontColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: L10n.languageList.length,
            itemBuilder: (BuildContext context, index) {
              final item = L10n.languageList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: selectedLanguages == item['symbol']
                      ? AppTheme.singleton.fontColor
                      : Colors.white,
                  child: Row(
                    children: [
                      Text(item['name'].toString(),
                          style: selectedLanguages == item['symbol']
                              ? TextStyles.body.lightColor
                              : TextStyles.body.fontColor),
                      const Spacer(),
                      selectedLanguages == item['symbol']
                          ? const ThemeIconWidget(
                              ThemeIcon.checkMark,
                              color: Colors.white,
                            )
                          : Container()
                    ],
                  ).vp(12).hP16.ripple(() {
                    if (selectedLanguages != item['symbol']) {
                      selectedLanguages = item['symbol'].toString();
                    }
                    setState(() {});
                  }),
                ).round(5),
              );
            },
          ).hp(20),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: FilledButtonType1(
              enabledTextStyle: TextStyles.body.white.lightBold,
              enabledBackgroundColor: AppTheme.singleton.fontColor,
              text: AppLocalizations.of(context)?.save,
              onPress: () {
                savePref();
              },
            ).hp(20),
          ).round(30),
        ]),
      ),
    );
  }

  savePref() async {
    try {
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      if (selectedLanguages.contains('_')) {
        var symbol = [];
        symbol.addAll(selectedLanguages.split('_'));
        provider.setLocale(Locale(symbol.first, symbol.last));
      } else {
        provider.setLocale(Locale(selectedLanguages));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('BSTILL_LANG', selectedLanguages);
      Future.delayed(const Duration(milliseconds: 10),
          () => showMessage(AppLocalizations.of(context)!.langSuccess, false));

      setState(() {});
    } catch (e) {
      showMessage(e.toString(), true);
    }
  }

  getLanguages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('BSTILL_LANG') ?? "en";
    // String langName = prefs.getString('BSTILL_LANG_NAME') ?? "EN";
    // print(langName + ' this is ');
    setState(() {
      selectedLanguages = languageCode;
      // selectedLangName = langName;
    });
  }

  changeLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('BSTILL_LANG', selectedLanguages);
  }

  showMessage(String message, bool isError) {
    GFToast.showToast(message, context,
        toastPosition: GFToastPosition.TOP,
        textStyle: TextStyles.bodySm.lightColor,
        toastDuration: 3,
        backgroundColor:
            isError == true ? AppTheme().redColor : AppTheme().successColor,
        trailing: Icon(
            isError == true ? Icons.error : Icons.check_circle_outline,
            color: AppTheme().lightColor));
  }
}
