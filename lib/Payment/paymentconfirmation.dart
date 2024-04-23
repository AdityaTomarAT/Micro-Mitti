// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Auth/signupscreen.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

GetStorage box = GetStorage();

class PaymentConfirmation extends StatefulWidget {
  // final int numberOfUnits;
  final int amountvalue;
  final int tenure;
  final String textofpayment;
  final String year;
  final String projectValue;
  final String landArea;
  final String saleValue;
  final String landMarketValue;
  final List<dynamic> image;
  final String name;
  final String docId;
  // final String? share_holder_name1;
  final String returns;
  // final String? share_holder_name2;
  final String invested;
  final List<dynamic> investors;
  final List<dynamic> shares;
  // final int? share_holder1;
  // final int? share_holder2;
  final String current_value;
  final String value_asset;
  final double ROI;
  final List<dynamic> pdfUrl;
  final String comingScreen;
  final String type;
  final String location;

  PaymentConfirmation({
    super.key,
    // required this.numberOfUnits,
    required this.textofpayment,
    required this.amountvalue,
    required this.year,
    required this.projectValue,
    required this.landArea,
    required this.saleValue,
    required this.landMarketValue,
    required this.image,
    required this.name,
    required this.docId,
    // this.share_holder_name1,
    required this.returns,
    // this.share_holder_name2,
    required this.invested,
    // this.share_holder1,
    // this.share_holder2,
    required this.current_value,
    required this.value_asset,
    required this.ROI,
    required this.pdfUrl,
    required this.comingScreen,
    required this.type,
    required this.location,
    required this.investors,
    required this.shares,
    required this.tenure,
  });

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  // final String? FirstName = box.read('firstName');
  // final String? LastName = box.read('lastName');
  // final String? email = box.read('email');
  // final String? mobilenumber = box.read('mobilenumber');

