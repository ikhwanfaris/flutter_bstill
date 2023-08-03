import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-m-3.png'),
          // opacity: 0.7,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        //backgroundColor: AppTheme.singleton.primaryBackgroundColor,
        backgroundColor: Colors.transparent,
        appBar: BackNavigationBar(
          title: AppLocalizations.of(context)?.contactUs,
          backTapHandler: () {
            context.pop();
          },
        ),

        body: ListView(
          children: [
            Column(
              children: [
                InputField(
                  textStyle: TextStyles.body.lightColor,
                  controller: name,
                  hintText: AppLocalizations.of(context)?.name,
                  showBorder: false,
                  showDivider: false,
                ),
                const Divider(
                  color: Colors.black, //color of divider
                  height: 2, //height spacing of divider
                  thickness: 1, //thickness of divier line
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  textStyle: TextStyles.body.lightColor,
                  controller: email,
                  hintText: AppLocalizations.of(context)?.email,
                  showBorder: false,
                  showDivider: false,
                ),
                const Divider(
                  color: Colors.black, //color of divider
                  height: 2, //height spacing of divider
                  thickness: 1, //thickness of divier line
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  textStyle: TextStyles.body.lightColor,
                  controller: phone,
                  hintText: AppLocalizations.of(context)?.phoneNumber,
                  showBorder: false,
                  showDivider: false,
                ),
                const Divider(
                  color: Colors.black, //color of divider
                  height: 2, //height spacing of divider
                  thickness: 1, //thickness of divier line
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  textStyle: TextStyles.body.lightColor,
                  controller: message,
                  iconColor: Colors.black,
                  hintText: AppLocalizations.of(context)?.message,
                  showBorder: false,
                  showDivider: false,
                  maxLines: 10,
                ),
                const Divider(
                  color: Colors.black, //color of divider
                  height: 2, //height spacing of divider
                  thickness: 1, //thickness of divier line
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                    width: 120,
                    height: 50,
                    child: FilledButtonType1(
                        isEnabled: true,
                        cornerRadius: 10,
                        text: AppLocalizations.of(context)?.submit,
                        onPress: () {
                          sendMessage();
                        }))
              ],
            )
          ],
        ).hP16,
      ),
    );
  }

  sendMessage() {
    if (name.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterName, true);
      return;
    }
    if (email.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterEmail, true);
      return;
    }
    if (phone.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterPhoneNumber, true);
      return;
    }
    if (message.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterMessage, true);
      return;
    }

    EasyLoading.show(status: AppLocalizations.of(context)?.loading);
    getIt<FirebaseManager>()
        .sendContactusMessage(name.text, email.text, phone.text, message.text)
        .then((result) {
      EasyLoading.dismiss();
      if (result.status == true) {
        showMessage(
            result.message ?? AppLocalizations.of(context)!.requestSent, false);
      } else {
        showMessage(
            result.message ?? AppLocalizations.of(context)!.errorMessage, true);
      }
    });
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
