// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:micro_mitti/Auth/signupscreen.dart';
import 'package:micro_mitti/homepage.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:micro_mitti/Auth/otpverificationscreen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

GetStorage box = GetStorage();

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController selectedCountryCode = TextEditingController();

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.snackbar('Logged in with facebook', "Sucessfull");
        Get.to(() => HomePageScreen());
      } else {
        print('Failed to log in with Facebook: ${result.status}');
      }
    } catch (e) {
      print('Error logging in with Facebook: $e');
    }
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFECC00),
          ),
        ),
        barrierDismissible: false,
      );

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          // Get.back();
        },
        verificationFailed: (FirebaseAuthException e) {
          // Get.back();
          // showSnackbar('Verification Failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) async {
          Get.back();
          Get.to(() => OTPVerificationScreen(),
              arguments: [verificationId, phoneNumber]);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Get.back();
          // showSnackbar('Code Auto Retrieval Timeout');
        },
      );
    } catch (e) {
      Get.back();
      showSnackbar('Error: $e');
    }
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'Error',
      "Please try different login methods",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  void _userLogin() async {
    String mobile = phonenumberController.text;
    if (mobile.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter the mobile number!",
        colorText: Colors.white,
      );
    } else {
      bool connected = await isInternetConnected();
      if (!connected) {
        showNoInternetDialog(context);
      } else {
        signInWithPhoneNumber(
          "+${selectedCountry.phoneCode}$mobile",
        );
      }
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please check your internet connection and try again."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    phonenumberController.dispose();
    super.dispose();
  }

  Future<void> signInWithGoogle() async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFECC00),
          ),
        ),
        barrierDismissible: false,
      );

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String? userId = userCredential.user?.uid;

      String? emailAddress = userCredential.user?.email;
      String? userName = userCredential.user?.displayName;

      box.write('userEmail', userCredential.user?.email);
      box.write('userId', userCredential.user?.uid);

      print(
          'User details in google sign in account: $userName, $userId, $emailAddress');

      // Dismiss the dialog after the asynchronous tasks are completed

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      QuerySnapshot<Object?> stream =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> userList = stream.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      if (userSnapshot.exists ||
          userList.contains(userName) ||
          userList.contains(emailAddress)) {
        Get.back();
        // User exists, route to homepage
        Get.to(() => HomePageScreen());
      } else {
        Get.back();
        Get.to(
          () => SignupScreen(email: emailAddress),
        );
      }
    } catch (e) {
      // Handle the error if needed
      print("Error: $e");
      Get.back();
    }
  }

  bool mobilenamerror2 = false;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
          child: Image.asset(
        'assets/images/bottom_layout2.png',
        fit: BoxFit.cover,
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: const Color(0xFFFECC00),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListTile(
              minVerticalPadding: 55,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/images/back_button.png'),
                ),
              ),
              // IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LOG IN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        currentWidth < 360
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height / 13,
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 8,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 220,
                                height: 90,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                )),
                          ],
                        ),
                        currentWidth < 360
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height / 8,
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 11,
                              ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xFFFECC00),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 17,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PHONE NUMBER',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              controller: phonenumberController,
                              style: const TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  phonenumberController.text = value;
                                  mobilenamerror2 = false;
                                });
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Mobile number",
                                hintStyle: TextStyle(
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 0),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                          context: context,
                                          countryListTheme:
                                              const CountryListThemeData(
                                            bottomSheetHeight: 550,
                                          ),
                                          onSelect: (value) {
                                            setState(() {
                                              selectedCountry = value;
                                            });
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                        style: const TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon:
                                    phonenumberController.text.length == 10
                                        ? Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.all(10.0),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                            child: const Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )
                                        : null,
                              ),
                            ),
                          ),
                        ),
                        if (mobilenamerror2)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Please Enter Correct Phone Number',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 13,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (phonenumberController.text.length < 10) {
                              setState(() {
                                mobilenamerror2 = true;
                              });
                            } else {
                              _userLogin();
                            }
                          },
                          // onTap: _userLogin,
                          child: Container(
                            width: 220,
                            height: 39,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'SEND OTP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignupScreen(
                                  email: "",
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CREATE AN ACCOUNT | SIGN UP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'OR SIGN UP WITH',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 120),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    signInWithGoogle();
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      height: 20,
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              // GestureDetector(
                              //     onTap: () {
                              //       print('Facebook login tapped');
                              //       loginWithFacebook();
                              //     },
                              //     child: CircleAvatar(
                              //       radius: 25,
                              //       backgroundColor: Colors.white,
                              //       child: Image.asset(
                              //         'assets/images/facebook.png',
                              //         height: 20,
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
