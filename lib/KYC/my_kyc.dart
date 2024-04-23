// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:micro_mitti/KYC/form_bankdetail.dart';
import 'package:micro_mitti/KYC/form_nomineedetails.dart';
import 'package:micro_mitti/KYC/form_personaldetail.dart';
import 'package:micro_mitti/homepage.dart';

enum KYCForms { personalDetails, bankDetails, nomineeDetails }

class MyKYCScreen extends StatefulWidget {
  const MyKYCScreen({super.key});

  @override
  _MyKYCScreenState createState() => _MyKYCScreenState();
}

class _MyKYCScreenState extends State<MyKYCScreen> {
  KYCForms currentForm = KYCForms.personalDetails;

  void changeForm(KYCForms form) {
    setState(() {
      currentForm = form;
    });
  }

  void goToNextForm() {
    setState(() {
      if (currentForm == KYCForms.personalDetails) {
        currentForm = KYCForms.bankDetails;
      } else if (currentForm == KYCForms.bankDetails) {
        currentForm = KYCForms.nomineeDetails;
      }
    });
  }

  Widget getForm(KYCForms form) {
    switch (form) {
      case KYCForms.personalDetails:
        return PersonalDetailsForm(onNext: goToNextForm);
      case KYCForms.bankDetails:
        return BankDetailsForm(onNext: goToNextForm);
      case KYCForms.nomineeDetails:
        return NomineeDetailsForm();
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Image.asset(
        'assets/images/bottom_layout.png',
        width: MediaQuery.of(context).size.width,
      ),
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
                    // Navigator.of(context).pop();
                     Get.offAll(() => HomePageScreen());
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.black,
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "My KYC",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () {
                  Get.offAll(() => HomePageScreen());
                },
                child: Text(
                  "SKIP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          FormIndicator(
            currentForm: currentForm,
            onStepTap: (form) {
              // changeForm(form);
            },
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: getForm(currentForm),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class FormIndicator extends StatelessWidget {
  final KYCForms currentForm;
  final Function(KYCForms) onStepTap; // Callback function for step tap

  FormIndicator({Key? key, required this.currentForm, required this.onStepTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep(
              1,
              "Personal \nDetails",
              currentForm == KYCForms.personalDetails ||
                  currentForm == KYCForms.bankDetails ||
                  currentForm == KYCForms.nomineeDetails,
              KYCForms.personalDetails),
          _buildLine(currentForm == KYCForms.bankDetails ||
              currentForm == KYCForms.nomineeDetails),
          _buildStep(
              2,
              "Bank\nDetails",
              currentForm == KYCForms.bankDetails ||
                  currentForm == KYCForms.nomineeDetails,
              KYCForms.bankDetails),
          _buildLine(currentForm == KYCForms.nomineeDetails),
          _buildStep(3, "Nominee \nDetails",
              currentForm == KYCForms.nomineeDetails, KYCForms.nomineeDetails),
        ],
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        height: 2,
        color: isActive ? Color(0xFFFECC00) : Colors.grey,
      ),
    );
  }

  Widget _buildStep(int number, String title, bool isActive, KYCForms form) {
    return GestureDetector(
      onTap: () => onStepTap(form),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: isActive ? Color(0xFFFECC00) : Colors.transparent,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? Color(0xFFFECC00) : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: Color(0xFF302F2E),
                    fontSize: 12,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.12,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Color(0xFF302F2E),
                fontSize: 12,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w700,
                height: 1.2,
                letterSpacing: -0.12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
