// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:micro_mitti/Auth/loginscreen.dart';
import 'package:micro_mitti/KYC/my_kyc.dart';
import 'package:micro_mitti/databaseservices.dart';
import 'package:micro_mitti/documents/pdfView.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/Auth/otpverificationscreen.dart';
import 'package:crypto/crypto.dart';
import 'package:micro_mitti/usercontroller.dart';
import 'dart:convert';

import 'package:micro_mitti/usermodel.dart';
import 'package:url_launcher/url_launcher.dart';

String _hashPassword(String password) {
  var bytes = utf8.encode(password); // Data being hashed
  return sha256.convert(bytes).toString();
}

Future<void> addUser({
  required String userId,
  required String firstname,
  required String lastname,
  required String email,
  required String mobilenumber,
  required String password,
}) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String hashedPassword = _hashPassword(password);

    await users.doc(userId).set({
      'user_id': userId,
      'email': email,
      'User_Name': "${firstname} ${lastname}",
      'mobile_number': mobilenumber,
      'password': hashedPassword,
      'investment': 0000,
      'portfolio': 0000,
      'ROI': 0000,
      'profile_image': ""
    });

    box.write('email', email);
    box.write('userName', "${firstname} ${lastname}");
    box.write('number', mobilenumber);
    box.write('password', hashedPassword);

    print('User Data is added');
    sendEmail(
        recipientEMail: email,
        mailMessage:
            "Thank You for Registering on Micro Mitti. We are pleasured to have you onboard");
    Get.back();

    Get.to(() => MyKYCScreen());
  } catch (e) {
    // Handle the exception
    print('Error adding user: ${e.toString()}');
  }
}

