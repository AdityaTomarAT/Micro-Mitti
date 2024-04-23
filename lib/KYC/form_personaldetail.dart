// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

GetStorage box = GetStorage();

class PersonalDetailsForm extends StatefulWidget {
  final VoidCallback onNext;

  PersonalDetailsForm({Key? key, required this.onNext}) : super(key: key);

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  bool isChecked = false;
  bool checkBoxError = false;
  File? _imageFile;
  File? _imageFile2;

  String? emailId;
  // String userId = "";

  TextEditingController mobilenumber = TextEditingController();
  TextEditingController aadharName = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();

  bool aadharNameError = false;
  bool aadharNumberError = false;
  bool aadharNumberError2 = false;
  bool mobilenumbererror = false;
  bool mobilenumbererror2 = false;

  @override
  void initState() {
    super.initState();
    userData();
    fetchUserDocument();
  }

  String mobile = box.read('mobileNumber') ?? '';

  String userId = box.read('userId');

  String name = "";
  String email = "";
  String number = "";

  Future<DocumentSnapshot<Object?>> userData() async {
    try {
      DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      var userData = snapshot.data() as Map<String, dynamic>;

      print('Name: ${userData['User_Name']}');
      print('Email: ${userData['email']}');

      setState(() {
        aadharName.text = userData['User_Name'];
        email = userData['email'];
        mobilenumber.text = userData['mobile_number'];
      });
      if(aadharName.text.isEmpty && mobilenumber.text.isEmpty){
        setState(() {
          mobilenumber.text = mobile;
        });
      }

      return snapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (image != null) {
          _imageFile = File(image.path);
          uploadUserProfileImage(_imageFile!);
        } else {
          print('No image selected.');
        }
      });
      setState(() {
        front = false;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickImage2() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (image != null) {
          _imageFile2 = File(image.path);
          uploadUserProfileImage2(_imageFile2!);
        } else {
          print('No image selected.');
        }
      });
      setState(() {
        Back = false;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  String frontImage = "";
  Future<String> uploadUserProfileImage(File imageFile) async {
    try {
      // Get the current user UID using Firebase Authentication

      final FirebaseStorage storage = FirebaseStorage.instance;

      String fileName = 'front_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('KycDetails/$userId/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        frontImage = downloadURL;
      });

      print('Download URL: $downloadURL');
      print('Image uploaded successfully!');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
    }
    return "";
  }

  String backImage = "";

  Future<String> uploadUserProfileImage2(File imageFile) async {
    try {
      // Get the current user UID using Firebase Authentication

      final FirebaseStorage storage = FirebaseStorage.instance;

      String fileName = 'back_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('KycDetails/$userId/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        backImage = downloadURL;
      });

