import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

//ignore: must_be_immutable
class VerifyOTP extends StatefulWidget {
  String verificationId;
  final String phone;

  VerifyOTP({Key? key, required this.verificationId, required this.phone})
      : super(key: key);

  @override
  VerifyOTPState createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otp = TextEditingController();

  bool wrongOTP = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.singleton.primaryBackgroundColor,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                Colors.black.withOpacity(0.4),
                Colors.black,
              ],
                      stops: const [
                0.0,
                1.0
              ]))),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // Container(
                //   color: AppTheme.singleton.lightColor.withOpacity(0.8),
                //   child: Image.asset(
                //     'assets/images/logo.png',
                //     width: MediaQuery.of(context).size.width * 0.4,
                //     fit: BoxFit.contain,
                //   ),
                // ).circular,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                Container(
                  color:
                      AppTheme.singleton.primaryBackgroundColor.lighten(0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.otpVerification,
                            style: TextStyles.h2Style.lightColor,
                          ),
                          ThemeIconWidget(ThemeIcon.close,
                                  size: 25,
                                  color: AppTheme.singleton.lightColor)
                              .ripple(() {
                            context.pop();
                          })
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${AppLocalizations.of(context)?.weHaveSentOTP} ${widget.phone}',
                        style: TextStyles.bodySm.lightColor,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        color: AppTheme.singleton.primaryBackgroundColor,
                        child: InputField(
                          textStyle: TextStyles.body.lightColor,
                          hintText: AppLocalizations.of(context)?.enterOTP,
                          controller: otp,
                          onChanged: (phone) {},
                        ).hP4,
                      ).round(10),
                      const SizedBox(
                        height: 20,
                      ),
                      wrongOTP == true
                          ? Text(
                              AppLocalizations.of(context)!.wrongOTP,
                              style: TextStyles.bodySm.semiBold.subTitleColor,
                            )
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: BorderButtonType1(
                                  text: AppLocalizations.of(context)?.resendOTP,
                                  textStyle: TextStyles.body.lightColor.bold,
                                  onPress: () {
                                    resendOTP();
                                  })),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: FilledButtonType1(
                                  text:
                                      AppLocalizations.of(context)?.continueStr,
                                  onPress: () {
                                    submitOTP();
                                  })),
                        ],
                      ),
                    ],
                  ).setPadding(left: 16, right: 16, bottom: 50, top: 40),
                ).topRounded(15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  submitOTP() {
    if (otp.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterOTP, true);
      return;
    }
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    // EasyLoading.show(status: AppLocalizations.of(context)?.loading);
    getIt<FirebaseManager>().verifyOTP(otp.text, widget.verificationId,
        (loginStatus, isFirstTimeLogin) {
      EasyLoading.dismiss();
      if (loginStatus == true) {
        UserProfileManager().refreshProfile(completionHandler: () {
          if (loginStatus == true) {
            if (isFirstTimeLogin) {
              context.go('/change-language', extra: isFirstTimeLogin);
            } else {
              context.go('/home');
            }
          } else {
            showMessage(AppLocalizations.of(context)!.wrongOTP, true);
          }
        });
      } else {
        AppUtil.showToast(
            message: AppLocalizations.of(context)!.wrongOTP, context: context);
      }
    });
  }

  resendOTP() {
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);
    getIt<FirebaseManager>().login(
        phoneNumber: widget.phone,
        verificationIdHandler: (id) {
          EasyLoading.dismiss();
          widget.verificationId = id;
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