void sendEmail(
    {required String recipientEMail, required String mailMessage}) async {
  String userName = "dev22.mxpertz@gmail.com";
  String passowrd = "gnujlybfbpunzdvy";
  final smtpServer = gmail(userName, passowrd);
  final message = Message()
    ..from = Address(userName, 'Mail Service')
    ..recipients.add(email.text)
    ..subject = 'Thank you'
    ..text =
        'Thank You for Registering on Micro Mitti. We are pleasured to have you onboard';

  try {
    await send(message, smtpServer);
    Get.snackbar('Email', 'Registered Successfully');
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

TextEditingController Firstname = TextEditingController();

TextEditingController Lastname = TextEditingController();

TextEditingController email = TextEditingController();

TextEditingController mobile = TextEditingController();

TextEditingController password = TextEditingController();

TextEditingController cnfpassword = TextEditingController();

GetStorage box = GetStorage();

class SignupScreen extends StatefulWidget {
  final String? email;
  SignupScreen({super.key, this.email});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userId = box.read('userId');
  var emailId = box.read('userEmail');
  @override
  void initState() {
    super.initState();
    print('init running');
    fetchDataFromBackend();
    Firstname.clear();
    Lastname.clear();
    mobile.clear();
    password.clear();
    cnfpassword.clear();
    setState(() {
      email.text = widget.email ?? "";
    });

    // Now you can use userId in your code
    // ...
  }

  String generateRandomUserId() {
    // Generate a random string for the userId
    const String characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 28; i++) {
      buffer.write(characters[random.nextInt(characters.length)]);
    }
    return buffer.toString();
  }

  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> submitForm() async {}

  bool firstnamerror = false;

  bool lasttnamerror = false;

  bool mobilenamerror = false;
  bool mobilenamerror2 = false;

  bool emailerror = false;
  bool emailerror2 = false;

  bool passowrdnamerror2 = false;
  bool passowrdnamerror = false;

  bool cnfpassowrdnamerror = false;
  bool cnfpassowrdnamerror2 = false;

  bool passwordMatchError = false;

  // final userId = Get.arguments[0];

  final _formKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool isVisible2 = false;

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

  List<Map<String, dynamic>> users = [];

  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      QuerySnapshot<Object?> stream =
          await FirebaseFirestore.instance.collection('users').get();

      List<Map<String, dynamic>> userList = stream.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        users = userList;
      });

      print('Users List: $users');

      print('Fetched data: $users');
      return stream;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  bool isEmailAndMobileNumberExist(
      List<Map<String, dynamic>> userList, String email, String mobileNumber) {
    for (var user in userList) {
      if (user['mobile_number'] == mobileNumber) {
        return true; // Found a match
      }
    }
    return false; // No match found
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Show loading indicator
      Get.dialog(
        Center(
            child: CircularProgressIndicator(
          color: Color(0xFFFECC00),
        )),
        barrierDismissible:
            false, // Prevents the dialog from being dismissed manually
      );

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          Get.back(); // Dismiss loading indicator
          // authentication successful, do something
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.back(); // Dismiss loading indicator
          // authentication failed, do something
        },
        codeSent: (String verificationId, int? resendToken) async {
          // code sent to phone number, save verificationId for later use
          Get.back(); // Dismiss loading indicator before navigating to OTP screen
          Get.to(() => OTPVerificationScreen(),
              arguments: [verificationId, phoneNumber]);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Optional: handle auto retrieval timeout
        },
      );
    } catch (e) {
      Get.back(); // Ensure loading indicator is hidden on error
      // Handle any other errors
    }
  }

  bool isChecked = false;
  bool checkBoxError = false;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return Scaffold(
      bottomNavigationBar: Image.asset("assets/images/bottom_layout.png"),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          
          Container(
            color: Color(0xFFFECC00),
            child: ListTile(
              
              minVerticalPadding: 40,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/images/back_button.png")),
              // children: [
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Barlow'),
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Text(
                      'CREATE AN ACCOUNT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'First Name*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFCCCDCD))),
                              height: 45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  onTap: () {
                                    setState(() {
                                      firstnamerror = false;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: Firstname,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    // errorBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.red, width: 1.2),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (firstnamerror)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter First Name',
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
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Last Name*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFCCCDCD))),
                              height: 45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  onTap: () {
                                    setState(() {
                                      lasttnamerror = false;
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: Lastname,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    // errorBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.red, width: 1.2),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          if (lasttnamerror)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Last Name',
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Email*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFCCCDCD))),
                              height: 45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  onTap: () {
                                    setState(() {
                                      emailerror = false;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      emailerror = !isValidEmail(email.text);
                                    });
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: email,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          // if (emailerror)
                          //   Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 35),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'Please Enter Valid Email Address',
                          //           style: TextStyle(
                          //             color: Colors.red,
                          //             fontSize: 14,
                          //             fontFamily: 'Barlow',
                          //             fontWeight: FontWeight.w500,
                          //             height: 0,
                          //             letterSpacing: -0.14,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Mobile Number*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xFFCCCDCD),
                                ),
                                // borderRadius: BorderRadius.circular(15),
                              ),
                              height: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                // cursorColor: Colors.white,
                                controller: mobile,
                                style: const TextStyle(
                                  fontFamily: 'Barlow',
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    mobile.text = value;
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
                                      EdgeInsets.fromLTRB(0, 15, 0, 10),
                                  prefixIcon: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          mobilenamerror = false;
                                        });
                                        showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                const CountryListThemeData(
                                              textStyle: TextStyle(
                                                  fontFamily: 'Barlow'),
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
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Barlow'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  suffixIcon: mobile.text.length == 10
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
                          SizedBox(
                            height: 5,
                          ),
                          if (mobilenamerror)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Mobile Number',
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
                          if (mobilenamerror2)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Password*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFCCCDCD))),
                              height: 45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  obscureText: !isVisible,
                                  onTap: () {
                                    setState(() {
                                      passowrdnamerror = false;
                                      passowrdnamerror2 = false;
                                    });
                                    if (password.text == cnfpassword.text) {
                                      setState(() {
                                        passwordMatchError = false;
                                      });
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      passowrdnamerror = false;
                                      passowrdnamerror2 = false;
                                    });
                                    if (password.text == cnfpassword.text) {
                                      setState(() {
                                        passwordMatchError = false;
                                      });
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: password,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    // errorBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.red, width: 1.2),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (passowrdnamerror)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Password',
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
                          if (passowrdnamerror2)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Minimum 8 characters',
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
                          if (passwordMatchError)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passwords do not match',
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Confirm Password*',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xFFCCCDCD))),
                              height: 45,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  obscureText: !isVisible2,
                                  onTap: () {
                                    setState(() {
                                      cnfpassowrdnamerror2 = false;
                                      cnfpassowrdnamerror = false;
                                    });
                                    if (password.text == cnfpassword.text) {
                                      setState(() {
                                        passwordMatchError = false;
                                      });
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      cnfpassowrdnamerror2 = false;
                                      cnfpassowrdnamerror = false;
                                    });
                                    if (password.text == cnfpassword.text) {
                                      setState(() {
                                        passwordMatchError = false;
                                      });
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: cnfpassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible2 = !isVisible2;
                                        });
                                      },
                                      icon: Icon(
                                        isVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    // errorBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.red, width: 1.2),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (cnfpassowrdnamerror)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Password',
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
                          if (cnfpassowrdnamerror2)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Please Enter Minimum 8 characters',
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
                          if (passwordMatchError)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passwords do not match',
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              shape: CircleBorder(),
                              side: BorderSide(
                                  color: Color(0xFFFECC00), width: 2),
                              activeColor: Color(0xFFFECC00),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  checkBoxError =
                                      false; // Reset error when the checkbox state changes
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: TextStyle(
                                    color: Color(0xFF302F2E),
                                    fontSize: 14,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    // letterSpacing: -0.14,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    String text =
                                        "https://firebasestorage.googleapis.com/v0/b/micromitti-68ea0.appspot.com/o/Terms%2FTerms%26Conditions(MicroMitti).pdf?alt=media&token=268c454f-aad0-469d-8894-ff374a276a90";
                                    Get.to(() => PdfViewerPage(
                                          pdfUrl: text,
                                          fileName: "Terms & Conditions",
                                        ));
                                  },
                                  child: Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                      color: Color(0xFFFECC00),
                                      fontSize: 14,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      // letterSpacing: -0.14,
                                    ),
                                  ),
                                ),
                                Text(
                                  '.',
                                  style: TextStyle(
                                    color: Color(0xFF302F2E),
                                    fontSize: 14,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    // letterSpacing: -0.14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (checkBoxError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please select the checkbox.',
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
                    SizedBox(height: 8),
                    SizedBox(
                      width: 224,
                      height: 39,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              backgroundColor: Color(0xFFFECC00)),
                          onPressed: () async {
                            bool isError = false;
                            if (!isChecked) {
                              setState(() {
                                checkBoxError = true;
                                isError = true;
                              });
                            }
                            print('Check box error bool: $checkBoxError');
                            print('Check box bool: $isChecked');
                            bool exists = isEmailAndMobileNumberExist(
                                users, email.text, mobile.text);
                            // Flag to track if any error occurs

                            if (Firstname.text.isEmpty ||
                                Lastname.text.isEmpty ||
                                mobile.text.isEmpty ||
                                password.text.isEmpty ||
                                (email.text.isEmpty &&
                                    !isValidEmail(email.text)) ||
                                cnfpassword.text.isEmpty ||
                                (password.text != cnfpassword.text)) {
                              setState(() {
                                firstnamerror = Firstname.text.isEmpty;
                                lasttnamerror = Lastname.text.isEmpty;
                                mobilenamerror = mobile.text.isEmpty;
                                emailerror = email.text.isEmpty;
                                emailerror2 = !isValidEmail(email.text);
                                passowrdnamerror = password.text.isEmpty;
                                cnfpassowrdnamerror = cnfpassword.text.isEmpty;
                                passowrdnamerror2 = password.text.isEmpty;
                                cnfpassowrdnamerror2 = cnfpassword.text.isEmpty;
                                passwordMatchError =
                                    (password.text != cnfpassword.text);
                              });
                              isError = true;
                            } else if (password.text.length < 8) {
                              setState(() {
                                passowrdnamerror2 = true;
                              });
                              isError = true;
                            } else if (mobile.text.length < 10) {
                              setState(() {
                                mobilenamerror2 = true;
                              });
                              isError = true;
                            } else if (cnfpassword.text.length < 8) {
                              setState(() {
                                cnfpassowrdnamerror2 = true;
                              });
                              isError = true;
                            } else if (cnfpassword.text != password.text) {
                              setState(() {
                                cnfpassowrdnamerror = true;
                                passowrdnamerror = true;
                              });
                              isError = true;
                            } else if (exists) {
                              print('User Exist in the backend');
                              Get.snackbar(
                                  "You Can't Register with Same Mobile Number",
                                  'Email and Mobile Number already exist',
                                  backgroundColor:
                                      Color.fromARGB(255, 249, 71, 59));
                              isError = true;
                            } else if (userId == null || userId.isEmpty) {
                              // Generate random userId
                              userId = generateRandomUserId();
                              print("User id :$userId");
                              // Save the generated userId
                              box.write('userId', userId);
                            }
                            if (!isError) {
                              Get.dialog(
                                Center(
                                    child: CircularProgressIndicator(
                                  color: Color(0xFFFECC00),
                                )),
                                barrierDismissible: false, //
                              );
                              await addUser(
                                  userId: userId,
                                  firstname: Firstname.text,
                                  lastname: Lastname.text,
                                  email: email.text,
                                  mobilenumber: mobile.text,
                                  password: password.text);
                            }
                          },
                          child: Text(
                            'SUBMIT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text(
                        'Already have an account?   LOG IN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF302F2E),
                          fontSize: 14,
                          fontFamily: 'Barlow',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void savelocal() {
  //   UserModel newUser = UserModel(
  //     userId: 'some_unique_id', // Generate or fetch a unique ID
  //     firstname: Firstname.text,
  //     lastname: Lastname.text,
  //     email: email.text,
  //     mobilenumber: mobile.text,
  //     password: password.text, // Consider hashing the password
  //   );
  // }
}
