// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/All_Properties/all_properties.dart';
import 'package:micro_mitti/upcoming_properties.dart';

GetStorage box = GetStorage();

class WaitlistForm extends StatefulWidget {
  final String? screen;
  WaitlistForm({super.key, this.screen});

  @override
  State<WaitlistForm> createState() => _WaitlistFormState();
}

class _WaitlistFormState extends State<WaitlistForm> {
  final docId = Get.arguments[0];
  // List<bool> submitted = Get.arguments[1];
  final userId = box.read('userId');

  @override
  void initState() {
    super.initState();
    // print('Bool value: $submitted');
    print('docId value: $docId');
    print('Card Value: ${Upcoming.cardValue.value}');
    print('userid is: $userId');
  }

  TextEditingController Name = TextEditingController();

  TextEditingController Email = TextEditingController();

  TextEditingController Mobilenumber = TextEditingController();

  TextEditingController Investmentamount = TextEditingController();
  TextEditingController Address = TextEditingController();

  bool nameerror = false;

  bool emailerror = false;

  bool mobilenumbererror = false;
  bool mobilenumbererror2 = false;

  bool investmentamounterror = false;
  bool addresserror = false;

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    return emailRegex.hasMatch(email);
  }

  String status = "true";

  Future<void> addData() async {
    try {
      _showSubmittedPopup(context);

      CollectionReference users =
          FirebaseFirestore.instance.collection('waiting_form');

      await users.add({
        'name': Name.text,
        'email': Email.text,
        'mobile': Mobilenumber.text,
        'address': Address.text,
        'investmentamount': Investmentamount.text,
        'userId': userId,
        'documnent_Id': docId
      });

      print('value is added in form');
    } catch (e) {
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> updateData() async {
    try {
      // _showSubmittedPopup(context);

      CollectionReference users =
          FirebaseFirestore.instance.collection('waitinglist');

      await users.doc(docId).set({
        'users': [userId]
      }, SetOptions(merge: true));

      print('value is updted in form');
    } catch (e) {
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> updateData2() async {
    try {
      // _showSubmittedPopup(context);

      CollectionReference users =
          FirebaseFirestore.instance.collection('Allproperties');

      await users.doc(docId).set({
        'users': [userId]
      }, SetOptions(merge: true));

      print('value is updted in form');
    } catch (e) {
      print('Error adding user: ${e.toString()}');
    }
  }

  String emailerrorRegeex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';

  Future<void> submitForm() async {
    if (Name.text.isEmpty ||
        (Email.text.isEmpty && !isValidEmail(Email.text)) ||
        Mobilenumber.text.isEmpty ||
        Investmentamount.text.isEmpty ||
        Address.text.isEmpty) {
      setState(() {
        nameerror = Name.text.isEmpty;
        emailerror = Email.text.isEmpty || !isValidEmail(Email.text);
        mobilenumbererror = Mobilenumber.text.isEmpty;
        addresserror = Address.text.isEmpty;
        investmentamounterror = Investmentamount.text.isEmpty;
      });
    } else if (!isValidEmail(Email.text)) {
      setState(() {
        emailerror = true; // Set email error to true if the email is not valid
      });
    } else if (Mobilenumber.text.length != 10) {
      setState(() {
        mobilenumbererror2 = true;
      });
    } else {
      addData();
      if (widget.screen == "allprop") {
        updateData2();
      } else {
        updateData();
      }
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

  void _showSubmittedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                "Submitted",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Barlow'),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (widget.screen == "allprop") {
                  Get.offAll(() => AllProperties());
                } else {
                  Get.offAll(() => Upcoming());
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow'),

                    // onPressed: () {
                    //   Get.to(() => Upcoming());
                    // },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFECC00),
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListTile(
              minVerticalPadding: 55,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.black,
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Waitlist Form",
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
          SizedBox(
            height: 30,
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                    'Name*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F5E5E),
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.14,
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: Name,
                    onTap: () {
                      setState(() {
                        nameerror = false;
                      });
                    },
                    decoration: const InputDecoration(
                        isDense: true, border: InputBorder.none),
                  ),
                ),
                // width: 318,
                height: 45,
                decoration: ShapeDecoration(
                  color: const Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                    'Email*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F5E5E),
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.14,
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: Email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () {
                    setState(() {
                      emailerror = false;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      emailerror = !isValidEmail(Email.text);
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, isDense: true),
                  // validator: isValidEmail(),
                ),
              ),
              // width: 318,
              height: 45,
              decoration: ShapeDecoration(
                color: const Color(0x00CCCDCD),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                    'Mobile Number*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F5E5E),
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.14,
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
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
                            countryListTheme: const CountryListThemeData(
                              textStyle: TextStyle(fontFamily: 'Barlow'),
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
              padding: const EdgeInsets.symmetric(horizontal: 45),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                    'Investment Amount*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F5E5E),
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.14,
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: Investmentamount,
                  onTap: () {
                    setState(() {
                      investmentamounterror = false;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              // width: 318,
              height: 45,
              decoration: ShapeDecoration(
                color: const Color(0x00CCCDCD),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (investmentamounterror)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please Enter Investment amount',
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                    'Address*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5F5E5E),
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: -0.14,
                    ),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: Address,
                  onTap: () {
                    setState(() {
                      addresserror = false;
                    });
                  },
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              // width: 318,
              height: 100,
              decoration: ShapeDecoration(
                color: const Color(0x00CCCDCD),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (addresserror)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please Enter Address',
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
            height: MediaQuery.of(context).size.height / 7,
          ),
          GestureDetector(
            onTap: () {
              submitForm();
              // addData();
              // _showSubmittedPopup(context);
            },
            child: Container(
              child: const Center(
                child: Text(
                  'Join',
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
              width: 224,
              height: 39,
              decoration: ShapeDecoration(
                color: const Color(0xFFFECC00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // SizedBox(
          //     width: MediaQuery.of(context).size.width,
          //     child: Image.asset("assets/images/bottom_layout.png"))
        ],
      ),
    );
  }
}
