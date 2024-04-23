// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/widget/myWidget.dart';

GetStorage box = GetStorage();

class ContactUs extends StatefulWidget {
  ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController Name = TextEditingController();

  TextEditingController Email = TextEditingController();

  TextEditingController Mobilenumber = TextEditingController();

  TextEditingController Remarks = TextEditingController();

  bool nameerror = false;

  bool emailerror = false;
  bool emailerror2 = false;

  bool mobilenumbererror = false;
  bool mobilenumbererror2 = false;

  bool remarkserror = false;

  bool isValidEmail(String email) {
    String emailRegex =
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // Adjust the regex as needed
    return RegExp(emailRegex).hasMatch(email);
  }

  final userId = box.read('userId');

  Future<void>  addData() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('contactus');

      await users.doc(userId).set({
        'userId': userId,
        'name': Name.text,
        'email': Email.text,
        'mobile': Mobilenumber.text,
        'remarks': Remarks.text,
      });

      print('Data is added succesfully');

      Get.snackbar(
        "Success",
        "Form is Submitted, Team will connect to you soon",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      Future.delayed(Duration(milliseconds: 700), () {
        Get.offAll(() => HomePageScreen());
      });
    } catch (e) {
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> submitForm() async {
    if (Name.text.isEmpty ||
        Mobilenumber.text.isEmpty ||
        Remarks.text.isEmpty) {
      setState(() {
        nameerror = Name.text.isEmpty;
        mobilenumbererror = Mobilenumber.text.isEmpty;
        remarkserror = Remarks.text.isEmpty;
      });
    } else if (Mobilenumber.text.length != 10) {
      setState(() {
        mobilenumbererror2 = true;
      });
    } else {
      // Email is valid, proceed with addData()
      addData();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            appbar(
              header: 'CONTACT US',
              iconData1: Icons.arrow_back_ios_new,
              onPressed2: () {},
              onPressed1: () {
                Navigator.of(context).pop();
              },
              fontSize: 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Any Questions or Remarks?\nJust Write us a message',
                style: TextStyle(
                  color: Color(0xFF474645),
                  fontSize: 18,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      'Name*',
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: Name,
                    onTap: () {
                      setState(() {
                        nameerror = false;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, isDense: true),
                    style: TextStyle(fontFamily: 'Barlow',),
                  ),
                ),
                height: 40,
                decoration: ShapeDecoration(
                  color: Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (nameerror)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Name',
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: Email,
                    onTap: () {
                      setState(() {
                        emailerror = false;
                        // emailerror2 = false;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        emailerror = !isValidEmail(Email.text);
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, isDense: true),
                    style: TextStyle(fontFamily: 'Barlow'),
                  ),
                ),
                // width: 318,
                height: 40,
                decoration: ShapeDecoration(
                  color: Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (emailerror)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Valid Email',
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
            if (emailerror2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Valid Email',
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
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
                  controller: Mobilenumber,
                  style: const TextStyle(
                    fontFamily: 'Barlow',
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                
                  onChanged: (value) {
                    setState(() {
                      Mobilenumber.text = value;
                
                      mobilenumbererror2 = false;
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
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            mobilenumbererror = false;
                          });
                          showCountryPicker(
                              context: context,
                              countryListTheme:
                                  const CountryListThemeData(
                                textStyle:
                                    TextStyle(fontFamily: 'Barlow'),
                                bottomSheetHeight: 550,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                  // mobilenumbererror2 = false;
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
                              fontWeight: FontWeight.bold, fontFamily: 'Barlow'
                            ),
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: Mobilenumber.text.length == 10
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
              height: 10,
            ),
            if (mobilenumbererror)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
            if (mobilenumbererror2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Correct Mobile Number',
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Remarks*',
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 163,
                decoration: ShapeDecoration(
                  color: Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side:
                        BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: Remarks,
                    onTap: () {
                      setState(() {
                        remarkserror = false;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, isDense: true),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (remarkserror)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Remarks',
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
              height: 30,
            ),
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
                  // Get.to(HomePageScreen());
                  await submitForm();
                },
                child: Text(
                  'SEND',
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
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
