import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key? key}) : super(key: key);

  @override
  ForgetpasswordState createState() => ForgetpasswordState();
}

class ForgetpasswordState extends State<Forgetpassword> {
  final emailCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: AppTheme.singleton.primaryBackgroundColor,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-m-3.png'),
              // opacity: 0.7,
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              // const SizedBox(height: 30.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(75.0),
                  //   child: Image.asset(
                  //     'assets/auth-icon.png',
                  //     width: 150.0,
                  //     height: 150.0,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      color: AppTheme.singleton.fontColor,
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.forgetPassword,
                    style: TextStyles.h2Style.fontColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //email
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: TextFormField(
                            controller: emailCtrl,
                            decoration: InputDecoration(
                              labelText:
                                  // AppLocalizations.of(context).email_address,
                                  AppLocalizations.of(context)?.email,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0 * 2.0),
                            ),
                            cursorColor: Colors.transparent,
                          ).round(40),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 50,
                            width: 200,
                            child: FilledButtonType1(
                              enabledTextStyle: TextStyles.body.white.lightBold,
                              enabledBackgroundColor:
                                  AppTheme.singleton.fontColor,
                              text: AppLocalizations.of(context)?.submit,
                              onPress: () async => {
                                if (emailCtrl.text.isEmpty)
                                  {
                                    showMessage(
                                        AppLocalizations.of(context)!
                                            .pleaseEnterEmail,
                                        true)
                                  },
                                forgetPass(emailCtrl.text)
                              },
                            )).round(30),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.alreadyHaveAcc,
                                style:
                                    TextStyles.bodyExtraSm.fontColor.semiBold,
                              ),
                              TextSpan(
                                  text: AppLocalizations.of(context)?.login,
                                  style: TextStyles
                                      .bodyExtraSm.fontColor.semiBold
                                      .merge(const TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go('/login');
                                    })
                            ]))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  forgetPass(email) async {
    if (emailCtrl.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterEmail, true);
      return;
    }

    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) async {
        await UserProfileManager().refreshProfile();
        EasyLoading.dismiss();
        showMessage(AppLocalizations.of(context)!.instructionsEmail, false);
        context.push('/login');
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      // print("e.toString()");
      print(e.code.toString());
      // showMessage(e.toString(), true);
      if (e.code == 'email-already-in-use') {
        print('Email already in use.');
        showMessage(AppLocalizations.of(context)!.emailExists, true);
      } else if (e.code == 'invalid-email') {
        print('Invalid format.');
        showMessage(AppLocalizations.of(context)!.invalidEmail, true);
      } else {
        print(e.toString());
        showMessage(e.toString(), true);
      }
    }
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
