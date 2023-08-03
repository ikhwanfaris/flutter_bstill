import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/provider/locale_provider.dart';

import '../../services/subscriptions_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // String phoneCode = '+60';
  bool _passwordObscure = true;
  String? selectedLanguages;

  @override
  void initState() {
    super.initState();
    getLanguages();

    _passwordObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.singleton.primaryBackgroundColor,
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
                                builder: (context) => const ChangeLanguage()),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyles.h2Style.fontColor,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    color: AppTheme.singleton.lightColor,
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyles.body.fontColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .thisFieldIsrequired;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        labelStyle: TextStyles.bodySm,
                        floatingLabelStyle: TextStyles.body.fontColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                      ),
                    ),
                  ).round(40),
                  const SizedBox(height: 10),
                  Container(
                    color: AppTheme.singleton.lightColor,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _passwordObscure,
                      style: TextStyles.body.fontColor,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .thisFieldIsrequired;
                        }
                        return null;
                      },
                      // keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)?.password,
                        labelStyle: TextStyles.bodySm,
                        floatingLabelStyle: TextStyles.body.fontColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: IconButton(
                            icon: Icon(
                                color: AppTheme.singleton.fontColor,
                                _passwordObscure
                                    ? Icons.lock
                                    : Icons.lock_open),
                            onPressed: () => togglePassword(),
                          ),
                        ),
                      ),
                    ),
                  ).round(40),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)?.forgotPwd,
                                style: TextStyle(
                                    color: AppTheme.singleton.fontColor,
                                    fontWeight: FontWeight.w500)),
                            const WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: SizedBox(width: 3)),
                            TextSpan(
                              text: AppLocalizations.of(context)?.clickHere,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppTheme.singleton.fontColor,
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/forgetPassword');

                                  // context.go('/login');
                                },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 45,
                    width: 160,
                    child: FilledButtonType1(
                      text: AppLocalizations.of(context)!.login,
                      cornerRadius: 30,
                      enabledBackgroundColor: AppTheme.singleton.fontColor,
                      onPress: () {
                        loginUser(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text:
                                  AppLocalizations.of(context)?.dontHaveAccount,
                              style: TextStyle(
                                  color: AppTheme.singleton.fontColor,
                                  fontWeight: FontWeight.w500)),
                          TextSpan(
                            text: AppLocalizations.of(context)?.createNow,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppTheme.singleton.fontColor,
                                fontWeight: FontWeight.w500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register');
                              },
                          )
                        ],
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ).setPadding(
                  left: 16,
                  right: 16,
                  bottom: 50,
                  top: Platform.isIOS ? 50 : 30),
              Text(
                AppLocalizations.of(context)!.loginAsGuest,
                style: TextStyles.body.fontColor.semiBold,
                textAlign: TextAlign.center,
              ).ripple(
                () {
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginUser(context) async {
    if (emailController.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterEmail, true);
      return;
    }
    if (passwordController.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.pleaseEnterPassword, true);
      return;
    }

    EasyLoading.show(status: AppLocalizations.of(context)!.loading);
    String emailString = emailController.text;
    String passwordString = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailString, password: passwordString);
      await UserProfileManager().refreshProfile();

      if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
        showMessage(AppLocalizations.of(context)!.emailNotVerified, true);
        await UserProfileManager().auth.currentUser?.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        EasyLoading.dismiss();
        return;
      }
      PurchaseAPI.init(context);
      // context.push('/home');
      EasyLoading.dismiss();
      showMessage("Login Successful", false);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            menuType: MenuType.home,
            selectedIndex: 0,
          ),
        ),
      );

      emailController.clear();
      passwordController.clear();
      //Translate
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showMessage(AppLocalizations.of(context)!.userNotFound, true);
      } else if (e.code == 'invalid-email') {
        print('Invalid email format');
        showMessage(AppLocalizations.of(context)!.invalidEmail, true);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showMessage(AppLocalizations.of(context)!.passwordError, true);
      } else if (e.code == 'user-disabled') {
        print('This account has been disabled');
        showMessage(AppLocalizations.of(context)!.accountDisabled, true);
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

  togglePassword() {
    setState(() {
      _passwordObscure = !_passwordObscure;
    });
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
