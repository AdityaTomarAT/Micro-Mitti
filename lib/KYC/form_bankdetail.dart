// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

class BankDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  BankDetailsForm({Key? key, required this.onNext}) : super(key: key);

  @override
  State<BankDetailsForm> createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<BankDetailsForm> {
  bool? _isChecked1 = false;
  bool? _isChecked2 = false;

  String? _selectedBank;
  String accountType = "";
  String bank = "";

  List<String> indianBanks = [
    'State Bank of India (SBI)',
    'Punjab National Bank (PNB)',
    'Bank of Baroda',
    // ... Add all other banks here
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Citibank',
    'HSBC',
    'Standard Chartered Bank',
    'AU Small Finance Bank',
    // ...
  ];

  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController IFSCcode = TextEditingController();

  bool accountHolderNameError = false;
  bool accountNumberError = false;
  bool IFSCcodeError = false;
  bool bankError = false;
  bool accountTypeError = false;

  // String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserDocument();
    final emailId = box.read('userEmail');
    final userId2 = box.read('userId');
    print('user Details: $userId2, $emailId');
    // setState(() {
    //   userId = box.read('userId');
    //   // email.text = emailId;
    // });
  }

  String userId = box.read('userId');

  Future<void> addUser() async {
    try {
      CollectionReference kycDetails =
          FirebaseFirestore.instance.collection('kyc_details');

      CollectionReference bankDetails =
          kycDetails.doc(userId).collection('bank_details');

      await bankDetails.doc(userId).set({
        'user_id': userId,
        'IFSC_Code': IFSCcode.text,
        'account_type': accountType,
        'bank_name': bank,
        'account_Holder_Name': accountHolderName.text,
        'account_holder_Number': accountNumber.text,
      });

      print('user details added');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> submitForm() async {
    if (accountHolderName.text.isEmpty ||
        accountNumber.text.isEmpty ||
        IFSCcode.text.isEmpty ||
        _selectedBank == null ||
        accountType.isEmpty) {
      setState(() {
        accountHolderNameError = accountHolderName.text.isEmpty;
        accountNumberError = accountNumber.text.isEmpty;
        IFSCcodeError = IFSCcode.text.isEmpty;
        bankError = _selectedBank == null;
        accountTypeError = accountType.isEmpty;
      });
    } else {
      await addUser();
      widget.onNext();
    }
  }

  Future<Map<String, dynamic>> fetchUserDocument() async {
    try {
      // Fetching the single document based on userId
      DocumentSnapshot<Object?> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('kyc_details')
              .doc(userId) // Specify the userId here
              .collection('bank_details')
              .doc(userId) // Specify the document ID here
              .get();

      // Printing fetched data
      if (documentSnapshot.exists) {
        print('Fetched data: ${documentSnapshot.data()}');
        setState(() {
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (data != null) {
            _selectedBank = data['bank_name'];
            accountHolderName.text = data['account_Holder_Name'];
            accountNumber.text = data['account_holder_Number'];
            IFSCcode.text = data['IFSC_Code'];
          }
        });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      shape: CircleBorder(),
                      side: BorderSide(color: Color(0xFFFECC00), width: 2),
                      activeColor: Color(0xFFFECC00),
                      value: _isChecked1,
                      onChanged: _isChecked2!
                          ? null
                          : (bool? value) {
                              setState(() {
                                _isChecked1 = value;
                                accountType = 'Savings';
                                print('Account Type = $accountType');
                              });
                            },
                    ),
                    Flexible(
                        child: Text(
                      'Saving',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF302F2E),
                        fontSize: 18,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.18,
                      ),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                      shape: CircleBorder(),
                      side: BorderSide(color: Color(0xFFFECC00), width: 2),
                      activeColor: Color(0xFFFECC00),
                      value: _isChecked2,
                      onChanged: _isChecked1!
                          ? null
                          : (bool? value) {
                              setState(() {
                                _isChecked2 = value;
                                accountType = 'Current';
                                print('Account Type = $accountType');
                              });
                            },
                    ),
                    Flexible(
                        child: Text(
                      'Current',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF302F2E),
                        fontSize: 18,
                        fontFamily: 'Barlow',
                        fontWeight: FontWeight.w700,
                        height: 0,
                        letterSpacing: -0.18,
                      ),
                    )),
                    SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
            ),
            if (accountTypeError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please Select one of these Options',
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
            Divider(),
            SizedBox(
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
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                      "Bank Name",
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: 318,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: Color(0x00CCCDCD),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select Bank', style: TextStyle( fontFamily: 'Barlow'),),
                        value: _selectedBank,
                        onChanged: (String? newValue) {
                          // Accepts nullable String
                          setState(() {
                            _selectedBank = newValue!;
                            bank = newValue;
                            bankError =
                                false; // Reset bank error when user selects a bank
                            print('Selected Bank: $bank');
                          });
                        },
                        items: indianBanks
                            .map<DropdownMenuItem<String>>((String bank) {
                          return DropdownMenuItem<String>(
                            value: bank,
                            child: Text(bank, style: TextStyle( fontFamily: 'Barlow'),),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (bankError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Select Bank  Name',
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
            // SizedBox(
            //   height: 8,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     child: Container(
            //       width: 318,
            //       height: 45,
            //       decoration: ShapeDecoration(
            //         color: Color(0x00CCCDCD),
            //         shape: RoundedRectangleBorder(
            //           side: BorderSide(width: 1, color: Color(0xFFCCCDCD)),
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 10),
            //         child: DropdownButtonHideUnderline(
            //           child: DropdownButton<String>(
            //             hint: Text('Select Bank'),
            //             value: _selectedBank,
            //             onChanged: (String? newValue) {
            //               // Accepts nullable String
            //               setState(() {
            //                 _selectedBank = newValue!;
            //                 bank = newValue;
            //                 print('Selected Bank: $bank');
            //               });
            //             },
            //             items: indianBanks
            //                 .map<DropdownMenuItem<String>>((String bank) {
            //               return DropdownMenuItem<String>(
            //                 value: bank,
            //                 child: Text(bank),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
                    Container(
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                      " Account Holder's Name*",
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                       inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    ],
                      onTap: () {
                        setState(() {
                          accountHolderNameError = false;
                        });
                      },
                      controller: accountHolderName,
                      decoration: InputDecoration(
                          isDense: true, border: InputBorder.none),
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
            if (accountHolderNameError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Account Name',
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
                    Container(
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                      'Account Number*',
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onTap: () {
                        setState(() {
                          accountNumberError = false;
                        });
                      },
                      controller: accountNumber,
                      decoration: InputDecoration(
                          isDense: true, border: InputBorder.none),
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
            if (accountNumberError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter Account Number',
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
                    Container(
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                      'IFSC Code*',
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          IFSCcodeError = false;
                        });
                      },
                      controller: IFSCcode,
                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
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
            ),
            if (IFSCcodeError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Please Enter IFSC Code',
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
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await submitForm();
                // widget.onNext();
              },
              child: Container(
                child: Center(
                  child: Text(
                    'Submit',
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


//  @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: DropdownButton<String>(
//         hint: Text('Select Bank'),
//         value: _selectedBank,
//         onChanged: (String? newValue) { // Accepts nullable String
//           setState(() {
//             _selectedBank = newValue;
//           });
//         },
//         items: indianBanks.map<DropdownMenuItem<String>>((String bank) {
//           return DropdownMenuItem<String>(
//             value: bank,
//             child: Text(bank),
//           );
//         }).toList(),
//       ),
//     );
//   }