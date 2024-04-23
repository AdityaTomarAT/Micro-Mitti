import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Auth/signupscreen.dart';
import 'package:micro_mitti/KYC/my_kyc.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pinput.dart';
import 'package:telephony/telephony.dart' show Telephony; 

import 'package:micro_mitti/homepage.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Telephony telephony; // Declare telephony late and non-nullable

  String textReceived = "";

  final TextEditingController pinController = TextEditingController();
   String verificationId = "";
   String phoneNumber ="";
  FirebaseAuth auth = FirebaseAuth.instance;
  int _start = 30;
  bool _canResend = false;
  Timer? _timer;

  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;


  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      telephony = Telephony.instance; // Initialize telephony only on Android
      setState(() {
        verificationId = Get.arguments[0];
        phoneNumber = Get.arguments[1];
      });
      startTimer();
      listeningToIncomingSms(context);
    } else if(Platform.isIOS){
      _initInteractor();
       controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) {
        setState(() {
          pinController.text = code; 
        });
      },
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
    }
  }

   Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    final appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }

  void listeningToIncomingSms(BuildContext context) {
    if (Platform.isAndroid) {
      telephony.listenIncomingSms(
        onNewMessage: ( message) {
          print('Sms Received: ${message.body}');

          if (message.body!.contains('micromitti-68ea0')) {
            String otpCode = message.body!.substring(0, 6);
            setState(() {
              pinController.text = otpCode;
            });

            verifyOtp(verificationId, otpCode);
          }
        },
        listenInBackground: false,
      );
    } 
  }
  

  @override
  void dispose() {
    if (Platform.isAndroid) {
      // telephony.(); // Cancel SMS listening when the widget is disposed
    }
    pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 30;
    _canResend = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
          _canResend = true;
        });
      } else {
        setState(() => _start--);
      }
    });
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Get.to(SignupScreen());
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("Verification Failed", e.message.toString(),
            colorText: Colors.white);
      },
      codeSent: (String verId, int? resendToken) {
        setState(() => verificationId = verId);
        startTimer();
      },
      codeAutoRetrievalTimeout: (String verId) {
        setState(() => verificationId = verId);
      },
    );
  }

  Future<void> verifyOtp(String verificationId, String userOtp) async {
    if (pinController.text.isEmpty) {
      Get.snackbar('Verification Error', "Otp Code Can't be Empty",
          colorText: Colors.white, backgroundColor: Colors.red);
    } else {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFECC00),
          ),
        ),
        barrierDismissible: false,
      );
      try {
        PhoneAuthCredential creds = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: userOtp);
        UserCredential userCredential = await auth.signInWithCredential(creds);
        User? user = userCredential.user;
        if (user != null) {
          print('User Id: ${user.uid}');

          GetStorage box = GetStorage();
          box.write('userId', user.uid);
          box.write('mobileNumber', phoneNumber);

          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .listen((DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              Get.offAll(() => HomePageScreen());
            } else {
              // Add your logic for new user registration
              Get.offAll(() => MyKYCScreen());
            }
          });
        }
        Get.back();
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Verification Error", e.message.toString(),
            colorText: Colors.white);
        Get.back();
      }
    }
  }

  void _resendCode() {
    startTimer();
    signInWithPhoneNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: 225,
        decoration: BoxDecoration(color: Color(0xFFFECC00)),
        child: Image.asset('assets/images/bottom_layout2.png'),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFFFECC00),
            width: MediaQuery.of(context).size.width,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Image.asset(
                          "assets/images/logo.png",
                          width: 236,
                          height: 80,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          'ENTER OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        currentWidth < 370
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Pinput(
                                  length: 6,
                                  controller: pinController,
                                  onCompleted: (value) =>
                                      verifyOtp(verificationId, value),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Pinput(
                                  length: 6,
                                  controller: pinController,
                                  onCompleted: (value) =>
                                      verifyOtp(verificationId, value),
                                ),
                              ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: 224,
                          height: 39,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              backgroundColor: Color(0xFFFECC00),
                            ),
                            onPressed: () =>
                                verifyOtp(verificationId, pinController.text),
                            child: const Text(
                              'SUBMIT',
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
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !_canResend,
                    child: Text(
                      'Wait $_start seconds',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Barlow',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Barlow',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _canResend ? _resendCode : null,
                    child: Text(
                      'Resend new code',
                      style: TextStyle(fontSize: 12, fontFamily: 'Barlow'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
