// Nominee detail Form ...
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/homepage.dart';

GetStorage box = GetStorage();

class NomineeDetailsForm extends StatefulWidget {
  @override
  State<NomineeDetailsForm> createState() => _NomineeDetailsFormState();
}

class _NomineeDetailsFormState extends State<NomineeDetailsForm> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(initialDate.year - 5);
    DateTime lastDate = DateTime(initialDate.year + 5);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        selectedDate = picked;
        DOB.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController DOB = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();
  TextEditingController realtion = TextEditingController();

  bool nameError = false;
  bool dobError = false;
  bool aadharError = false;
  bool realtionError = false;

  // String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserDocument();
    final emailId = box.read('userEmail');
    final userId2 = box.read('userId');
    print('user Details: $userId2, $emailId');
   
  }

  String userId = box.read('userId');

  Future<void> addUser() async {
    try {
      CollectionReference kycDetails =
          FirebaseFirestore.instance.collection('kyc_details');

      CollectionReference bankDetails =
          kycDetails.doc(userId).collection('nominee_details');

      await bankDetails.doc(userId).set({
        'user_id': userId,
        'name': name.text,
        'DOB': DOB.text,
        'aadhar_number': aadharNumber.text,
        'relation': realtion.text,
      });

      print('user details added');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> submitForm() async {
    if (name.text.isEmpty || aadharNumber.text.isEmpty) {
      setState(() {
        nameError = name.text.isEmpty;
        aadharError = aadharNumber.text.isEmpty;
        print('DOB and Relation: ${DOB.text}, ${realtion.text}');
      });
      await addUser();
    } else if (aadharNumber.text.length != 12) {
      setState(() {
        aadharError = true;
      });
    } else if (DOB.text.isEmpty) {
      setState(() {
        dobError = DOB.text.isEmpty;
      });
    } else if (realtion.text.isEmpty) {
      setState(() {
        realtionError = realtion.text.isEmpty;
      });
    } else {
      addUser();
      Get.snackbar(
          'KYC Details are added ', 'Please Wait for verification procedure',
          backgroundColor: const Color.fromARGB(255, 94, 214, 98));
      Get.offAll(() => HomePageScreen());
    }
  }

  Future<Map<String, dynamic>> fetchUserDocument() async {
    try {
      DocumentSnapshot<Object?> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('kyc_details')
              .doc(userId) 
              .collection('nominee_details')
              .doc(userId) 
              .get();

      if (documentSnapshot.exists) {
        print('Fetched data: ${documentSnapshot.data()}');
        setState(() {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            name.text = data['name'];
            DOB.text = data['DOB'];
            aadharNumber.text = data['aadhar_number'];
            realtion.text = data['relation'];
          }
        });

        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Document not found for userId: $userId');
        return {}; 
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                      const Text(
                        'Full Name*',
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
                    ],
                  )),
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
                    onTap: () {
                      setState(() {
                        nameError = false;
                      });
                    },
                    controller: name,
                    decoration: const InputDecoration(
                        hintText: "Enter Full Name",
                        isDense: true,
                        border: InputBorder.none),
                  ),
                ),
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
            if (nameError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Full Name',
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
              height: 20,
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
                      'Date of  birth*',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF302F2E),
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
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: ShapeDecoration(
                  color: const Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                      dobError = false;
                    },
                    controller: DOB,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Select Date",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (dobError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Date Of Birth',
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
              height: 20,
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
                      'Aadhaar Number*',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF302F2E),
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
                      controller: aadharNumber,
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      onTap: () {
                        setState(() {
                          aadharError = false;
                        });
                      },
                      decoration: const InputDecoration(
                          counterText: "",
                          hintText: "Enter Aadhar Number",
                          isDense: true,
                          border: InputBorder.none),
                    ),
                  ),
                  width: 318,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: const Color(0x00CCCDCD),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            if (aadharError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Aadhar Number ',
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
              height: 20,
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
                      'Relation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF302F2E),
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
                      controller: realtion,
                      onTap: () {
                        setState(() {
                          realtionError = false;
                        });
                      },
                      // keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Enter Relation to the Nominee*",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  width: 318,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: const Color(0x00CCCDCD),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            if (realtionError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Relation Name',
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
              height: 20,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await submitForm();
              },
              child: Container(
                child: const Center(
                  child: Text(
                    'Confirm',
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
            )
          ],
        ),
      ),
    );
  }
}
