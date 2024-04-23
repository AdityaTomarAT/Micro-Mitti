// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/widget/myWidget.dart';
import 'package:uuid/uuid.dart';

GetStorage box = GetStorage();

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final userId = box.read('userId');

  @override
  void initState() {
    super.initState();
    setState(() {
      isChanged = false;
      genderChanged = false;
      isRefreshed = true;
    });
    Future.delayed(Duration(milliseconds: 850), () {
      setState(() {
        isRefreshed = false;
      });
    });
    userData().whenComplete(() => {
          if (gender == "Male")
            {MaleContainerColor = Color(0xFFFECC00)}
          else if (gender == "Female")
            {FemaleContainerColor = Color(0xFFFECC00)}
        });
    if (gender == "Male") {
      MaleContainerColor = Color(0xFFFECC00);
    } else if (gender == "Female") {
      FemaleContainerColor = Color(0xFFFECC00);
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController Location = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();

  // String personName = "Person Name";

  DateTime selectedDate = DateTime.now();

  bool dateSelected = false;

  String date = "";
  String month = "";
  String year = "";
  String date2 = "";
  String month2 = "";
  String year2 = "";

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
        dateSelected = true;
        selectedDate = picked;
        date = DateFormat('dd').format(picked);
        month = DateFormat('MMMM').format(picked);
        year = DateFormat('yyyy').format(picked);
        // DOB.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        isFetching = true;
        if (image != null) {
          _imageFile = File(image.path);
          uploadUserProfileImage(_imageFile!);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isFetching = false;
      });
    });
  }

  Color MaleContainerColor = Colors.white;
  Color FemaleContainerColor = Colors.white;

  String Gender = "";

  changeMaleContainerColor() {
    setState(() {
      genderChanged = true;
      print('Gender: $genderChanged');
      Gender = "Male";
      print('Gender: $Gender');
      MaleContainerColor = Color(0xFFFECC00);
      FemaleContainerColor = Colors.white;
    });
  }

  changeFemaleContainerColor() {
    setState(() {
      genderChanged = true;
      print('Gender: $genderChanged');
      Gender = "Female";
      print('Gender: $Gender');
      MaleContainerColor = Colors.white;
      FemaleContainerColor = Color(0xFFFECC00);
      ;
    });
  }

  String userName = "";
  String userEmail = "";
  String userNumber = "";
  String gender = "";
  // String userLocation = "";
  String DOB = "";

  Future<DocumentSnapshot<Object?>> userData() async {
    try {
      DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      var userData = snapshot.data() as Map<String, dynamic>;

      print('Name: ${userData['User_Name']}');
      print('Email: ${userData['email']}');
      print('Email: ${userData['mobile_number']}');
      print('Location: ${userData['Locaiton']}');
      print('DOB: ${userData['DOB']}');

      setState(() {
        name.text = userData['User_Name'];
        userEmail = userData['email'];
        userNumber = userData['mobile_number'];
        gender = userData['Gender'] ?? '';
        Location.text = userData['Locaiton'] ?? '';
        DOB = userData['DOB'] ?? '';
        imageasset = userData['profile_image'] ?? "";
        email.text = userData['email'];

        print('User Gender: $gender');
        // Split the string using "-"

        // image = userData['']
      });

      List<String> dateParts = DOB.split("-");

      // Store the parts in three different variables
      setState(() {
        date2 = dateParts[0];
        month2 = dateParts[1];
        year2 = dateParts[2];
      });

      // Print the results
      print("Day: $date2");
      print("Month: $month2");
      print("Year: $year2");

      return snapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<void> UpdateUserData({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'User_Name': name.text,
      }, SetOptions(merge: true));
      print('User data is added');
      await users.doc(userId).update({'User_Name': name.text});
      print('User data is updated');

      userData();
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData0({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'email': email.text,
      }, SetOptions(merge: true));
      print('User data is added');
      await users.doc(userId).update({'User_Name': name.text});
      print('User data is updated');

      userData();
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData2({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'Locaiton': Location.text,
      }, SetOptions(merge: true));
      print('User data is added');

      await users.doc(userId).update({'User_Name': name.text});
      print('User data is updated');

      userData();
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData3({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'Gender': Gender,
      }, SetOptions(merge: true));
      print('User data is added');

      await users.doc(userId).update({'User_Name': name.text});
      print('User data is updated');

      userData();
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData4({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'DOB': "${date}-${month}-${year}",
      }, SetOptions(merge: true));
      print('User data is added');

      await users.doc(userId).update({'User_Name': name.text});
      print('User data is updated');

      userData();
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData1({
    required String userId,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Use set function to add initial data

      await users.doc(userId).set({
        'profile_image': imageasset,
      }, SetOptions(merge: true));
      userData();
      print('User data is updated');
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }
  // Future<void> UpdateUserData2({
  //   required String userId,
  // }) async {
  //   try {
  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('users');

  //     // Use set function to add initial data
  //     if (name.text.isEmpty) {
  //       Get.snackbar("No field is Selected",
  //           'Please upload Image if you want to update..!!');
  //     } else {
  //       await users.doc(userId).set({
  //         'profile_image': imageasset,
  //       }, SetOptions(merge: true));
  //       userData();
  //       print('User data is updated');
  //     }
  //   } catch (e) {
  //     // Handle the exception
  //     print('Error updating user: ${e.toString()}');
  //   }
  // }

  String imageasset = "";
  bool isFetching = false;

  Future<void> uploadUserProfileImage(File imageFile) async {
    try {
      // Get the current user UID using Firebase Authentication
      setState(() {
        isFetching = true;
      });

      final FirebaseStorage storage = FirebaseStorage.instance;

      String fileName = 'user_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('userProfile/$userId/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        imageasset = downloadURL;
        isFetching = false;
      });
      print('Download URL: $downloadURL');
      print('Image uploaded successfully!');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  bool isChanged = false;
  bool genderChanged = false;
  bool locationChanged = false;
  bool emailChanged = false;

  bool isRefreshed = false;

  void finalUpdate() {
    if (isChanged) {
      UpdateUserData(userId: userId);
    }
    if (dateSelected) {
      UpdateUserData4(userId: userId);
    }
    if (locationChanged) {
      UpdateUserData2(userId: userId);
    }
    if (emailChanged) {
      UpdateUserData0(userId: userId);
    }
    if (genderChanged) {
      UpdateUserData3(userId: userId);
    }
    if (_imageFile != null) {
      UpdateUserData1(userId: userId);
    }
    Get.snackbar('Details are updated successfully',
        "Your details are updated in databse..!!",
        backgroundColor: const Color.fromARGB(255, 84, 215, 88));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 18,
          ),
          Container(
            child: ListTile(
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
                title: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 100,
                  child: Text(
                    'EDIT PROFILE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  decoration: ShapeDecoration(
                    color: Color(0xFFFECC00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: isRefreshed
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFECC00),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Stack(children: [
                                (imageasset == "")
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            AssetImage('assets/images/pfp.png'),
                                        radius: 45,
                                      )
                                    : isFetching
                                        ? CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 45,
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFECC00),
                                            ))
                                        : Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                imageasset,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    // Image has finished loading
                                                    return child;
                                                  } else {
                                                    // Image is still loading, show a loading indicator
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFFECC00),
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
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImage();
                                      },
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Color(0xFFFECC00),
                                        child: Icon(Icons.camera_alt_outlined),
                                      ),
                                    ))
                              ]),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextFormField(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Bardow'),
                                      onChanged: (value) {
                                        setState(() {
                                          isChanged = true;
                                        });
                                      },
                                      // readOnly: true,
                                      // enabled: false,
                                      controller: name,
                                      // cursorColor: Color(0xFFFECC00),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: Color(0x00CCCDCD),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCCCDCD)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                    "assets/images/edit_button.png"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                'Mobile Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 16,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${userNumber}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.bold,
                                      height: 0,
                                      letterSpacing: -0.32,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: Color(0x00CCCDCD),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFCCCDCD)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                'Email Address',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 16,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Bardow'),
                                onChanged: (value) {
                                  setState(() {
                                    emailChanged = true;
                                  });
                                },
                                controller: email,
                                // cursorColor: Color(0xFFFECC00),
                                decoration: InputDecoration(
                                    hintText: "Enter Your Email",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 14,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                      letterSpacing: -0.14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: Color(0x00CCCDCD),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFCCCDCD)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                'Gender',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 16,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    changeMaleContainerColor();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Male',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 16,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    ),
                                    width: 150,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: MaleContainerColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFFECC00)),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    changeFemaleContainerColor();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Female',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 16,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    ),
                                    width: 150,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: FemaleContainerColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFFFECC00)),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                'Location',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF302F2E),
                                  fontSize: 14,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                  letterSpacing: -0.14,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Bardow'),
                                onChanged: (value) {
                                  setState(() {
                                    locationChanged = true;
                                  });
                                },
                                controller: Location,
                                // cursorColor: Color(0xFFFECC00),
                                decoration: InputDecoration(
                                    hintText: "Enter Your Location",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 14,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                      letterSpacing: -0.14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: Color(0x00CCCDCD),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFCCCDCD)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  // margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                'Birthday',
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
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: (!dateSelected && date2.isNotEmpty)
                                      ? Text(
                                          date2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 15,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                            letterSpacing: -0.15,
                                          ),
                                        )
                                      : dateSelected
                                          ? Text(
                                              date,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            )
                                          : Text(
                                              'Day',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            ),
                                  width: 100,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Color(0x00CCCDCD),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCCCDCD)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: (!dateSelected && month2.isNotEmpty)
                                      ? Text(
                                          month2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 15,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                            letterSpacing: -0.15,
                                          ),
                                        )
                                      : dateSelected
                                          ? Text(
                                              month,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            )
                                          : Text(
                                              'Month',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            ),
                                  width: 100,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Color(0x00CCCDCD),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCCCDCD)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: (!dateSelected && year2.isNotEmpty)
                                      ? Text(
                                          year2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 15,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                            letterSpacing: -0.15,
                                          ),
                                        )
                                      : (dateSelected)
                                          ? Text(
                                              year,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            )
                                          : Text(
                                              'Year',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 15,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.15,
                                              ),
                                            ),
                                  width: 100,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Color(0x00CCCDCD),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFCCCDCD)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isChanged &&
                                !dateSelected &&
                                !locationChanged &&
                                !genderChanged && 
                                !emailChanged &&
                                (_imageFile == null)) {
                              Get.snackbar(
                                  'Please Select Field', "No Field is selected",
                                  backgroundColor:
                                      Color.fromARGB(255, 215, 84, 84));
                            } else {
                              setState(() {
                                isRefreshed = true;
                              });
                              finalUpdate();
                              Future.delayed(Duration(milliseconds: 850), () {
                                setState(() {
                                  isRefreshed = false;
                                });
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 18,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: -0.32,
                              ),
                            ),
                            width: 150,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Color(0xFFFECC00),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color(0xFFFECC00)),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateContainer(String value) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(
          color: Color(0xFF302F2E),
          fontSize: 15,
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
        ),
      ),
      width: 60,
      height: 40,
      decoration: ShapeDecoration(
        color: Color(0x00CCCDCD),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
