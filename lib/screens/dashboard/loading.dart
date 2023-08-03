import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser == null) {
        context.go('/login');
      } else {
        context.go('/home');
        // context.go('/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: SizedBox(
            height: 149,
            width: 100,
            // color: Colors.white,
            child: Image.asset(
              'assets/images/bstill-splash-screen-logo.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        decoration: const BoxDecoration(
          color: Color(0xff7c94b6),
          image: DecorationImage(
            opacity: 1,
            image: AssetImage('assets/images/bg-m-2.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
