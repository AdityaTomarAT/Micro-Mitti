// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/All_Properties/all_properties.dart';
import 'package:micro_mitti/KYC/my_kyc.dart';
import 'package:micro_mitti/Other_Screens/about_us.dart';
import 'package:micro_mitti/dashboard.dart';
import 'package:micro_mitti/edit_profile.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/notification.dart';
import 'package:micro_mitti/sell/sel..dart';
import 'package:micro_mitti/settings.dart';
import 'package:micro_mitti/upcoming_properties.dart';
import 'dart:developer' as devtools show log;

GetStorage box = GetStorage();

class drawer extends StatefulWidget {
  drawer({
    Key? key,
  }) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  void initState() {
    // TODO: implement initState
    // DataController().getUserProfileData();
    userData();
    super.initState();
  }

  String userId = box.read('userId') ?? "";

  String name = "";
  String email = "";
  String profileImage = "";
  String number = "";

  Future<DocumentSnapshot<Object?>> userData() async {
    try {
      DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      var userData = snapshot.data() as Map<String, dynamic>;

      print('UserId: $userId');
      print('Name: ${userData['User_Name']}');
      print('Email: ${userData['email']}');

      setState(() {
        name = userData['User_Name'];
        email = userData['email'];
        profileImage = userData['profile_image'];
        number = userData['mobile_number'];
        // image = userData['']
      });

      return snapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.25,
      child: Scaffold(
        bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
        body: Column(
          // padding: EdgeInsets.zero,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5.5,
              decoration: BoxDecoration(
                color: Color(0xFFFECC00),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 35,
                        ),
                        child: (profileImage == "")
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 22,
                                  color: Colors.black,
                                )
                                // fit: BoxFit.fill,
                                )
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    profileImage,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image has finished loading
                                        return child;
                                      } else {
                                        // Image is still loading, show a loading indicator
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFECC00),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'Barlow'),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Text(
                                number,
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'Barlow'),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: 369,
                        // height: 272,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.6100000143051147),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(41),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x23000000),
                              blurRadius: 29,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Get.offAll(() => HomePageScreen());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.home,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Home',
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
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Get.to(() => Dashboard());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.dashboard,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Dashboard',
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
                              // ListTile(
                              //   onTap: () {
                              //     Get.to(() => NotificationScreen());
                              //   },
                              //   visualDensity:
                              //       VisualDensity(horizontal: -4, vertical: 4),
                              //   minLeadingWidth: 0,
                              //   minVerticalPadding: 0,
                              //   leading: Container(
                              //     width: 38,
                              //     height: 37,
                              //     decoration: ShapeDecoration(
                              //       color: Color(0xFFFECC00),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(8)),
                              //     ),
                              //     child: Center(
                              //       child: Icon(Icons.messenger_outlined,
                              //           color: Colors.black),
                              //     ),
                              //   ),
                              //   title: Text(
                              //     'Notifications',
                              //     textAlign: TextAlign.left,
                              //     style: TextStyle(
                              //       color: Color(0xFF302F2E),
                              //       fontSize: 15,
                              //       fontFamily: 'Barlow',
                              //       fontWeight: FontWeight.w500,
                              //       height: 0,
                              //     ),
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios_outlined,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => AllProperties());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.domain,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'All Properties',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF302F2E),
                                    fontSize: 15,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_outlined,
                                    color: Colors.black),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => AboutUs());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.alternate_email_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'About Us',
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
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => MyKYCScreen());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.verified_user,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Complete Your KYC',
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
                              // ListTile(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //     Get.to(() => Sell());
                              //   },
                              //   visualDensity:
                              //       VisualDensity(horizontal: -4, vertical: 4),
                              //   minLeadingWidth: 0,
                              //   minVerticalPadding: 0,
                              //   leading: Container(
                              //     width: 38,
                              //     height: 37,
                              //     decoration: ShapeDecoration(
                              //       color: Color(0xFFFECC00),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(8)),
                              //     ),
                              //     child: Center(
                              //       child: Icon(
                              //         Icons.sell,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //   ),
                              //   title: Text(
                              //     'Sell Status',
                              //     textAlign: TextAlign.left,
                              //     style: TextStyle(
                              //       color: Color(0xFF302F2E),
                              //       fontSize: 15,
                              //       fontFamily: 'Barlow',
                              //       fontWeight: FontWeight.w500,
                              //       height: 0,
                              //     ),
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios_outlined,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              // ListTile(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //     Get.to(() => Upcoming());
                              //   },
                              //   visualDensity:
                              //       VisualDensity(horizontal: -4, vertical: 4),
                              //   minLeadingWidth: 0,
                              //   minVerticalPadding: 0,
                              //   leading: Container(
                              //     width: 38,
                              //     height: 37,
                              //     decoration: ShapeDecoration(
                              //       color: Color(0xFFFECC00),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(8)),
                              //     ),
                              //     child: Center(
                              //       child: Icon(
                              //         Icons.hourglass_empty,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //   ),
                              //   title: Text(
                              //     'Join The Waitlist',
                              //     textAlign: TextAlign.left,
                              //     style: TextStyle(
                              //       color: Color(0xFF302F2E),
                              //       fontSize: 15,
                              //       fontFamily: 'Barlow',
                              //       fontWeight: FontWeight.w500,
                              //       height: 0,
                              //     ),
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios_outlined,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              ListTile(
                                onTap: () {
                                  Get.to(() => SettingsScreen());
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: 4),
                                minLeadingWidth: 0,
                                minVerticalPadding: 0,
                                leading: Container(
                                  width: 38,
                                  height: 37,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFECC00),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Settings',
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
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class appbar extends StatelessWidget {
  final String header;
  final IconData? iconData1;
  final IconData? iconData2;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  final double fontSize;

  const appbar({
    super.key,
    required this.header,
    required this.iconData1,
    required this.onPressed2,
    required this.onPressed1,
    this.iconData2,
    required this.fontSize,
  });

  // final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFECC00),
      width: MediaQuery.of(context).size.width,
      height: 110,
      child: Center(
        child: ListTile(
          minVerticalPadding: 55,
          leading: IconButton(
              onPressed: onPressed1,
              icon: Icon(
                iconData1,
                size: 25,
                color: Colors.black,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 50,
              // )
            ],
          ),
          trailing: IconButton(
              onPressed: onPressed2,
              icon: Icon(
                iconData2,
                size: 32,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}

void log(
  String screenId, {
  dynamic msg,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    devtools.log(
      msg.toString(),
      error: error,
      name: screenId,
      stackTrace: stackTrace,
    );



bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;
