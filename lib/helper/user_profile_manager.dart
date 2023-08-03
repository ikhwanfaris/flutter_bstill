import 'package:flutter/cupertino.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class UserProfileManager {
  static final UserProfileManager _singleton = UserProfileManager._internal();
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? user;

  factory UserProfileManager() {
    return _singleton;
  }

  logout() {
    user = null;
    getIt<FirebaseManager>().logout();
  }

  UserProfileManager._internal();

  refreshProfile({VoidCallback? completionHandler}) async {
    if (auth.currentUser == null) {
      User? firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
      if (firebaseUser != null && firebaseUser.isAnonymous == false) {
        // user = await getIt<FirebaseManager>().getUser(auth.currentUser!.uid);
        user = null;
        if (completionHandler != null) {
          completionHandler();
        }
      } else {
        user = null;
        // await FirebaseAuth.instance.signInAnonymously();
      }
    } else {
      if (auth.currentUser!.isAnonymous == false) {
        user = await getIt<FirebaseManager>().getUser(auth.currentUser!.uid);
        if (user!.active_subscription != '') {
          await FirebaseManager()
              .checkSubscriptionStatus(user?.active_subscription);
        }

        if (completionHandler != null) {
          completionHandler();
        }
      }
    }
  }
}
