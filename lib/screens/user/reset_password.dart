// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldpasswordCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passowrdCfrmCtrl = TextEditingController();
  bool oldpasswordObscure = true;
  bool passwordObscure = true;
  bool passwordCfrmObscure = true;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  initApp() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-m-2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 30.0),
                  Text(
                    AppLocalizations.of(context)!.resetPassword,
                    style: TextStyles.h2Style.fontColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //Password
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: TextFormField(
                            controller: oldpasswordCtrl,
                            obscureText: oldpasswordObscure,
                            decoration: InputDecoration(
                              labelText:
                                  // AppLocalizations.of(context).password,
                                  AppLocalizations.of(context)?.currPwdStr,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0 * 2.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: IconButton(
                                  color: AppTheme.singleton.fontColor,
                                  icon: Icon(oldpasswordObscure
                                      ? Icons.lock
                                      : Icons.lock_open),
                                  onPressed: () =>
                                      togglePassword(passwordType.oldpassword),
                                ),
                              ),
                            ),
                            cursorColor: Colors.transparent,
                          ).round(40),
                        ),
                        //Password
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: TextFormField(
                            controller: passwordCtrl,
                            obscureText: passwordObscure,
                            decoration: InputDecoration(
                              labelText:
                                  // AppLocalizations.of(context).password,
                                  AppLocalizations.of(context)?.newPwdStr,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0 * 2.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: IconButton(
                                  color: AppTheme.singleton.fontColor,
                                  icon: Icon(passwordObscure
                                      ? Icons.lock
                                      : Icons.lock_open),
                                  onPressed: () =>
                                      togglePassword(passwordType.password),
                                ),
                              ),
                            ),
                            cursorColor: Colors.transparent,
                          ).round(40),
                        ),
                        //confirm password
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: TextFormField(
                            controller: passowrdCfrmCtrl,
                            obscureText: passwordCfrmObscure,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)?.confirmPwdStr,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: IconButton(
                                  color: AppTheme.singleton.fontColor,
                                  icon: Icon(passwordCfrmObscure
                                      ? Icons.lock
                                      : Icons.lock_open),
                                  onPressed: () => togglePassword(
                                      passwordType.passwordConfirm),
                                ),
                              ),
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
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: FilledButtonType1(
                            enabledTextStyle: TextStyles.body.white.lightBold,
                            enabledBackgroundColor:
                                AppTheme.singleton.fontColor,
                            text: AppLocalizations.of(context)?.resetPassword,
                            onPress: () async => {
                              resetPasswordFx(
                                  passwordCtrl.text, passowrdCfrmCtrl.text)
                            },
                          ),
                        ).round(30),
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

  togglePassword(pwType) {
    setState(() {
      switch (pwType) {
        case passwordType.password:
          passwordObscure = !passwordObscure;
          break;
        case passwordType.passwordConfirm:
          passwordCfrmObscure = !passwordCfrmObscure;
          break;
        case passwordType.oldpassword:
          oldpasswordObscure = !oldpasswordObscure;
          break;
      }
    });
  }

  resetPasswordFx(email, password) async {
    var credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldpasswordCtrl.text);
    // const Pattern pattern =
    //     r'^.*(?=.{3,})(?=.*[a-z])(?=.*[0-9])(?=.*[\d\x])(?=.*[A-Z]).*$';
    // RegExp regex = RegExp(pattern.toString());
    if (oldpasswordCtrl.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterOldPassword, true);
      return;
    }
    if (passwordCtrl.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterNewPassword, true);
      return;
    }
    if (passowrdCfrmCtrl.text.isEmpty) {
      showMessage(
          AppLocalizations.of(context)!.pleaseEnterConfirmPassword, true);
      return;
    }
    if (passwordCtrl.text.length < 8) {
      showMessage(
          AppLocalizations.of(context)!.passwordRequirementsValues, true);
      return;
    }
    if (passowrdCfrmCtrl.text.length < 8) {
      showMessage(
          AppLocalizations.of(context)!.confirmpasswordRequirementsValues,
          true);
      return;
    }
    // if (!regex.hasMatch(passwordCtrl.text)) {
    //   showMessage(AppLocalizations.of(context)?.passwordRequirementsRegex, true);
    //   return;
    // }
    // if (!regex.hasMatch(passowrdCfrmCtrl.text)) {
    //   showMessage(AppLocalizations.of(context)?.passwordRequirementsRegex, true);
    //   return;
    // }

    if (passwordCtrl.text != passowrdCfrmCtrl.text) {
      showMessage(AppLocalizations.of(context)!.passwordsDoesNotMatched, true);
      return;
    }
    EasyLoading.show(status: AppLocalizations.of(context)?.loading);
    if (UserProfileManager().user != null) {
      try {
        var credential = EmailAuthProvider.credential(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: oldpasswordCtrl.text);
        FirebaseAuth.instance.currentUser
            ?.reauthenticateWithCredential(credential)
            .catchError((onError) => showMessage(onError.toString(), true))
            .then((isSuccess) => {
                  FirebaseAuth.instance.currentUser
                      ?.updatePassword(passwordCtrl.text)
                      .then((value) => {
                            showMessage(
                                AppLocalizations.of(context)!.pwdUpdateSuccess,
                                false),
                            oldpasswordCtrl.clear(),
                            passwordCtrl.clear(),
                            passowrdCfrmCtrl.clear(),
                          })
                });
        await UserProfileManager().refreshProfile();
        //   context.push('/');
        EasyLoading.dismiss();
        // });
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        showMessage(e.toString(), true);
        if (e.code == 'email-already-in-use') {
          print('Email already in use.');
          showMessage(AppLocalizations.of(context)!.emailExists, true);
        } else if (e.code == 'wrong-password') {
          print('Wrong password');
          showMessage(
              AppLocalizations.of(context)!.currentPasswordIncorrect, true);
        } else {
          print(e.toString());
          showMessage(e.toString(), true);
        }
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
