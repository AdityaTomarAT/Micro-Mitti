// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Auth/FirstScreen.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/usercontroller.dart';

GetStorage box = GetStorage();

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserController userController = Get.find<UserController>();

  void initState() {
    super.initState();
    navigateFromSplash();
  }

  void navigateFromSplash() async {
    await Future.delayed(Duration(seconds: 3));

    // Check if user data exists
    if ((box.hasData('email')) ||
        (box.hasData('userName')) ||
        box.hasData('number') ||
        box.hasData('password') ||
        box.hasData('userId') || box.hasData('userEmail') || box.hasData('userId')) {
      Get.offAll(() => HomePageScreen());
    } else {
      Get.offAll(() => LoginOrSignupScreen(), transition: Transition.fade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Image.asset('assets/images/bottom_layout.png'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.75,
              color: Color(0xFFFECC00),
              child: Center(
                child: Text(
                  "JOIN MICRO MITTI \nFOR WEALTH BUILDING \nBY LAND BANKING ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 236,
            height: 80,
          ),
        ],
      ),
    );
  }
}
