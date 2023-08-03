import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/provider/locale_provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

// ignore: camel_case_types
enum passwordType { password, passwordConfirm, oldpassword }

class RegisterState extends State<Register> {
  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final referralCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final passowrdCfrmCtrl = TextEditingController();
  late bool _passwordObscure;
  late bool _passwordCfrmObscure;
  var isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedLanguages;
  @override
  void initState() {
    super.initState();
    _passwordObscure = true;
    _passwordCfrmObscure = true;
    getLanguages();
  }

  togglePassword(pwType) {
    setState(() {
      switch (pwType) {
        case passwordType.password:
          _passwordObscure = !_passwordObscure;
          break;
        case passwordType.passwordConfirm:
          _passwordCfrmObscure = !_passwordCfrmObscure;
          break;
      }
    });
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
              image: AssetImage('assets/images/bg-m-2.png'),
              // opacity: 0.7,
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: 37,
                          width: 100,
                          child: Image.asset(
                            'assets/images/bstill-text-logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          child: InkWell(
                            // onTap: () => {context.push('/language')},
                            onTap: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeLanguage()),
                              );
                              if (result) {
                                getLanguages();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: AppTheme.singleton.fontColor,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                              ),
                              height: 40,
                              width: 40,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    selectedLanguages.toString().toUpperCase(),
                                    style: TextStyles.bodySm.fontColor.bold,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).setPadding(left: 16, top: 20),
                  ).setPadding(right: 16),
                  const SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context)!.registration,
                    style: TextStyles.h2Style.fontColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.all(20.0),
                        //   child: Container(
                        //       child: TextFormField(
                        //     controller: usernameCtrl,
                        //     decoration: InputDecoration(
                        //       labelText:
                        //           // AppLocalizations.of(context).username,
                        //           AppLocalizations.of(context)?.username,
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 0.0, horizontal: 10.0 * 2.0),
                        //     ),
                        //     cursorColor: Colors.transparent,
                        //   )).round(40),
                        // ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                        //   child: Container(
                        //       child: TextFormField(
                        //     controller: nameCtrl,
                        //     decoration: InputDecoration(
                        //       labelText: AppLocalizations.of(context)?.fullName,
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       contentPadding: EdgeInsets.symmetric(
                        //           vertical: 0.0, horizontal: 10.0 * 2.0),
                        //     ),
                        //     cursorColor: Colors.transparent,
                        //   )).round(40),
                        // ),
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
                        //Password
                        Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 0.0, 20.0, 20.0),
                            child: TextFormField(
                              controller: passwordCtrl,
                              obscureText: _passwordObscure,
                              decoration: InputDecoration(
                                labelText:
                                    // AppLocalizations.of(context).password,
                                    AppLocalizations.of(context)?.password,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: IconButton(
                                    icon: Icon(_passwordObscure
                                        ? Icons.lock
                                        : Icons.lock_open),
                                    onPressed: () =>
                                        togglePassword(passwordType.password),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0 * 2.0),
                              ),
                              cursorColor: Colors.transparent,
                            ).round(40)),
                        //confirm password
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: TextFormField(
                            controller: passowrdCfrmCtrl,
                            obscureText: _passwordCfrmObscure,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)?.confirmPwdStr,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: IconButton(
                                  icon: Icon(_passwordCfrmObscure
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
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                          child: CheckboxListTile(
                            activeColor: AppTheme.singleton.fontColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            title: RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)?.byread,
                                style:
                                    TextStyles.bodyExtraSm.fontColor.semiBold,
                              ),
                              const TextSpan(
                                text: ' ',
                              ),
                              TextSpan(
                                  text:
                                      AppLocalizations.of(context)?.termsOfUse,
                                  style: TextStyles
                                      .bodyExtraSm.fontColor.semiBold
                                      .merge(const TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push('/terms-of-use');
                                    }),
                              const TextSpan(
                                text: ' ',
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.andOur,
                                style:
                                    TextStyles.bodyExtraSm.fontColor.semiBold,
                              ),
                              const TextSpan(
                                text: ' ',
                              ),
                              TextSpan(
                                  text: AppLocalizations.of(context)
                                      ?.privacyPolicy,
                                  style: TextStyles
                                      .bodyExtraSm.fontColor.semiBold
                                      .merge(const TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push('/privacy-policy');
                                    })
                            ])),
                            value: isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                isChecked = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),

                        SizedBox(
                            height: 50,
                            width: 200,
                            child: FilledButtonType1(
                              isEnabled: isChecked,
                              disabledBackgroundColor:
                                  AppTheme.singleton.fontColor.lighten(0.2),
                              enabledTextStyle: TextStyles.body.white.lightBold,
                              disabledTextStyle:
                                  TextStyles.body.white.lightBold,
                              enabledBackgroundColor:
                                  AppTheme.singleton.fontColor,
                              text: AppLocalizations.of(context)?.createAccount,
                              onPress: () async => {
                                registerUser(emailCtrl.text, passwordCtrl.text)
                              },
                            )).round(30),
                        const SizedBox(
                          height: 20,
                        ),
                        //Have Acc
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
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
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

  registerUser(email, password) async {
    print(emailCtrl.text.isEmpty);
    if (emailCtrl.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterEmail, true);
    }
    if (passwordCtrl.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterPassword, true);
    }
    if (passowrdCfrmCtrl.text.isEmpty) {
      showMessage(
          AppLocalizations.of(context)!.pleaseEnterConfirmPassword, true);
    }
    if (passwordCtrl.text != passowrdCfrmCtrl.text) {
      showMessage(AppLocalizations.of(context)!.passwordsDoesNotMatched, true);
    }
    if (passwordCtrl.text.length < 8) {
      showMessage(
          AppLocalizations.of(context)!.passwordRequirementsValues, true);
    }
    if (passowrdCfrmCtrl.text.length < 8) {
      showMessage(
          AppLocalizations.of(context)!.confirmpasswordRequirementsValues,
          true);
    }

    EasyLoading.show(status: AppLocalizations.of(context)?.loading);

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseManager()
            .insertPaidStatus(value.user!.uid)
            .then((val) async {
          await UserProfileManager().refreshProfile();
          showMessage(AppLocalizations.of(context)!.registerSuccess, false);
          EasyLoading.dismiss();
          emailCtrl.clear();
          passwordCtrl.clear();
          passowrdCfrmCtrl.clear();
          await UserProfileManager().auth.currentUser?.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          context.push('/login');
        });
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      print(e.code.toString());
      showMessage(e.toString(), true);
      if (e.code == 'email-already-in-use') {
        print('Email already in use.');
        showMessage(AppLocalizations.of(context)!.emailExists, true);
      } else if (e.code == 'invalid-email') {
        print('Invalid format.');
        showMessage(AppLocalizations.of(context)!.invalidEmail, true);
      } else if (e.code == 'unknown') {
        print('Null field');
        showMessage(AppLocalizations.of(context)!.pleaseEnterEmail, true);
      } else {
        print(e.toString());
        print(e.code.toString());
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

  getLanguages() async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // String languageName = prefs.getString('BSTILL_LANG_NAME') ?? "EN";
    String languageCode = prefs.getString('BSTILL_LANG') ?? "EN";
    if (languageCode.contains('_')) {
      var symbol = [];
      symbol.addAll(languageCode.split('_'));
      provider.setLocale(Locale(symbol.first, symbol.last));
    } else {
      provider.setLocale(Locale(languageCode));
    }
    print(languageCode + ' hello');
    if (languageCode == "zh_CN") {
      setState(() {
        languageCode = "简";
      });
    }
    if (languageCode == "zh_TW") {
      setState(() {
        languageCode = "繁";
      });
    }
    print(languageCode);
    setState(() {
      selectedLanguages = languageCode;
    });
  }
}