      print('Download URL: $downloadURL');
      print('Image uploaded successfully!');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
    }
    return "";
  }

  bool front = false;
  bool Back = false;

  Future<void> addUser() async {
    uploadUserProfileImage(_imageFile!);
    uploadUserProfileImage2(_imageFile2!);

    try {
      CollectionReference kycDetails =
          FirebaseFirestore.instance.collection('kyc_details');

      CollectionReference personalDetails =
          kycDetails.doc(userId).collection('personal_details');

      await personalDetails.doc(userId).set({
        'user_id': userId,
        'mobile': mobilenumber.text,
        'aadhar_Name': aadharName.text,
        'aadhar_Number': aadharNumber.text,
        'front_Image': frontImage,
        'back_Image': backImage,
        // Storing hashed password
      });

      print('ho gyi add');

      print('user details added');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  bool isFileEmpty(File file) {
    return file.existsSync() && file.lengthSync() == 0;
  }

  Future<void> submitForm() async {
    if (aadharName.text.isEmpty ||
        (mobilenumber.text.isEmpty) ||
        (aadharNumber.text.isEmpty)) {
      setState(() {
        aadharNameError = aadharName.text.isEmpty;
        aadharNumberError = aadharNumber.text.isEmpty;
        aadharNumberError2 = aadharNumber.text.length != 12;
        front = _imageFile == null;
        Back = _imageFile2 == null;
        mobilenumbererror = mobilenumber.text.isEmpty;
        mobilenumbererror2 = mobilenumber.text.length != 10;
        // emailError2 =
      });
    } else if (_imageFile == null) {
      setState(() {
        front = true;
      });
    } else if (_imageFile2 == null) {
      setState(() {
        Back = true;
      });
    } else if (aadharNumber.text.length != 12) {
      setState(() {
        aadharNumberError2 = true;
      });
    } else if (mobilenumber.text.isEmpty) {
      setState(() {
        mobilenumbererror = true;
      });
    } else if (mobilenumber.text.length < 10) {
      setState(() {
        mobilenumbererror2 = true;
      });
    } else if (!isChecked) {
      setState(() {
        checkBoxError = true;
      });
    } else {
      await addUser();
      print('ho gyi add');
      // uploadUserProfileImage(_imageFile2!);
      print('ho gyi add');

      widget.onNext();
    }
  }

  String frontUrl = "";
  String backUrl = "";

  Future<Map<String, dynamic>> fetchUserDocument() async {
    try {
      // Fetching the single document based on userId
      DocumentSnapshot<Object?> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('kyc_details')
              .doc(userId) // Specify the userId here
              .collection('personal_details')
              .doc(userId) // Specify the document ID here
              .get();

      // Printing fetched data
      if (documentSnapshot.exists) {
        setState(() {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            mobilenumber.text = data['mobile'] ?? '';
            aadharName.text = data['aadhar_Name'] ?? '';
            aadharNumber.text = data['aadhar_Number'] ?? '';
            backUrl = data['back_Image'];
            frontUrl = data['front_Image'];

            print('Front: $frontUrl');
            print('backUrl: $backUrl');
          }
        });
        print('Fetched data: ${documentSnapshot.data()}');
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Document not found for userId: $userId');
        return {}; // Return an empty map as a default value
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
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
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Name as per Aadhaar*',
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
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    // keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    ],
                    onTap: () {
                      setState(() {
                        aadharNameError = false;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: aadharName,
                    cursorColor: Color(0xFFFECC00),
                    decoration: InputDecoration(
                        isDense: true, border: InputBorder.none),
                  ),
                ),
                height: 45,
                decoration: ShapeDecoration(
                  color: Color(0x00CCCDCD),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            if (aadharNameError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Please Enter Aadhaar Name',
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
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      onTap: () {
                        setState(() {
                          aadharNumberError = false;
                          aadharNumberError2 = false;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: aadharNumber,
                      cursorColor: Color(0xFFFECC00),
                      decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          border: InputBorder.none),
                    ),
                  ),
                  width: 318,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: Color(0x00CCCDCD),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            if (aadharNumberError2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Full Aadhaar Number',
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
            // if (aadharNumberError)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 25),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Please Enter Aadhaar Number',
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
                      'Mobile Number*',
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
                  controller: mobilenumber,
                  style: const TextStyle(
                    fontFamily: 'Barlow',
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    setState(() {
                      mobilenumber.text = value;
                      mobilenumbererror = false;
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
                            mobilenumbererror2 = false;
                          });
                          showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                textStyle: TextStyle(fontFamily: 'Barlow'),
                                bottomSheetHeight: 550,
                              ),
                              onSelect: (value) {
                                setState(() {
                                  mobilenumbererror2 = false;
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
                    suffixIcon: mobilenumber.text.length == 10
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
            // if (mobilenumbererror)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 25),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Please Enter Mobile Number',
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
            if (mobilenumbererror2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Phone Number',
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
                      'Upload Aadhaar images*',
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
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    print("Container tapped");
                    _pickImage();
                  },
                  child: DottedBorder(
                    color: Color(0xFF302F2E),
                    radius: Radius.circular(10),
                    child: Container(
                      width: 370,
                      height: 40, // Adjust the height as needed
                      decoration: ShapeDecoration(
                        color: _imageFile == null
                            ? Color(0x00CCCDCD)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _imageFile == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select front image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFCCCDCD),
                                      fontSize: 14,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -0.14,
                                    ),
                                  ),
                                  Icon(
                                    Icons.upload,
                                    color: Color(0xFFFECC00),
                                  )
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: (frontUrl.isNotEmpty)
                                  ? Image.network(frontUrl, fit: BoxFit.cover)
                                  : Image.file(_imageFile!, fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (front)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Upload Front Image',
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
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    print("Container tapped");
                    _pickImage2();
                  },
                  child: DottedBorder(
                    color: Color(0xFF302F2E),
                    radius: Radius.circular(10),
                    child: Container(
                      width: 370,
                      height: 40, // Adjust the height as needed
                      decoration: ShapeDecoration(
                        color: _imageFile2 == null
                            ? Color(0x00CCCDCD)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          // side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _imageFile2 == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select back image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFCCCDCD),
                                      fontSize: 14,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -0.14,
                                    ),
                                  ),
                                  Icon(
                                    Icons.upload,
                                    color: Color(0xFFFECC00),
                                  )
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: (backUrl.isNotEmpty)
                                  ? Image.network(backUrl, fit: BoxFit.cover)
                                  : Image.file(_imageFile2!,
                                      fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (Back)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Upload back Image',
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      shape: CircleBorder(),
                      side: BorderSide(color: Color(0xFFFECC00), width: 2),
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
                    Flexible(
                      child: Text(
                        'I consent to the collect and securely store my Aadhaar.',
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
                  ],
                ),
              ),
            ),
            if (checkBoxError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
            GestureDetector(
              onTap: () async {
                print('Front Bool: $front');
                print('Back Bool: $Back');
                await submitForm();
                // widget.onNext;
              },
              child: Container(
                child: Center(
                  child: Text(
                    'Next',
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
                  color: Color(0xFFFECC00),
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
