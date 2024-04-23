// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:micro_mitti/Other_Screens/contact_us.dart';
import 'package:micro_mitti/Payment/payment.dart';
import 'package:micro_mitti/databaseservices.dart';
import 'package:micro_mitti/notification.dart';
import 'package:micro_mitti/viewDetailScreen2.dart';
import 'package:micro_mitti/widget/myWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';

GetStorage box = GetStorage();

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  bool isRefreshed = false;

  Future<void> handleRefersh() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isRefreshed = true;
    });

    await fetchDataFromBackend();
    await fetchDataFromBackend2();

    setState(() {
      isRefreshed = false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  // DataController controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    setState(() {
      fetching = true;
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        fetching = false;
      });
    });
    fetchDataFromBackend();
    fetchDataFromBackend2();
  }

  String userId = box.read('userId') ?? "";

  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      QuerySnapshot stream =
          await FirebaseFirestore.instance.collection('Allproperties').get();
      print('Fetched data: ${stream.docs}');
      return stream;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  String? ttInvestment;
  String? ROI;
  String? portfolio;

  Future<String> fetchDataFromBackend2() async {
    final userId = box.read('userId');
    print('User Id:- $userId');

    List<int> projectValues = [];

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('Allproperties').get();

      querySnapshot.docs.forEach((doc) {
        dynamic projectValue = doc['project_value'];

        if (projectValue is int) {
          projectValues.add(projectValue);
        } else if (projectValue is String) {
          // Remove commas and extra spaces
          projectValue = projectValue.replaceAll(',', '').trim();

          // Split the string by space to separate number and suffix
          List<String> parts = projectValue.split(' ');

          if (parts.length == 2) {
            // Extract the numeric part and remove any non-numeric characters
            String numericPart = parts[0].replaceAll(RegExp(r'[^0-9.]'), '');
            double numericValue = double.tryParse(numericPart) ?? 0.0;

            // Convert to integer based on suffix
            if (parts[1].toUpperCase() == 'CR') {
              projectValues
                  .add((numericValue * 10000000).toInt()); // 1 crore = 10^7
            } else if (parts[1].toUpperCase() == 'LAKHS') {
              projectValues
                  .add((numericValue * 100000).toInt()); // 1 lakh = 10^5
            }
          } else {
            // If no space or incorrect format, handle as before
            if (projectValue.toUpperCase().contains('CR')) {
              projectValue = projectValue.replaceAll('CR', '');
              double valueInCrores = double.tryParse(projectValue) ?? 0.0;
              projectValues
                  .add((valueInCrores * 10000000).toInt()); // 1 crore = 10^7
            } else if (projectValue.toUpperCase().contains('LAKHS')) {
              projectValue = projectValue.replaceAll('Lakhs', '');
              double valueInLakhs = double.tryParse(projectValue) ?? 0.0;
              projectValues
                  .add((valueInLakhs * 100000).toInt()); // 1 lakh = 10^5
            } else {
              projectValues.add(int.tryParse(projectValue) ?? 0);
            }
          }
        }
      });

      int totalProjectValue =
          projectValues.fold(0, (prev, current) => prev + current);
      print('List of Project Values: $projectValues');
      print('Total Project Value: $totalProjectValue');

      String totalProjectValueString;
      if (totalProjectValue >= 10000000) {
        totalProjectValueString =
            '${(totalProjectValue / 10000000).toStringAsFixed(2)} CR';
      } else if (totalProjectValue >= 100000) {
        totalProjectValueString =
            '${(totalProjectValue / 100000).toStringAsFixed(2)} Lakhs';
      } else {
        totalProjectValueString = totalProjectValue.toString();
      }

      setState(() {
        portfolio = totalProjectValueString;
      });

      return totalProjectValueString;
    } catch (error) {
      throw error;
    }
  }

  bool fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: FittedBox(
          child: FloatingActionButton.small(
            backgroundColor: Color(0xFFFECC00),
            onPressed: () {
              Get.to(() => ContactUs());
            },
            child: Center(
              child: Image.asset(
                'assets/images/contactUs.png',
                scale: 2,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      drawer: drawer(),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/bottom_layout.png',
        ),
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            appbar(
              header: 'HOME',
              onPressed2: () {
                Get.to(() => NotificationScreen());
              },
              iconData1: Icons.menu,
              onPressed1: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              fontSize: 18,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Color(0xFFFECC00),
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width,
                  // height: 145,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        AutoSizeText(
                          'Total Portfolio',
                          textAlign: TextAlign.center,
                          // minFontSize: 18,
                          // maxFontSize: 40,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        (portfolio == "null")
                            ? Text(
                                '\₹0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              )
                            : Text(
                                '\₹${portfolio.toString()}/-',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Barlow',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LiquidPullToRefresh(
                backgroundColor: Colors.black,
                height: 80,
                animSpeedFactor: 2,
                showChildOpacityTransition: false,
                color: Color(0xFFFECC00),
                onRefresh: handleRefersh,
                child: isRefreshed
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Color(0xFFFECC00),
                      ))
                    : StreamBuilder(
                        stream: Stream.fromFuture(fetchDataFromBackend()),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Color(0xFFFECC00),
                            ));
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return ListView(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.asset(
                                            'assets/images/noProp.png'),
                                      ),
                                      Center(
                                        child: Text(
                                          "No Investments Available\nPlease Invest In Property",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final item = snapshot.data!.docs[index];

                                  String docId = item.id;

                                  print('Document Id: $docId');

                                  List<dynamic> image = item['property_image'];
                                  print('Image url: $image');

                                  double roi = item['projected_ROI'] / 100;
                                  String project_value = item['project_value'];
                                  String land_area = item['land_area'];
                                  String land_market_value =
                                      item['land_market_value'];
                                  String sale_value = item['sale_value'];
                                  // String investor1 =
                                  //     item['investors']['investor_1'];
                                  // String investor2 =
                                  //     item['investors']['investor_2'];
                                  String invested = item['invested'];
                                  String current_value = item['current_value'];
                                  String property_name = item['property_name'];
                                  // String property_image = item['property_image'];
                                  // String share_holder_name1 =
                                  //     item['shares'][0]['name'];
                                  // int share_holder1 = item['shares'][0]['share'];
                                  // String share_holder_name2 =
                                  //     item['shares'][1]['name'];
                                  // int share_holder2 = item['shares'][1]['share'];

                                  List<dynamic> users = item['users'];
                                  bool ListUser = users.contains(userId);

                                  List<dynamic> investors = item['investors'];
                                  List<dynamic> shares = item['shares'];

                                  List<dynamic> pdf = item['documents'];
                                  String location = item['location'];
                                  int booking = item['bookingAmount'];
                                  String type = item['type'];
                                  int tenure = item['tenure'];

                                  // String booking = item['bookingAmount'];

                                  String homepage = 'home';

                                  print(
                                      'Projected ROI: $roi, $project_value, $land_area, $land_market_value, $sale_value, $invested, $current_value.,$image');

                                  final List<String> imageUrls = [
                                    "assets/images/logo.png",
                                    "assets/images/google.png",
                                    "assets/images/facebook.png",
                                  ];

                                  int _currentIndex = 0;

                                  Widget buildDot(int index) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentIndex == index
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Card(
                                          elevation: 5,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Container(
                                                      // height: 170,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: (image.isNotEmpty)
                                                          ? ImageCarousel(
                                                              imageUrls: image)
                                                          : Text(
                                                              "No Image Available",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                              ),
                                                            )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${item["property_name"]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Return on investment',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF302F2E),
                                                      fontSize: 14,
                                                      fontFamily: 'Barlow',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                      letterSpacing: -0.14,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor:
                                                        Color(0xFFD9D9D9),
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Color(0xFFFECC00)),
                                                    value: roi,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  // padding:
                                                  //     const EdgeInsets.symmetric(
                                                  //         horizontal: 5),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              Get.to(
                                                                  () =>
                                                                      ViewDetailScreen2(),
                                                                  arguments: [
                                                                    roi,
                                                                    project_value,
                                                                    land_area,
                                                                    land_market_value,
                                                                    sale_value,
                                                                    invested,
                                                                    current_value,
                                                                    property_name,
                                                                    image,
                                                                    docId,
                                                                    users,
                                                                    // ListUs```````````````er,
                                                                    pdf,
                                                                    homepage,
                                                                    location,
                                                                    investors,
                                                                    shares,
                                                                    booking,
                                                                    type,
                                                                    tenure
                                                                  ]);
                                                            },
                                                            child: Container(
                                                              height: 42,
                                                              width: 107.5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        5,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                  )
                                                                ],
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'View Details',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF302F2E),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Barlow',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        -0.24,
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (users
                                                                .contains(
                                                                    userId)) {
                                                              Get.snackbar(
                                                                  animationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              500),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          246,
                                                                          235,
                                                                          69,
                                                                          69),
                                                                  "You can't Invest in same Property twice",
                                                                  '');
                                                            } else {
                                                              Get.to(
                                                                  () =>
                                                                      Payment(),
                                                                  arguments: [
                                                                    roi,
                                                                    project_value,
                                                                    land_area,
                                                                    land_market_value,
                                                                    sale_value,
                                                                    invested,
                                                                    current_value,
                                                                    property_name,
                                                                    image,
                                                                    docId,
                                                                    pdf,
                                                                    homepage,
                                                                    booking,
                                                                    investors,
                                                                    shares,
                                                                    type,
                                                                    location,
                                                                    tenure
                                                                  ]);
                                                            }
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        5,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                  )
                                                                ],
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              width: 107.5,
                                                              height: 42,
                                                              child: Center(
                                                                child: Text(
                                                                  'Invest Now',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF302F2E),
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Barlow',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 0,
                                                                    letterSpacing:
                                                                        -0.24,
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.symmetric(
                                                //           horizontal: 5),
                                                //   child: Divider(
                                                //     color: Colors.grey[400],
                                                //     thickness: 3,
                                                //   ),
                                                // ),
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
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<dynamic> imageUrls;

  ImageCarousel({required this.imageUrls});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.imageUrls.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                url,
                fit: BoxFit.contain,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageUrls.length,
            (index) => buildDot(index),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? Color(0xFFFECC00) : Colors.grey,
      ),
    );
  }
}
