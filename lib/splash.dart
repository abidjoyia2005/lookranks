import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottom.dart';
//import 'package:flutter_application_1/chooselogin.dart';

import 'package:flutter_application_1/onbording.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getid();

    navigateToNextScreen();
    
  }

  Future<void> navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    bool isLogin =
        prefs.getBool('isLogin') ?? false; // Check if the user is logged in

    // Simulate loading or processing here
    await Future.delayed(Duration(seconds: 1));

    if (isFirstTime) {
      // If it's the first time, navigate to onboarding
      //prefs.setBool('isFirstTime', false);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) => OnboardingScreen()),
      // );
      if (isLogin) {
        // If the user is logged in, navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Bottom()),
        );
      } else {
        // If the user is not logged in, navigate to the login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => OnboardingScreen()),
        );
      }
    } else {
      // If it's not the first time, check if the user is logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
          ),
          Center(
            child: Container(
                height: 130,
                width: 130,
                child: Image.asset('assets/images/logo.png')),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height / 2.9,
          // ),
          Spacer(),

          Container(
            child: GradientText(
              "LookRanks",
              style: TextStyle(
                fontFamily: "Lemon",
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              colors: [
                Colors.blueAccent,
                Colors.pinkAccent,
                // Colors.blueGrey,
                // Colors.green
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