  var _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an  external wallet is selected
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData();
    print("Screen: ${widget.comingScreen}");
    print('IMage url: ${widget.image}');
    print('pdf Url : ${widget.pdfUrl}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

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
        name = userData['User_Name'];
        email = userData['email'];
        number = userData['mobile_number'];
      });

      return snapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<void> addPayment() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('payments');
      // String hashedPassword = _hashPassword(password);
      if (widget.comingScreen == "allprop") {
        await users.doc().set({
          'properties': widget.docId,
          'tenure': widget.year,
          'token_amount': widget.amountvalue,
          'transaction_id': '',
          // 'unit': widget.numberOfUnits,
          'user': userId,
          "type": "allprop"
        });
      } else if (widget.comingScreen == "home") {
        await users.doc().set({
          'properties': widget.docId,
          'tenure': widget.year,
          'token_amount': widget.amountvalue,
          'transaction_id': '',
          // 'unit': widget.numberOfUnits,
          'user': userId,
          "type": "home"
        });
      }

      print('Payment Data is added');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> addIntoDashBoardProperty() async {
    try {
      CollectionReference kycDetails =
          FirebaseFirestore.instance.collection('dashboard');

      CollectionReference personalDetails =
          kycDetails.doc(userId).collection(userId);

      await personalDetails.doc().set({
        'documents': widget.pdfUrl,
        'projected_ROI': widget.ROI,
        'property_image': widget.image,
        'property_name': widget.name,
        'land_area': widget.landArea,
        'land_market_value': widget.landMarketValue,
        'sale_value': widget.saleValue,
        'project_value': widget.projectValue,
        'current_value': widget.current_value,
        'invested': widget.invested,
        'investors': widget.investors,
        'returns': widget.returns,
        'shares': widget.shares,
        'value_asset': widget.value_asset,
        'users': [userId],
        'type': widget.type,
        "location": widget.location,
        "bookingAmount": widget.amountvalue,
        "tenure": widget.tenure
      });

      print('property add ho gyi');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  // int portfolio = int.parse(box.read('portfolio'));

  // Future<void> addIntoDashBoard() async {
  //   print('Total Investment: $portfolio');
  //   int investment = 0;
  //   setState(() {
  //     investment = portfolio + widget.amountvalue;
  //   });
  //   print('Investment for backend: $investment');
  //   try {
  //     CollectionReference dashboard =
  //         FirebaseFirestore.instance.collection('dashboard');

  //     await dashboard.doc(userId).set({
  //       // 'ROI': widget.amountvalue,
  //       // 'portfolio': investment,
  //       'total_investment': investment
  //     }, SetOptions(merge: true));

  //     print('investment ho gyi');
  //     print('value added in dashboard');
  //   } catch (e) {
  //     // Handle the exception
  //     print('Error adding user: ${e.toString()}');
  //   }
  // }

  Future<void> addIntoAllProperties() async {
    try {
      CollectionReference dashboard =
          FirebaseFirestore.instance.collection('Allproperties');

      await dashboard.doc(widget.docId).set({
        'users': [userId]
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> UpdateUserData() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('properties');

      // Use set function to add initial data

      await users.doc(widget.docId).set({
        'users': [userId]
      }, SetOptions(merge: true));
      print('user list is added');
    } catch (e) {
      // Handle the exception
      print('Error updating user: ${e.toString()}');
    }
  }

  Future<void> addIntoWaitingList() async {
    print('function start');
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('waiting_form');

      await users.add({
        'name': name,
        'email': email,
        'mobile': number,
        // 'address': Address.text,
        'investmentamount': widget.amountvalue,
        'userId': userId,
        'documnent_Id': widget.docId
      });

      print('function ends');
      print('value is added in form');
    } catch (e) {
      print('function failed');
      print('Error adding user: ${e.toString()}');
    }
  }

  // Future<void> addIntoProperties() async {
  //   try {
  //     CollectionReference users =
  //         FirebaseFirestore.instance.collection('properties');

  //     await users.doc(widget.docId).set({
  //       'users': [userId]
  //     }, SetOptions(merge: true));
  //     print('investment ho gyi');
  //     print('value added in all properties');
  //   } catch (e) {
  //     // Handle the exception
  //     print('Error adding user: ${e.toString()}');
  //   }
  // }

  // Future<void> fetchDataFromBackend2() async {
  //   int investment = 0;
  //   setState(() {
  //     investment = portfolio + widget.amountvalue;
  //   });
  //   print('User Id:- $userId');
  //   try {
  //     DocumentReference userDocRef =
  //         FirebaseFirestore.instance.collection('users').doc(userId);
  //     await userDocRef.set(
  //         {'portfolio': investment, 'investment': widget.amountvalue},
  //         SetOptions(merge: true));
  //     print('value added in portfolio');
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    "PAYMENT CONFIRMATION",
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 249, 227, 141),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 110.5,
                                    padding: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        widget.image[0],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 2.5,
                                  // )
                                  // ,
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Micro Mitti',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.name,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Project Value',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        widget.projectValue,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Sale value',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        (widget.saleValue
                                                                .isEmpty)
                                                            ? "No Data\nAvailable"
                                                            : widget.saleValue,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 32,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Land Area',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        widget.landArea,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Land Market Value',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2.5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        (widget.landMarketValue
                                                                .isEmpty)
                                                            ? "No Data\nAvailable"
                                                            : widget
                                                                .landMarketValue,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Booking Information',
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
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 20),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         'Unit',
                              //         style: TextStyle(
                              //           color: Color(0xFF302F2E),
                              //           fontSize: 15,
                              //           fontFamily: 'Barlow',
                              //           fontWeight: FontWeight.w500,
                              //           height: 0,
                              //           letterSpacing: -0.14,
                              //         ),
                              //       ),
                              //       Text(
                              //         "${widget.numberOfUnits}",
                              //         style: TextStyle(
                              //           color: Color(0xFF302F2E),
                              //           fontSize: 15,
                              //           fontFamily: 'Barlow',
                              //           fontWeight: FontWeight.w500,
                              //           height: 0,
                              //           letterSpacing: -0.14,
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.textofpayment,
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                    Text(
                                      "₹${widget.amountvalue}/-",
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
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
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tenure',
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                    Text(
                                      "${widget.tenure}",
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Personal Information',
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
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Full Name',
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
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
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mobile Number',
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                    Text(
                                      "$number",
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
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
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
                                        fontFamily: 'Barlow',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.14,
                                      ),
                                    ),
                                    Text(
                                      "$email",
                                      style: TextStyle(
                                        color: Color(0xFF302F2E),
                                        fontSize: 15,
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
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Total amount',
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      "${widget.amountvalue}/-",
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
                                  GestureDetector(
                                    onTap: () async {
                                      var options = {
                                        // 'external_wallet'
                                        'key': 'rzp_test_rYtVhGP3rOX9hv',
                                        'amount': (1 * 100),
                                        'name': 'Micro Mitti',
                                        'description': widget.name,
                                        'timeout': 60,
                                        'prefill': {
                                          'contact': number,
                                        'email': email
                                        }
                                        
                                      };
                                      _razorpay.open(options);
                                      // Get.snackbar(
                                      //     backgroundColor:
                                      //         Color.fromARGB(255, 246, 215, 44),
                                      //     'Waiting For Approval',
                                      //     'Please Wait for Approval');
                                      // Future.delayed(Duration(seconds: 5), () {
                                      //   addPayment();
                                      //   addIntoDashBoardProperty();
                                      //   // addIntoDashBoard();
                                      //   addIntoWaitingList();
                                      //   // addIntoProperties();
                                      //   if (widget.comingScreen == "allprop") {
                                      //     addIntoAllProperties();
                                      //   } else if (widget.comingScreen ==
                                      //       "home") {
                                      //     UpdateUserData();
                                      //   }
                                      //   // fetchDataFromBackend2();
                                      //   Get.to(() => HomePageScreen());

                                      //   Get.snackbar(
                                      //       backgroundColor:
                                      //           const Color.fromARGB(
                                      //               255, 92, 206, 95),
                                      //       'Investment Done Successfully',
                                      //       'Go to dashboard to see investment Details');
                                      // });
                                    },
                                    child: Container(
                                      child: Text(
                                        'Pay Now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 14,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          letterSpacing: -0.28,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      width: 113,
                                      height: 38,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFFECC00),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Color(0xFFFECC00)),
                                          borderRadius:
                                              BorderRadius.circular(29),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/bottom_layout.png"),
          ),
        ],
      ),
    );
  }
}
