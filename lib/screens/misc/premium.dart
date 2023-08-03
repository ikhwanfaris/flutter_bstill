// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/gestures.dart';
import 'package:music_streaming_mobile/app_config.dart';
import 'package:pointycastle/export.dart' as pointycastle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/provider/revenuecat.dart';
// import 'package:music_streaming_mobile/screens/my_account/browser.dart';
import 'package:music_streaming_mobile/services/subscriptions_api.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import '../my_account/browser.dart';

class PremiumPage extends StatefulWidget {
  final bool? isFirstTimeLogin;
  final VoidCallback? languagePrefChangeBlock;
  List<BottomNavigationBarItem> navBarItems;

  PremiumPage(
      {Key? key,
      this.isFirstTimeLogin,
      this.languagePrefChangeBlock,
      required this.navBarItems})
      : super(key: key);

  @override
  PremiumPageState createState() => PremiumPageState();
}

class PremiumPageState extends State<PremiumPage> {
  bool showMaximumLanguagesMessage = false;
  List<dynamic> offers = [];
  late Package monthlyOffer;
  late Package yearlyOffer;
  var monthlyPrice = 0.00;
  var currency = 'USD';
  var monthlyTrial = 7;
  var yearlyPrice = 0.00;
  var yearlyTrial = 7;
  var API_URL = '';
  // var RSAPublicKey = {};
  // var RSAPrivateKey = {};
  late Map<String, dynamic> form;
  var isSubscribedStore = false;
  var isSubscribedSeeds = false;
  var isShowSeedsPayment = false;
  var isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    fetchOffers();
    checkIfShowSeedsPayment();

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      setState(() {
        form = {
          'venderOrderId': makeid(15),
          'timestamp':
              (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString(),
          'price': '8',
          'origin': Uri.encodeFull('https://bstill-2db39.web.app/'),
          'user': UserProfileManager().auth.currentUser!.uid,
          // 'expiryDate': '',
          'duration': 'M',
          // 'subscribedDate':
          //     (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString()
        };
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  checkIfShowSeedsPayment() async {
    var data = await FirebaseManager().checkIfShowSeedsPayment();

    setState(() {
      isShowSeedsPayment = data;
    });
  }

  checkSubscription() async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      try {
        await UserProfileManager().refreshProfile();
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        isSubscribedStore = customerInfo.activeSubscriptions.isNotEmpty;
        isSubscribedSeeds =
            UserProfileManager().user!.active_subscription != '' &&
                (UserProfileManager().user!.subscribeVia == 'EFOREST_SEEDS' ||
                    UserProfileManager().user?.subscribeVia == 'EF2_FRUITS') &&
                UserProfileManager().user!.subscribeStatus == 'A';
        // print(isSubscribedSeeds);

        if (isSubscribedStore == true || isSubscribedSeeds == true) {
          return true;
        } else {
          return false;
        }
        // access latest customerInfo
      } on PlatformException catch (e) {
        // Error fetching customer info
        print(e);
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);

    return !isLoading
        ? Column(
            children: [
              Container(
                color: AppTheme.singleton.navigationBarColor,
                height: Platform.isIOS ? 100 : 85,
                child: Row(
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
                  ],
                ).setPadding(left: 16, top: Platform.isIOS ? 50 : 30),
              ),
              Container(child: premiumView(config))
            ],
          )
        : const CircularProgressIndicator();
  }

  Widget premiumView(config) {
    return Expanded(
        child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-m-3.png'),
          // opacity: 0.7,
          fit: BoxFit.cover,
        ),
      ),
      child: isSubscribedStore == false || isSubscribedSeeds == false
          ? CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  // Container(),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 20, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            child: Text(
                              AppLocalizations.of(context)!.selectPaymentMethod,
                              style: TextStyles.titleBold.fontColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          createCard(
                              const Color.fromRGBO(67, 78, 116, 1),
                              AppLocalizations.of(context)?.publicUser,
                              AppLocalizations.of(context)
                                  ?.subscriptionExtra(monthlyTrial.toString()),
                              AppLocalizations.of(context)!.subscriptionPrice(
                                  currency,
                                  monthlyPrice.toString(),
                                  AppLocalizations.of(context)!.month),
                              [
                                AppLocalizations.of(context)!.unlimitedAccess,
                                AppLocalizations.of(context)!.over100sounds,
                                AppLocalizations.of(context)!
                                    .cancelMonthlyAnytime,
                              ],
                              AppLocalizations.of(context)?.subscribe,
                              () async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              EasyLoading.show(
                                  status:
                                      AppLocalizations.of(context)?.loading);
                              await UserProfileManager().refreshProfile();
                              if (await checkSubscription() == false) {
                                // if (UserProfileManager().user!.isSubscribed == 0 ||
                                //     UserProfileManager().user!.expiryDate == null) {
                                try {
                                  var result =
                                      await PurchaseAPI.subscribePackage(
                                          monthlyOffer);
                                  if (result != null && result != false) {
                                    var subscribeDetails =
                                        result.entitlements.active['premium'];

                                    await getIt<FirebaseManager>()
                                        .updatePaidStatus(
                                      1,
                                      // DateTime.parse(
                                      //     subscribeDetails?.expirationDate),
                                      null,
                                      subscribeDetails.store.toString(),
                                      'M',
                                      DateTime.parse(
                                          subscribeDetails!.latestPurchaseDate),
                                      0,
                                    );
                                    await RevenueCatProvider()
                                        .updatePurchaseStatus();
                                    showMessage(
                                        AppLocalizations.of(context)!
                                            .subscribeSuccess,
                                        false);

                                    setState(() {
                                      widget.navBarItems.removeLast();
                                    });
                                    context.go('/');
                                  }

                                  // final now = DateTime.now();
                                  // getIt<FirebaseManager>().updatePaidStatus(
                                  //     1,
                                  //     DateTime(now.year, now.month, now.day)
                                  //         .add(const Duration(days: 30)));
                                } on FirebaseAuthException catch (e) {
                                  showMessage(e.message.toString(), true);
                                }
                                EasyLoading.dismiss();
                              } else {
                                showMessage(
                                    AppLocalizations.of(context)!
                                        .alreadySubscribed,
                                    true);
                              }
                            } else {
                              showMessage(
                                  AppLocalizations.of(context)!.pleaseLogin,
                                  false);
                              context.go('/login');
                            }
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          createCard(
                              const Color.fromRGBO(67, 78, 116, 1),
                              AppLocalizations.of(context)?.publicUser,
                              AppLocalizations.of(context)
                                  ?.subscriptionExtra(yearlyTrial.toString()),
                              AppLocalizations.of(context)?.subscriptionPrice(
                                  currency,
                                  yearlyPrice.toString(),
                                  AppLocalizations.of(context)!.year),
                              [
                                AppLocalizations.of(context)!.unlimitedAccess,
                                AppLocalizations.of(context)!.over100sounds,
                                AppLocalizations.of(context)!
                                    .cancelYearlyAnytime,
                              ],
                              AppLocalizations.of(context)?.subscribe,
                              () async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              EasyLoading.show(
                                  status:
                                      AppLocalizations.of(context)?.loading);
                              await UserProfileManager().refreshProfile();
                              if (await checkSubscription() == false) {
                                // if (UserProfileManager().user!.isSubscribed == 0 ||
                                //     UserProfileManager().user!.expiryDate == null) {
                                try {
                                  var result =
                                      await PurchaseAPI.subscribePackage(
                                          yearlyOffer);
                                  if (result != null && result != false) {
                                    var subscribeDetails =
                                        result.entitlements.active['premium'];

                                    await getIt<FirebaseManager>()
                                        .updatePaidStatus(
                                            1,
                                            // DateTime.parse(
                                            //     subscribeDetails?.expirationDate),
                                            null,
                                            subscribeDetails!.store.toString(),
                                            'Y',
                                            DateTime.parse(subscribeDetails!
                                                .latestPurchaseDate),
                                            0);
                                    await RevenueCatProvider()
                                        .updatePurchaseStatus();
                                    showMessage(
                                        AppLocalizations.of(context)!
                                            .subscribeSuccess,
                                        false);

                                    setState(() {
                                      widget.navBarItems.removeLast();
                                    });
                                    context.go('/');
                                  }
                                } on FirebaseAuthException catch (e) {
                                  showMessage(e.message.toString(), true);
                                }
                                EasyLoading.dismiss();
                              } else {
                                showMessage(
                                    AppLocalizations.of(context)!
                                        .alreadySubscribed,
                                    true);
                              }
                            } else {
                              showMessage(
                                  AppLocalizations.of(context)!.pleaseLogin,
                                  false);
                              context.go('/login');
                            }
                          }),
                          const SizedBox(
                            height: 15,
                          ),
                          isShowSeedsPayment
                              ? Column(
                                  children: [
                                    createCard(
                                        const Color.fromRGBO(0, 93, 79, 1),
                                        AppLocalizations.of(context)
                                            ?.eforestUser,
                                        AppLocalizations.of(context)?.get7days,
                                        AppLocalizations.of(context)?.seeds8,
                                        [
                                          AppLocalizations.of(context)!
                                              .percent20,
                                          AppLocalizations.of(context)!
                                              .unlimitedAccess,
                                          AppLocalizations.of(context)!
                                              .over100sounds,
                                          AppLocalizations.of(context)!
                                              .cancelMonthlySeedAnytime,
                                          AppLocalizations.of(context)!
                                              .oneTimePayment,
                                        ],
                                        AppLocalizations.of(context)?.paySeed,
                                        () => {
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null)
                                                {
                                                  _launchURL(8.toString(), 'M',
                                                      config, 'EF1')
                                                }
                                              else
                                                {
                                                  showMessage(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .pleaseLogin,
                                                      false),
                                                  context.go('/login'),
                                                }
                                            }),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    createCard(
                                        const Color.fromRGBO(0, 93, 79, 1),
                                        AppLocalizations.of(context)
                                            ?.eforestUser,
                                        AppLocalizations.of(context)?.get7days,
                                        AppLocalizations.of(context)?.seeds88,
                                        [
                                          AppLocalizations.of(context)!
                                              .percent20,
                                          AppLocalizations.of(context)!
                                              .unlimitedAccess,
                                          AppLocalizations.of(context)!
                                              .over100sounds,
                                          AppLocalizations.of(context)!
                                              .cancelYearlySeedAnytime,
                                          AppLocalizations.of(context)!
                                              .oneTimePayment,
                                        ],
                                        AppLocalizations.of(context)?.paySeed,
                                        () => {
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null)
                                                {
                                                  _launchURL(88.toString(), 'Y',
                                                      config, 'EF1')
                                                }
                                              else
                                                {
                                                  showMessage(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .pleaseLogin,
                                                      false),
                                                  context.go('/login'),
                                                }
                                            }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    createCard(
                                        const Color(0xFF514324),
                                        AppLocalizations.of(context)
                                            ?.eforest2User,
                                        AppLocalizations.of(context)?.get7days,
                                        AppLocalizations.of(context)?.fruits8,
                                        [
                                          AppLocalizations.of(context)!
                                              .percent20,
                                          AppLocalizations.of(context)!
                                              .unlimitedAccess,
                                          AppLocalizations.of(context)!
                                              .over100sounds,
                                          AppLocalizations.of(context)!
                                              .cancelMonthlySeedAnytime,
                                          AppLocalizations.of(context)!
                                              .oneTimePayment,
                                        ],
                                        AppLocalizations.of(context)?.payFruit,
                                        () => {
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null)
                                                {
                                                  _launchURL(8.toString(), 'M',
                                                      config, 'EF2')
                                                }
                                              else
                                                {
                                                  showMessage(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .pleaseLogin,
                                                      false),
                                                  context.go('/login'),
                                                }
                                            }),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    createCard(
                                        const Color(0xFF514324),
                                        AppLocalizations.of(context)
                                            ?.eforest2User,
                                        AppLocalizations.of(context)?.get7days,
                                        AppLocalizations.of(context)?.fruits88,
                                        [
                                          AppLocalizations.of(context)!
                                              .percent20,
                                          AppLocalizations.of(context)!
                                              .unlimitedAccess,
                                          AppLocalizations.of(context)!
                                              .over100sounds,
                                          AppLocalizations.of(context)!
                                              .cancelYearlySeedAnytime,
                                          AppLocalizations.of(context)!
                                              .oneTimePayment,
                                        ],
                                        AppLocalizations.of(context)?.payFruit,
                                        () => {
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null)
                                                {
                                                  _launchURL(88.toString(), 'Y',
                                                      config, 'EF2')
                                                }
                                              else
                                                {
                                                  showMessage(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .pleaseLogin,
                                                      false),
                                                  context.go('/login'),
                                                }
                                            }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : Container(),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        ?.termsOfUse,
                                    style: TextStyles.bodySm.fontColor.lightBold
                                        .merge(const TextStyle(
                                            decoration:
                                                TextDecoration.underline)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BrowserPage(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .termsOfUse,
                                                  url: AppConfig.of(context)!
                                                      .tncUrl);

                                              // context.push('/privacy-policy');
                                            });
                                      }),
                                TextSpan(
                                    text: ' | ',
                                    style:
                                        TextStyles.bodySm.fontColor.lightBold),
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        ?.privacyPolicy,
                                    style: TextStyles.bodySm.fontColor.lightBold
                                        .merge(const TextStyle(
                                            decoration:
                                                TextDecoration.underline)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BrowserPage(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .privacyPolicy,
                                                  url: AppConfig.of(context)!
                                                      .privacyPolicyUrl);

                                              // context.push('/privacy-policy');
                                            });
                                      })
                              ])),
                          const SizedBox(
                            height: 20,
                          ),
                          // Text(
                          //   textAlign: TextAlign.center,
                          //   AppLocalizations.of(context)!.paymentFooter,
                          //   style: TextStyles.bodyExtraSm.white,
                          // ),
                          // const SizedBox(
                          //   height: 50,
                          // ),
                        ],
                      )),

                  // const SizedBox(
                  //   height: 0,
                  // )
                ]))
              ],
            )
          : Text(AppLocalizations.of(context)!.alreadySubscribed),
    ));
  }

  createCard(color, userType, trialDuration, price, List<String> desc,
      buttonDesc, Function callback) {
    return Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userType,
                style: TextStyles.bodySuperExtraSm.white.extraLight,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(trialDuration,
                    style: TextStyles.bodySm.white.bold,
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                price,
                style: TextStyles.h3Style.white.extraLight,
              ),
              const SizedBox(
                height: 20,
              ),
              for (var d in desc)
                Column(
                  children: [
                    Text(d, style: TextStyles.bodyExtraSm.white.extraLight),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              BorderButtonType1(
                cornerRadius: 30,
                height: 40,
                borderColor: Colors.white,
                text: buttonDesc,
                textStyle: TextStyles.bodySm.bold.lightColor,
                onPress: () {
                  callback();
                  debugPrint('www');
                },
              ),
            ],
          ),
        )).round(30);
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

  fetchOffers() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();

      setState(() {
        monthlyOffer = offerings.current!.availablePackages
            .filter((element) => element.identifier == '\$rc_monthly')
            .first;
        yearlyOffer = offerings.current!.availablePackages
            .filter((element) => element.identifier == '\$rc_annual')
            .first;
        monthlyPrice = monthlyOffer.storeProduct.price;
        // monthlyTrial =
        //     monthlyOffer.storeProduct.introductoryPrice!.periodNumberOfUnits;
        yearlyPrice = yearlyOffer.storeProduct.price;
        // yearlyTrial =
        //     yearlyOffer.storeProduct.introductoryPrice!.periodNumberOfUnits;
        currency = monthlyOffer.storeProduct.currencyCode;
      });
    } on PlatformException catch (e) {
      return [];
    }
  }

  _launchURL(price, duration, config, subVia) async {
    // var now = DateTime.now();
    // var expiryDate = duration == 'MONTHLY'
    //     ? DateTime(now.year, now.month + 1, now.day)
    //     : DateTime(now.year + 1, now.month, now.day);

    setState(() {
      form['price'] = price;
      form['duration'] = duration;
      API_URL = AppConfig.of(context)!.ef1_signatureVerifyUrl;
    });

    if (subVia == 'EF2') {
      setState(() {
        form['price'] = int.parse(form['price']);
        form['merchant'] = 'Fruits';
        form['venderOrderId'] = makeid(10);
        form['origin'] = Uri.encodeFull('https://ef2-thanks.web.app/');
        API_URL = AppConfig.of(context)!.ef2_signatureVerifyUrl;
      });
    }

    try {
      var result = await generateSignature(form, config, subVia);
      var obj = {'data': result['data'], 'signature': result['signature']};
      print(obj);
      var response = await http.post(
        Uri.parse(API_URL),
        headers: {
          'content-type': 'application/json',
          'x-api-signature': obj['signature'].toString()
        },
        body: jsonEncode(
          {'data': obj['data'].toString()},
        ),
      );

      var url = jsonDecode(response.body);

      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return BrowserPage(
              url: url['signed_url'],
              title: subVia == 'EF2'
                  ? AppLocalizations.of(context)!.fruitsPayment
                  : AppLocalizations.of(context)!.seedsPayment,
            );
          }).then((value) async {
        EasyLoading.show(status: AppLocalizations.of(context)?.loading);

        await UserProfileManager().refreshProfile();
        await RevenueCatProvider().updatePurchaseStatus();

        if (UserProfileManager().user!.active_subscription != '' &&
            UserProfileManager().user!.subscribeStatus == 'A') {
          setState(() {
            widget.navBarItems.removeLast();
          });
          showMessage(AppLocalizations.of(context)!.subscribeSuccess, false);
          context.go('/');
        }
      });
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    EasyLoading.dismiss();

    // const url = 'https://google.com';
    // final uri = Uri.parse(url);
  }

  String makeid(int length) {
    var result = '';
    var characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
      result += characters[Random().nextInt(charactersLength)];
    }

    return result;
  }

  Future<String> encryptForm(form, config, subVia) async {
    var publicKeyPath = 'public_key_eforest.txt';
    var privateKeyPath = 'private_key_eforest.txt';
    if (subVia == 'EF2') {
      publicKeyPath = 'publicKey_ef2.txt';
      privateKeyPath = 'privateKey_ef2.txt';
    }

    final publicKey = await rootBundle.loadString(
        'assets/keys/${config.prod == true ? 'prod' : 'staging'}/$publicKeyPath');
    final publicKeyObject =
        encrypt.RSAKeyParser().parse(publicKey) as pointycastle.RSAPublicKey;

    final privateKey = await rootBundle.loadString(
        'assets/keys/${config.prod == true ? 'prod' : 'staging'}/$privateKeyPath');
    final privateKeyObject =
        encrypt.RSAKeyParser().parse(privateKey) as pointycastle.RSAPrivateKey;

    final encodedForm = utf8.fuse(base64).encode(json.encode(form));

    final encrpyted = encrypt.Encrypter(
        encrypt.RSA(publicKey: publicKeyObject, privateKey: privateKeyObject));
    // print(signer.sign(json.encode(form)).base64);
    final encryptedResult = encrpyted.encrypt(encodedForm).base64;
    return encryptedResult;
  }

  Future<Map<String, String>> generateSignature(form, config, subVia) async {
    var publicKeyPath = 'public_key_eforest.txt';
    var privateKeyPath = 'private_key_eforest.txt';
    if (subVia == 'EF2') {
      publicKeyPath = 'publicKey_ef2.txt';
      privateKeyPath = 'privateKey_ef2.txt';
    }

    // print(publicKeyPath);
    final encrypted = await encryptForm(form, config, subVia);

    final publicKey = await rootBundle.loadString(
        'assets/keys/${config.prod == true ? 'prod' : 'staging'}/$publicKeyPath');
    final publicKeyObject =
        encrypt.RSAKeyParser().parse(publicKey) as pointycastle.RSAPublicKey;
    final privateKey = await rootBundle.loadString(
        'assets/keys/${config.prod == true ? 'prod' : 'staging'}/$privateKeyPath');
    final privateKeyObject =
        encrypt.RSAKeyParser().parse(privateKey) as pointycastle.RSAPrivateKey;
    // print(privateKey);
    final signer = encrypt.Signer(encrypt.RSASigner(
        encrypt.RSASignDigest.SHA256,
        publicKey: publicKeyObject,
        privateKey: privateKeyObject));
    // print({
    //   'data': encrypted,
    //   'signature': signer.sign(encrypted).base64,
    // });
    return {
      'data': encrypted,
      'signature': signer.sign(encrypted).base64,
    };
  }
}
