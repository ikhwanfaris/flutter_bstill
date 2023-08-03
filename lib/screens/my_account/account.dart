import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/screens/my_account/browser.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

int selectedTab = 0;
var isSubscribed = false;
var isSubscribedStore = false;
var isSubscribedSeeds = false;
late CustomerInfo customerInfo;
var subVia;

class MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    refreshProfile();
    super.initState();
  }

  refreshProfile() async {
    await UserProfileManager().refreshProfile();
    await getSubscriptionInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
            child: Container(
                //color: AppTheme.singleton.primaryBackgroundColor,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-m-2.png'),
                    // opacity: 0.7,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.account,
                      style: TextStyles.h2Style.fontColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UserProfileManager().user != null
                        ? Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTab = 0;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.profile,
                                  style: TextStyles.bodyExtraSm.lightColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: selectedTab == 0
                                        ? const Color.fromRGBO(67, 78, 116, 1)
                                        : const Color.fromRGBO(
                                            135, 154, 210, 1)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              isSubscribed == true
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedTab = 1;
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.library,
                                        style:
                                            TextStyles.bodyExtraSm.lightColor,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          backgroundColor: selectedTab == 1
                                              ? const Color.fromRGBO(
                                                  67, 78, 116, 1)
                                              : const Color.fromRGBO(
                                                  135, 154, 210, 1)),
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTab = 2;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.settings,
                                  style: TextStyles.bodyExtraSm.lightColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: selectedTab == 2
                                        ? const Color.fromRGBO(67, 78, 116, 1)
                                        : const Color.fromRGBO(
                                            135, 154, 210, 1)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTab = 3;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.support,
                                  style: TextStyles.bodyExtraSm.lightColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: selectedTab == 3
                                        ? const Color.fromRGBO(67, 78, 116, 1)
                                        : const Color.fromRGBO(
                                            135, 154, 210, 1)),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          )
                        : Container(),
                    UserProfileManager().user != null
                        ? loadView()
                        : Container(),
                    UserProfileManager().user != null
                        ? Container()
                        : BorderButtonType1(
                            cornerRadius: 30,
                            height: 40,
                            borderColor: const Color(0XFF3c516e),
                            backgroundColor:
                                AppTheme.singleton.navigationBarColor,
                            text: AppLocalizations.of(context)?.login,
                            textStyle: TextStyles.body.fontColor,
                            onPress: () async {
                              await UserProfileManager().logout();
                              print("Here");
                              context.go('/login');
                            },
                          ).p25
                  ],
                ).hP16))
      ],
    );
  }

  Widget loadView() {
    if (selectedTab == 0) {
      return profileView();
    } else if (selectedTab == 1) {
      return libraryView();
    } else if (selectedTab == 2) {
      return settingsView();
    } else if (selectedTab == 3) {
      return supportView();
    }
    return profileView();
  }

  profileView() {
    return Column(
      children: [
        Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(67, 78, 116, 1)),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    '${AppLocalizations.of(context)!.email}:',
                    style: TextStyles.bodyExtraSm.white,
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  style: TextStyles.bodyExtraSm.bold.white,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    '${AppLocalizations.of(context)!.status}:',
                    style: TextStyles.bodyExtraSm.white.extraLight,
                  ),
                ),
                Text(
                  isSubscribed == true
                      ? AppLocalizations.of(context)!.subscribed
                      : AppLocalizations.of(context)!.notSubscribed,
                  style: TextStyles.bodyExtraSm.bold.white,
                )
              ],
            ),
            SizedBox(
              height: isSubscribed == true ? 10 : 0,
            ),
            isSubscribed == true
                ? Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          isSubscribedStore
                              ? '${AppLocalizations.of(context)!.nextRenewalDate}:'
                              : '${AppLocalizations.of(context)!.expiredDate}:',
                          style: TextStyles.bodyExtraSm.white,
                        ),
                      ),
                      Text(
                        isSubscribedStore
                            ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                customerInfo.latestExpirationDate.toString()))
                            : UserProfileManager().user!.expiryDate.toString(),
                        // DateFormat('dd-MM-yyyy')
                        //     .format((UserProfileManager().user?.expiryDate
                        //         as DateTime))
                        //     .toString(),
                        style: TextStyles.bodyExtraSm.bold.white,
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: isSubscribed == true ? 10 : 0,
            ),
            isSubscribed == true
                ? Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${AppLocalizations.of(context)!.subscriptionVia}:',
                          style: TextStyles.bodyExtraSm.white,
                        ),
                      ),
                      Text(
                        subVia,
                        style: TextStyles.bodyExtraSm.bold.white,
                      ),
                    ],
                  )
                : Container(),
          ]).hP16.vp(18),
        ).round(10).setPadding(top: 10, bottom: 20),
        isSubscribedStore == true
            ? Text(
                AppLocalizations.of(context)!.unSubscribe,
                style: TextStyles.bodySuperExtraSm.fontColor,
              ).setPadding(left: 10, right: 10)
            : Container(),
      ],
    );
  }

  libraryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        // createFlexButton(
        //     AppLocalizations.of(context)!.recentlyPlayed, '/recently-played'),
        // const Divider(
        //   height: 1,
        //   thickness: 1,
        // ),
        // createFlexButton(
        //     AppLocalizations.of(context)!.favArtists, '/favourite-artists'),
        // const Divider(
        //   height: 1,
        //   thickness: 1,
        // ),
        createFlexButton(
            AppLocalizations.of(context)!.likedSongs, '/liked-songs'),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        createFlexButton(
            AppLocalizations.of(context)!.myPlaylist, '/my-playlist'),
      ],
    );
  }

  settingsView() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          createFlexButton(AppLocalizations.of(context)!.language, '/language'),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          createFlexButton(
              AppLocalizations.of(context)!.resetPassword, '/reset_password'),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          isSubscribed == true
              ? Text(
                  AppLocalizations.of(context)!.cancelSubscriptions,
                  style: TextStyles.body.fontColor,
                ).ripple(() {
                  isSubscribedStore
                      ? launchUrl(
                          mode: LaunchMode.externalApplication,
                          Uri.parse(Platform.isIOS
                              ? "https://finance-app.itunes.apple.com/account/subscriptions"
                              : "https://play.google.com/store/account/subscriptions"))
                      : showMessage(
                          AppLocalizations.of(context)!.notSubscribedToStore,
                          false);
                }).vp(12)
              : Container(),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Text(
            AppLocalizations.of(context)!.logout,
            style: TextStyles.body.fontColor.bold,
          ).ripple(() async {
            await UserProfileManager().logout();
            await UserProfileManager().refreshProfile();
            context.push('/login');
          }).vp(12),
        ]);
  }

  supportView() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.support,
                  style: TextStyles.body.fontColor,
                  textAlign: TextAlign.left,
                ).ripple(() async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BrowserPage(
                            url: 'https://help.bstill.world',
                            title: AppLocalizations.of(context)!.support);
                      });
                  // context.push(whereToGo);
                }).vp(12),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ThemeIconWidget(
                    ThemeIcon.nextArrow,
                    size: 16,
                    color: AppTheme.singleton.fontColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.deleteAcc,
                  style: TextStyles.body.bold.redColor,
                  textAlign: TextAlign.left,
                ).ripple(() async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.deleteAcc),
                          content:
                              Text(AppLocalizations.of(context)!.deleteAccDesc),
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.cancel),
                              onPressed: (() => Navigator.of(context).pop()),
                            ),
                            TextButton(
                              child: Text(
                                  AppLocalizations.of(context)!.continueStr),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BrowserPage(
                                          url:
                                              'https://bstill.freshdesk.com/support/tickets/new?ticket_form=request_for_account_deletion',
                                          title: AppLocalizations.of(context)!
                                              .deleteAcc);
                                    });
                              },
                            ),
                          ],
                        );
                      });

                  // context.push(whereToGo);
                }).vp(12),
              ),
              // Expanded(
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: ThemeIconWidget(
              //       ThemeIcon.nextArrow,
              //       size: 16,
              //       color: AppTheme.singleton.fontColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        ]);
  }

  createFlexButton(label, whereToGo) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.body.fontColor,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: ThemeIconWidget(
              ThemeIcon.nextArrow,
              size: 16,
              color: AppTheme.singleton.fontColor,
            ),
          ),
        ),
      ],
    ).ripple(() {
            context.push(whereToGo);
          }).vp(12);
  }

  getSubscriptionInfo() async {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      customerInfo = await Purchases.getCustomerInfo();
      isSubscribedStore = customerInfo.activeSubscriptions.isNotEmpty;
      print(isSubscribedStore);

      isSubscribedSeeds =
          UserProfileManager().user!.active_subscription != '' &&
              (UserProfileManager().user!.subscribeVia == 'EFOREST_SEEDS' ||
                  UserProfileManager().user?.subscribeVia == 'EF2_FRUITS') &&
              UserProfileManager().user!.subscribeStatus == 'A';
      // print(isSubscribedStore);
      // print(UserProfileManager().user?.active_subscription);
      if (isSubscribedStore == true || isSubscribedSeeds == true) {
        setState(() {
          isSubscribed = true;
          subVia = UserProfileManager().user!.subscribeVia;
          if (subVia == 'EFOREST_SEEDS') {
            setState(() {
              subVia = 'EFOREST SEED';
            });
          } else if (subVia == 'Store.playStore') {
            setState(() {
              subVia = 'Google Play Store';
            });
          } else if (subVia == 'Store.appStore') {
            setState(() {
              subVia = 'App Store';
            });
          } else if (subVia == 'EF2_FRUITS') {
            setState(() {
              subVia = 'EFOREST² FRUITS';
            });
          }
        });
      } else {
        setState(() {
          isSubscribed = false;
        });
      }

      // return isSubscribedStore;
    }
  }

  showMessage(String message, bool isError) {
    GFToast.showToast(message, context,
        toastDuration: 3,
        toastPosition: GFToastPosition.TOP,
        textStyle: TextStyles.body.white,
        backgroundColor:
            isError == true ? AppTheme().redColor : AppTheme().successColor,
        trailing: Icon(
            isError == true ? Icons.error : Icons.check_circle_outline,
            color: AppTheme().lightColor));
    Icon(isError == true ? Icons.error : Icons.check_circle_outline,
        color: AppTheme().lightColor);
  }
}
