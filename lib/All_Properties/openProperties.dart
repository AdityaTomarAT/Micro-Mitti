// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:micro_mitti/Payment/payment.dart';
import 'package:micro_mitti/viewDetailScreen2.dart';

GetStorage box = GetStorage();

class OpenProperties extends StatefulWidget {
  const OpenProperties({super.key});

  @override
  State<OpenProperties> createState() => _OpenPropertiesState();
}

class _OpenPropertiesState extends State<OpenProperties> {
  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

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

  bool isRefreshed = false;

  Future<void> handleRefersh() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isRefreshed = true;
    });

    await fetchDataFromBackend();
    // await fetchDataFromBackend2();

    setState(() {
      isRefreshed = false;
    });
  }

  final userId = box.read('userId');

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
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
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                var filteredList = snapshot.data?.docs
                    .where((item) => item['type'] == "open")
                    .toList();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFFECC00),
                  ));
                } else if (snapshot.hasData) {
                  if (filteredList!.isEmpty) {
                    return ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/images/noProp.png'),
                            ),
                            Center(
                              child: Text(
                                "No Property Available",
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
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          String docId = item.id;
                          print('Document Id: $docId');
                          List<dynamic> image = item['property_image'];
                          print('Image url: $image');
                          double roi = item['projected_ROI'] / 100;
                          String project_value = item['project_value'];
                          String land_area = item['land_area'];
                          String land_market_value = item['land_market_value'];
                          String sale_value = item['sale_value'];
                          String invested = item['invested'];
                          String current_value = item['current_value'];
                          String property_name = item['property_name'];
                          List<dynamic> investors = item['investors'];
                          List<dynamic> shares = item['shares'];
                          List<dynamic> pdf = item['documents'];
                          String location = item['location'];
                          int? booking = item['bookingAmount'];
                          String type = item['type'];
                          int tenure = item['tenure'];
                          String AllProperties = 'allprop';
                          List<dynamic> users = item['users'];
                          bool ListUser = users.contains(userId);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                            // height: 170,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: (image.isNotEmpty)
                                                ? ImageCarousel(
                                                    imageUrls: image)
                                                : Text(
                                                    "No Image Available",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Barlow',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${item["property_name"]}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Return on investment',
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
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: LinearProgressIndicator(
                                          backgroundColor: Color(0xFFD9D9D9),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                          pdf,
                                                          AllProperties,
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
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 5,
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset: Offset(1, 2),
                                                        )
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'View Details',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF302F2E),
                                                          fontSize: 12,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                          letterSpacing: -0.24,
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
                                                                    AllProperties,
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
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 5,
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset: Offset(1, 2),
                                                        )
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    width: 107.5,
                                                    height: 42,
                                                    child: Center(
                                                      child: Text(
                                                        'Invest Now',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF302F2E),
                                                          fontSize: 12,
                                                          fontFamily: 'Barlow',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                          letterSpacing: -0.24,
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
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: 3,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Container(
                    child: Text('No Properties here currently..!!'),
                  ));
                } else {
                  return Container();
                }
              },
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
