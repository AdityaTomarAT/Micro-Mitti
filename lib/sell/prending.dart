// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:micro_mitti/Payment/payment.dart';
import 'package:micro_mitti/viewDetailScreen2.dart';

GetStorage box = GetStorage();

class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      QuerySnapshot stream =
          await FirebaseFirestore.instance.collection('sell').get();
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
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                        Text(
                          'No Properties Available..!!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          textAlign: TextAlign.justify,
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
                        String land_market_value = item['land_market_value'];
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

                        // List<dynamic> users = item['users'];
                        // bool ListUser = users.contains(userId);

                        List<dynamic> investors = item['investors'];
                        List<dynamic> shares = item['shares'];

                        String pdf = item['documents'];
                        String location = item['location'];
                        int booking = item['bookingAmount'];
                        String Status = item['status'];

                        String AllProperties = 'allprop';

                        List<dynamic> users = item['users'];
                        bool ListUser = users.contains(userId);

                        // print(
                        //     'Projected ROI: $roi, $project_value, $land_area, $land_market_value, $sale_value, $investor1, $investor2, $invested, $current_value. $share_holder_name1, $share_holder1, $share_holder_name2, $share_holder2,$property_image');

                        return (Status == "")
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            blurRadius: 4,
                                            offset: Offset(2, 2)
                                          )
                                        ]
                                      ),
                                      child: Column(
                                        children: [
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
                                               Container(
                                                      // width: 45,
                                                      height: 21,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: Colors.grey[400],
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Text(
                                                            'PENDING',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF0C0D6F),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Barlow',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          
                                          
                                          SizedBox(
                                            height: 15,
                                          ),
                                         
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    );
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
