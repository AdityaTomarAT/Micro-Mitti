// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micro_mitti/Auth/loginscreen.dart';
import 'package:micro_mitti/Auth/signupscreen.dart';
import 'package:micro_mitti/explore/waitlist.dart';

class LoginOrSignupScreen extends StatefulWidget {
  LoginOrSignupScreen({super.key});

  @override
  State<LoginOrSignupScreen> createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  String useriD = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Image.asset(
        "assets/images/bottom_layout.png",
        // fit: BoxFit.cover,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6.5,
              ),
              Container(
                // margin:  EdgeInsets.only(top: 240),
                child: Text(
                  "JOIN THE WEALTH \nREVOLUTION IN INDORE.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 39,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: 220,
                height: 80,
              ),
              //  SizedBox(
              //   height: 250,
              // ),
              Expanded(child: SizedBox()),

              SizedBox(
                width: 292,
                height: 52,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        backgroundColor: Color(0xFFFECC00),
                        // padding:  EdgeInsets.symmetric(
                        //     horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                          fontFamily: 'Barlow',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ),
              SizedBox(
                height: 13,
              ),
              SizedBox(
                width: 292,
                height: 52,
                child: ElevatedButton(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(fontFamily: 'Barlow', color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Get.to(
                      () => SignupScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Color(0xFFFECC00),
                      // padding:  EdgeInsets.symmetric(
                      //     horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontFamily: 'Barlow',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              SizedBox(
                width: 292,
                height: 52,
                child: ElevatedButton(
                  child: Text(
                    'EXPLORE',
                    style: TextStyle(fontFamily: 'Barlow', color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaitlistScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      backgroundColor: Color(0xFFFECC00),
                      // padding:  EdgeInsets.symmetric(
                      //     horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontFamily: 'Barlow',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              // Align(
              //   // alignment: Alignment.bottomCenter,
              //   child: Image.asset(
              //     "assets/images/bottom_layout.png",
              //     fit: BoxFit.cover,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
