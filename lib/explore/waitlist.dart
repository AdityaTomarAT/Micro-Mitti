// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_function_literals_in_foreach_calls, use_rethrow_when_possible, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Auth/loginscreen.dart';
import 'package:micro_mitti/documents/webview.dart';
import 'package:micro_mitti/explore/youtubeView.dart';
import 'package:micro_mitti/widget/myWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

GetStorage box = GetStorage();

class WaitlistScreen extends StatefulWidget {
  const WaitlistScreen({super.key});

  @override
  State<WaitlistScreen> createState() => _WaitlistScreenState();
}

class _WaitlistScreenState extends State<WaitlistScreen> {
  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
    fetchDataFromBackend2();
  }

  // final userId = box.read('userId');
  Future<QuerySnapshot<Object?>> fetchDataFromBackend() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('explore')
          .doc('youtube')
          .collection('youtube')
          .get();

      querySnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      });
      print('Serives');
      return querySnapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<QuerySnapshot<Object?>> fetchDataFromBackend2() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('explore')
          .doc('instagram')
          .collection('instagram')
          .get();

      querySnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      });
      print('Events');
      return querySnapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  Future<QuerySnapshot<Object?>> fetchDataFromBackend3() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('explore')
          .doc('news')
          .collection('news')
          .get();

      querySnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      });
      print('Events');
      return querySnapshot;
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  late YoutubePlayerController controller;

  String? extractId(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    return videoId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Image.asset('assets/images/bottom_layout.png'),
      body: Column(children: [
        appbar(
          header: 'EXPLORE',
          iconData2: null,
          onPressed2: () {},
          iconData1: Icons.arrow_back_ios_sharp,
          onPressed1: () {
            Navigator.of(context).pop();
          },
          fontSize: 18,
        ),
        SizedBox(
          height: 20,
        ),

        // Horizontal ListView.builder
        Expanded(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/images/youtube.png')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'YOUTUBE',
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              child: StreamBuilder(
                  stream: Stream.fromFuture(fetchDataFromBackend()),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color(0xFFFECC00),
                      ));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child:
                                  Text('No Youtube Videos here currently..!!'),
                            )
                          ],
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.red, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey.shade400,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  print('ontap');
                                  Get.to(
                                    () => WebViewScreen(
                                      initialUrl: item['url'],
                                      title: item['title'],
                                    ),
                                    arguments: [item['url']],
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    YoutubePlayer.getThumbnail(
                                      webp: true,
                                      quality: ThumbnailQuality.max,
                                      videoId: extractId(item['url'])!,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Container(
                        child: Text('No Youtube Videos here currently..!!'),
                      ));
                    }
                    return Container();
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/images/instagram.png')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'INSTAGRAM',
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              child: StreamBuilder(
                  stream: Stream.fromFuture(fetchDataFromBackend2()),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color(0xFFFECC00),
                      ));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child:
                                  Text('No Instagram Reels here currently..!!'),
                            )
                          ],
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                // Get.to(() => LoginScreen());
                                Get.to(
                                    () => WebViewScreen(
                                        title: item['title'],
                                        initialUrl: item['url']),
                                    arguments: [item['url']]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 218, 62, 103),
                                        width: 2.5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.grey.shade400,
                                          offset: Offset(2, 2))
                                    ]),
                                width: 315,
                                // height: 174, // Adjust the width as needed
                                margin: EdgeInsets.all(8),

                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              height: 60,
                                              width: 60,
                                              child: Image.asset(
                                                'assets/images/instagram.png',
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              item['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item['description'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Container(
                        child: Text('No Properties here currently..!!'),
                      ));
                    }
                    return Container();
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/images/news.png')),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'NEWS / ARTICLES',
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
              ),
            ),
            Container(
              height: 250,
              child: StreamBuilder(
                  stream: Stream.fromFuture(fetchDataFromBackend3()),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Color(0xFFFECC00),
                      ));
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child:
                                  Text('No News/Articles here currently..!!'),
                            )
                          ],
                        );
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                // Get.to(() => LoginScreen());
                                Get.to(
                                    () => WebViewScreen(
                                        title: item['title'],
                                        initialUrl: item['url']),
                                    arguments: [item['url']]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2.5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.grey.shade400,
                                          offset: Offset(2, 2))
                                    ]),
                                width: 315,
                                // height: 174, // Adjust the width as needed
                                margin: EdgeInsets.all(8),

                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: ClipRRect(
                                                child: Image.network(
                                                  item['image'],
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ),
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              item['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item['description'],
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Container(
                        child: Text('No Properties here currently..!!'),
                      ));
                    }
                    return Container();
                  }),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )))
      ]),
    );
  }
}

Widget buildCustomCard1(int index) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.amber[50],
        boxShadow: [
          BoxShadow(
              blurRadius: 5, color: Colors.grey.shade400, offset: Offset(1, 2))
        ]),
    width: 315,
    height: 174, // Adjust the width as needed
    margin: EdgeInsets.all(8),

    child: Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 93,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7.5),
                    bottomLeft: Radius.circular(7.5),
                  ),
                  color: Color(0xFFFECC00)),
              child: Center(
                child: Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                    height: 100,
                    width: 90,
                    child: Image.asset('assets/images/services.png')),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Micro Mitti ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF302F2E),
                            fontSize: 16,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gross Entry Yield',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF302F2E),
                              fontSize: 13,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: -0.22,
                            ),
                          ),
                          Text(
                            'Asset Value',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF302F2E),
                              fontSize: 13,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w700,
                              height: 0,
                              letterSpacing: -0.22,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.5,
                    ),
                    Container(
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '8-9%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF302F2E),
                              fontSize: 11,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.22,
                            ),
                          ),
                          Text(
                            'Coming Soon',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF302F2E),
                              fontSize: 11,
                              fontFamily: 'Barlow',
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.22,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Target IRR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF302F2E),
                            fontSize: 11,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: -0.22,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '10-12%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF302F2E),
                            fontSize: 11,
                            fontFamily: 'Barlow',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.22,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 7.5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 165,
                    height: 37,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFECC00),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFFFECC00)),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Express Interest',
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
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
