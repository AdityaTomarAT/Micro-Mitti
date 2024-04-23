// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:micro_mitti/Other_Screens/waitlistform.dart';
import 'package:micro_mitti/explore/waitlist.dart';
import 'package:micro_mitti/widget/myWidget.dart';

GetStorage box = GetStorage();

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
  static ValueNotifier<int> cardValue = new ValueNotifier(0);
}

class _UpcomingState extends State<Upcoming> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

  final userId = box.read('userId');
  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      QuerySnapshot stream =
          await FirebaseFirestore.instance.collection('waitinglist').get();
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

  String docId = "";

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
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black,
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Upcoming",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  // SizedBox(width: 50),
                ],
              ),
            ),
          ),
          // Expanded(
          //     child: LiquidPullToRefresh(
          //         child: ListView.builder(
          //             itemCount: 4,
          //             itemBuilder: (context, index) {
          // return
          //             }),
          //         onRefresh: handleRefersh))
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
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final item = snapshot.data!.docs[index];

                                final docId = item.id;

                                List<dynamic> users = item['users'];

                                bool ListUser = users.contains(userId);

                                print('users: $users');

                                print('Document Id: ${item.id}');

                                // final status = item['status'];

                                // print('Status $status');

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (ListUser) {
                                        null;
                                      } else {
                                        Upcoming.cardValue.value = index;
                                        print('Card Index: $index');
                                        Get.to(() => WaitlistForm(),
                                            arguments: [
                                              docId,
                                            ]);
                                      }
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Card(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10
                                                ),
                                                child: Container(
                                                    // height: 200,
                                                    // width: 200,
                                                    child: ImageCarousel(
                                                        imageUrls: item[
                                                            'property_image'])),
                                              ),
                                              // DividerWithText(
                                              //   dividerText:
                                              //       "Fractional Real Estate",

                                              // ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      item['property_name'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF474645),
                                                        fontSize: 18,
                                                        fontFamily: 'Barlow',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              DividerWithText(
                                                dividerText:
                                                    "Fractional Real Estate",
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Land Area\n',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // height: 0.09,
                                                                letterSpacing:
                                                                    -0.14,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: item[
                                                                  'land_area'],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // height: 0.08,
                                                                letterSpacing:
                                                                    -0.15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Returns\n',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // height: 0.09,
                                                                letterSpacing:
                                                                    -0.14,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: item[
                                                                  'returns'],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // height: 0.08,
                                                                letterSpacing:
                                                                    -0.15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Value Asset\n',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                // height: 0.09,
                                                                letterSpacing:
                                                                    -0.14,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: item[
                                                                  'value_asset'],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                // height: 0.08,
                                                                letterSpacing:
                                                                    -0.15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Center(
                                                    child: GestureDetector(
                                                  // onTap: () {
                                                  //   Get.to(() => WaitlistForm());
                                                  // },
                                                  child: ListUser
                                                      ? Text(
                                                          'Submitted',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF302F2E),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Barlow',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                            letterSpacing:
                                                                -0.24,
                                                          ),
                                                        )
                                                      : Text(
                                                          'Join the Wait List',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF302F2E),
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Barlow',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 0,
                                                            letterSpacing:
                                                                -0.24,
                                                          ),
                                                        ),
                                                )),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 32.80,
                                                decoration: ShapeDecoration(
                                                  color: ListUser
                                                      ? const Color.fromARGB(
                                                          255, 115, 221, 119)
                                                      : Color(0xFFFECC00),
                                                  shape: RoundedRectangleBorder(
                                                    // side: BorderSide(
                                                    //     width: 1,
                                                    //     color: Color(0xFFFECC00)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                      bottomRight:
                                                          Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Container(
                            child: Text('No Properties here currently..!!'),
                          ));
                        }
                        return Container();
                      }),
            ),
          ),
        ],
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;

  DividerWithText({required this.dividerText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: Colors.black,
              thickness: 1,
              endIndent: 10,
            ),
          ),
          Text(
            'Fractional Real Estate',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF302F2E),
              fontSize: 14,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
              height: 0.09,
              letterSpacing: -0.14,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,
              thickness: 1,
              indent: 10,
            ),
          ),
        ],
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
