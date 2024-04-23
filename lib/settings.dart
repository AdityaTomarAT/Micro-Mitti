// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:micro_mitti/Auth/FirstScreen.dart';
import 'package:micro_mitti/edit_profile.dart';
import 'package:micro_mitti/widget/myWidget.dart';

GetStorage box = GetStorage();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appbar(
              header: "SETTINGS",
              iconData1: Icons.arrow_back_ios_new_outlined,
              onPressed2: () {},
              onPressed1: () {
                Navigator.of(context).pop();
              },
              fontSize: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              tileColor: isSelected ? Colors.white : Color(0xFFFECC00),
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
                Navigator.of(context).pop();
                Get.to(() => EditProfile());
              },
              visualDensity: VisualDensity(horizontal: -4, vertical: 4),
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              leading: Container(
                width: 38,
                height: 37,
                decoration: ShapeDecoration(
                  color: isSelected ? Color(0xFFFECC00) : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                'Edit Profile',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF302F2E),
                  fontSize: 15,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListTile(
              tileColor: isSelected ? Colors.white : Color(0xFFFECC00),
              onTap: () async {
                GetStorage box = GetStorage();
                if ((box.hasData('userId')) ||
                    (box.hasData('UserName')) ||
                    (box.hasData('email')) ||
                    (box.hasData('number')) ||
                    (box.hasData('password')) ||
                    box.hasData('userEmail')) {
                  box.remove('userEmail');
                  box.remove('userId');
                  box.remove('userName');
                  box.remove('email');
                  box.remove('number');
                  box.remove('password');
                  print('User data is removed');
                  await FirebaseAuth.instance.signOut();
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut();
                  Navigator.pop(context);
                  Get.offAll(() => LoginOrSignupScreen());
                } else {}
              },
              visualDensity: VisualDensity(horizontal: -4, vertical: 4),
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              leading: Container(
                width: 38,
                height: 37,
                decoration: ShapeDecoration(
                  color: isSelected ? Color(0xFFFECC00) : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                  child: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                'Log Out',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color(0xFF302F2E),
                  fontSize: 15,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
