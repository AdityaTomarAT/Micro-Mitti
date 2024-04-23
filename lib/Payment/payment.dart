// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_child_properties_last

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:micro_mitti/Payment/paymentconfirmation.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final roi = Get.arguments[0];
  String project_value = Get.arguments[1];
  String land_area = Get.arguments[2];
  String land_market_value = Get.arguments[3];
  String sale_value = Get.arguments[4];
  String invested = Get.arguments[5];
  String current_value = Get.arguments[6];
  String property_name = Get.arguments[7];
  List<dynamic> image = Get.arguments[8];
  String docId = Get.arguments[9];
  List<dynamic> pdf = Get.arguments[10];
  String screen = Get.arguments[11];
  int booking = Get.arguments[12] ?? 0;
  List<dynamic> investors = Get.arguments[13];
  List<dynamic> shares = Get.arguments[14];
  String type = Get.arguments[15];
  String location = Get.arguments[16];
  int tenureBackend = Get.arguments[17] ?? 0;

  @override
  void initState() {
    super.initState();
    print('Property Details: $screen, $image, $property_name');
    tenure.text = selectedTenure.toString(); // Set initial value
    tenure2.text = selectedTenure2.toString();
    setState(() {
      amountValue = booking;
    });
  }

  int numberOfUnits = 1;
  int numberOfUnits2 = 1;
  int selectedTenure = 2;
  int selectedTenure2 = 2;

  void _incrementCounter() {
    setState(() {
      numberOfUnits++;
      numberOfUnits2++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (numberOfUnits > 1) {
        numberOfUnits--;
        numberOfUnits2--;
      }
    });
  }

  int calculatePercentAmount() {
    // 2.5% of 10,00,000 is 25,000
    return 2500 * numberOfUnits;
  }

  int calcualateTotalAmount() {
    return numberOfUnits * 100000;
  }

  final String fullamounttext = "Pay the full amount";
  final String percentamounttext = "Pay 2.5% booking amount ₹25,000";

  TextEditingController tenure = TextEditingController();
  TextEditingController tenure2 = TextEditingController();

  int amountValue = 0;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    int totalPercentAmount = calculatePercentAmount();
    int calcualateTotalAmountValue = calcualateTotalAmount();
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                    "PAYMENT",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 150,
                                width: 110.5,
                                padding: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    image[0],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            property_name,
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
                                                    project_value,
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
                                                    (sale_value.isEmpty)
                                                        ? "No Data\nAvailable"
                                                        : sale_value,
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
                                                    land_area,
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
                                                    'Land Market value',
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
                                                    (land_market_value.isEmpty)
                                                        ? "No Data\nAvailable"
                                                        : land_market_value,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pre-Booking Amount',
                            style: TextStyle(
                              color: Color(0xFF302F2E),
                              fontSize: 14,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '₹${amountValue.toString()}/-',
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => PaymentConfirmation(
                              tenure: tenureBackend,
                              location: location,
                              shares: shares,
                              investors: investors,
                              pdfUrl: pdf,
                              name: property_name,
                              image: image,
                              // numberOfUnits: numberOfUnits,
                              amountvalue: amountValue,
                              textofpayment: 'Pay the BooKing amount',
                              year: selectedTenure.toString(),
                              projectValue: project_value,
                              landArea: land_area,
                              saleValue: sale_value,
                              landMarketValue: land_market_value,
                              // share_holder_name1: share_holder_name1,
                              // share_holder_name2: share_holder_name2,
                              returns: '15.67',
                              invested: invested,
                              // share_holder1: share_holder1,
                              // share_holder2: share_holder2,
                              current_value: current_value,
                              value_asset: "17:50 CR",
                              docId: docId,
                              ROI: roi,
                              comingScreen: screen,
                              type: type,
                            ));
                      },
                      child: Container(
                        // color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Tenure Available: $tenureBackend',
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 16,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                            letterSpacing: -0.12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: SizedBox(
                                  // width: 283,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Pay ',
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 15,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                            letterSpacing: -0.19,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              'Booking amount \n& Unlock full details of property.',
                                          style: TextStyle(
                                            color: Color(0xFF302F2E),
                                            fontSize: 15,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                            letterSpacing: -0.19,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Center(
                                  child: GestureDetector(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Book now :',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 12,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '₹${amountValue.toString()}/-',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 32.80,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFFECC00),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFFFECC00)),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DISCLAIMER :',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 354,
                            child: Text(
                              'For the Booking Amount, you can complete the payment via any mode of your choice.\n\nFor Full Payment, You can pay offline (via Cheque or DD) or Online (via NEFT/RTGS/IMPS)',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 14,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.14,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioButtons(int numberOfButtons) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: numberOfButtons,
      itemBuilder: (BuildContext context, int index) {
        int value = index + 1;
        return buildRadio(value);
      },
    );
  }

  Widget buildRadio(int value) {
    return Row(
      children: [
        Column(
          children: [
            Radio(
              activeColor: Color(0xFFFECC00),
              value: value,
              groupValue: selectedTenure,
              onChanged: (int? val) {
                setState(() {
                  selectedTenure = val!;
                });
              },
            ),
            Text(
              '$value Year',
              style: TextStyle(
                color: Color(0xFF302F2E),
                fontSize: 12,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildRadio2(int value) {
    return Row(
      children: [
        Column(
          children: [
            Radio(
              activeColor: Color(0xFFFECC00),
              value: value,
              groupValue: selectedTenure2,
              onChanged: (int? val) {
                setState(() {
                  selectedTenure2 = val!;
                });
              },
            ),
            Text(
              '$value Year',
              style: TextStyle(
                color: Color(0xFF302F2E),
                fontSize: 12,
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
          ],
        )
      ],
    );
  }
}
