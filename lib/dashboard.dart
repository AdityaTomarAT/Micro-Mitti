// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:micro_mitti/viewDetailScreen2.dart';
import 'package:micro_mitti/widget/myWidget.dart';

GetStorage box = GetStorage();

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
    fetchSubCollection();
  }

  List dashboardData = [];

  String ttInvestment = "";
  String ROI = "";

  final userId = box.read('userId');
  Future<void> fetchDataFromBackend() async {
    try {
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

      firestoreInstance
          .collection('dashboard')
          .doc(userId)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          setState(() {
            ttInvestment = data['total_investment'].toString();
            ROI = data['ROI'].toString();
          });

          print('Total Investment: $ttInvestment');
          print('ROI: $ROI');
        } else {
          print('Document does not exist');
        }
      });
    } catch (error) {
      throw error;
    }
  }

  // final userId = box.read('UserId');
  Future<QuerySnapshot<Object?>> fetchSubCollection() async {
    try {
      QuerySnapshot stream = await FirebaseFirestore.instance
          .collection('dashboard')
          .doc(userId)
          .collection(userId)
          .get();
      print('Fetched data: ${stream.docs}');
      return stream;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  bool isRefreshed = false;

  Future<void> handleRefersh() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isRefreshed = true;
    });

    await fetchDataFromBackend();

    setState(() {
      isRefreshed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
      key: _scaffoldKey,
      drawer: drawer(),
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
                    "DASHBOARD",
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total Investment\n',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 14,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.14,
                              ),
                            ),
                            TextSpan(
                              text: '₹',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 14,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.14,
                              ),
                            ),
                            (ttInvestment == "null" || ttInvestment == "")
                                ? TextSpan(
                                    text: '0/-',
                                    style: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 15,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.15,
                                    ),
                                  )
                                : TextSpan(
                                    text: '$ttInvestment/-',
                                    style: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 15,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.15,
                                    ),
                                  ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2, 2), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        top: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        right: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        bottom: BorderSide(width: 4, color: Color(0xFFFECC00)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Container(
                    // width: 150,
                    height: 120,
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Return On\nInvestment\n',
                              style: TextStyle(
                                color: Color(0xFF302F2E),
                                fontSize: 14,
                                fontFamily: 'Barlow',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.14,
                              ),
                            ),
                            // SizedBox(),
                            (ROI == "null" || ROI == "")
                                ? TextSpan(
                                    text: '₹0/-',
                                    style: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 15,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.14,
                                    ),
                                  )
                                : TextSpan(
                                    text: '₹$ROI',
                                    style: TextStyle(
                                      color: Color(0xFF302F2E),
                                      fontSize: 15,
                                      fontFamily: 'Barlow',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.14,
                                    ),
                                  ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(2, 2), // changes position of shadow
                        ),
                      ],
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        top: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        right: BorderSide(width: 1, color: Color(0xFFFECC00)),
                        bottom: BorderSide(width: 4, color: Color(0xFFFECC00)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                      ),
                    )
                  : StreamBuilder(
                      stream: Stream.fromFuture(fetchSubCollection()),
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
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  child:
                                      Image.asset('assets/images/noProp.png'),
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
                            );
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final item = snapshot.data!.docs[index];

                                  print('Doc Id: ${item.id}');

                                  double roi = item['projected_ROI'] / 100;
                                  String project_value = item['project_value'];
                                  String land_area = item['land_area'];
                                  String land_market_value =
                                      item['land_market_value'];
                                  String sale_value = item['sale_value'];
                                  // String investor1 =

                                  List<dynamic> investors = item['investors'];
                                  List<dynamic> shares = item['shares'];
                                  String invested = item['invested'];
                                  String current_value = item['current_value'];
                                  String property_name = item['property_name'];
                                  List<dynamic> property_image =
                                      item['property_image'];

                                  List<dynamic> users = item['users'];
                                  bool ListUser = users.contains(userId);

                                  List<dynamic> pdf = item['documents'];
                                  String location = item['location'];

                                  String dashboard = 'dashboard';

                                  String type = item['type'];
                                  int booking = item['bookingAmount'];
                                  int tenure = item['tenure'];

                                  var docId = item.id;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => ViewDetailScreen2(),
                                                arguments: [
                                                  roi,
                                                  project_value,
                                                  land_area,
                                                  land_market_value,
                                                  sale_value,
                                                  invested,
                                                  current_value,
                                                  property_name,
                                                  property_image,
                                                  docId,
                                                  users,
                                                  // ListUs```````````````er,
                                                  pdf,
                                                  dashboard,
                                                  location,
                                                  investors,
                                                  shares,
                                                  booking,
                                                  type,
                                                  tenure
                                                ]);
                                          },
                                          child: Container(
                                            width: 375,
                                            // height: 170,
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: (item['type'] ==
                                                          '2.5%')
                                                      ? Colors.amber[100]
                                                      : (item['type'] == 'Full')
                                                          ? Colors.green[100]
                                                          : null,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        height: 100,
                                                        width: 120,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  25.0), // Adjust the radius here
                                                          child: Image.network(
                                                            property_image[
                                                                0], // Replace with your local asset path
                                                            // fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Land Area - ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.14,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${item["land_area"]}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      letterSpacing:
                                                                          -0.15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Returns - ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.14,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${item["returns"].toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      letterSpacing:
                                                                          -0.15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text.rich(
                                                              TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Value Asset - ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      letterSpacing:
                                                                          -0.14,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '${item["value_asset"]}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF302F2E),
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'Barlow',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      letterSpacing:
                                                                          -0.15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  color: (item['type'] ==
                                                          '2.5%')
                                                      ? Colors.amber[100]
                                                      : (item['type'] == 'Full')
                                                          ? Colors.green[100]
                                                          : null,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          '${item["property_name"]}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF474645),
                                                            fontSize: 16.5,
                                                            fontFamily:
                                                                'Barlow',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  color: (item['type'] ==
                                                          '2.5%')
                                                      ? Colors.amber[100]
                                                      : (item['type'] == 'Full')
                                                          ? Colors.green[100]
                                                          : null,
                                                )
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(2,
                                                        2), // changes position of shadow
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 3,
                                                    color: Color(0xFFFECC00)),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                        }
                        return Container();
                      },
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
