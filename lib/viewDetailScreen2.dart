// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, unnecessary_string_interpolations

import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Payment/payment.dart';
import 'package:micro_mitti/documents/documents.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:micro_mitti/pdfView.dart';
import 'package:micro_mitti/widget/myWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

GetStorage box = GetStorage();

class ViewDetailScreen2 extends StatefulWidget {
  ViewDetailScreen2({super.key});

  @override
  State<ViewDetailScreen2> createState() => _ViewDetailScreenState();
}

class _ViewDetailScreenState extends State<ViewDetailScreen2> {
  double roi = Get.arguments[0];
  String project_value = Get.arguments[1];
  String land_area = Get.arguments[2];
  String land_market_value = Get.arguments[3];
  String sale_value = Get.arguments[4];
  String invested = Get.arguments[5];
  String current_value = Get.arguments[6];
  String property_name = Get.arguments[7];
  List<dynamic> image = Get.arguments[8];
  String docID = Get.arguments[9];
  List<dynamic> listUsers = Get.arguments[10];
  List<dynamic> pdf = Get.arguments[11];
  String screen = Get.arguments[12];
  String location = Get.arguments[13];
  List<dynamic> investors = Get.arguments[14];
  List<dynamic> shares = Get.arguments[15];
  int booking = Get.arguments[16] ?? 0;
  String type = Get.arguments[17];
  int tenure = Get.arguments[18] ?? 0;

  final userId = box.read('userId');

  List<double> finalShares = [];

  List<double> convertToDoubleIntegers(List<dynamic> inputList) {
    List<double> result = [];

    for (dynamic element in inputList) {
      // Convert element to double and then to integer
      double intValue;
      try {
        double doubleValue = double.parse(element.toString());
        intValue = doubleValue.toDouble();
      } catch (e) {
        // Handle cases where conversion is not possible
        // You may choose to skip or handle such cases differently
        print("Could not convert $element to double integer: $e");
        continue;
      }
      result.add(intValue);
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    List<double> convertedList = convertToDoubleIntegers(shares);
    print(convertedList);
    print('Investors lemgth: ${investors.length}');
    print('Shares lemgth: ${shares.length}');
    setState(() {
      pieList = convertedList;
    });
  }

  List<double> pieList = [];

  var _openResult = 'Unknown';

  Future<void> openFileAndWrite(List<int> bytes, String filePath) async {
    await File(filePath).writeAsBytes(bytes);
  }

  Future<String> getTemporaryFilePath() async {
    return (await getTemporaryDirectory()).path + "/temp.pdf";
  }

  // bool isSecondContainerVisible = false;
  bool isFirstDropdownOpened = false;
  bool isSecondDropdownOpened = false;
  IconData dropdown1Icon = Icons.arrow_drop_down;
  IconData dropdown2Icon = Icons.arrow_drop_down;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleFirstDropdown() {
    setState(() {
      isFirstDropdownOpened = !isFirstDropdownOpened;
      dropdown1Icon =
          isFirstDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    });
  }

  // Toggle function for the second dropdown
  void toggleSecondDropdown() {
    setState(() {
      isSecondDropdownOpened = !isSecondDropdownOpened;
      dropdown2Icon =
          isSecondDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down;
    });
  }

  Future<void> addIntoSell() async {
    try {
      CollectionReference dashboard =
          FirebaseFirestore.instance.collection('sell');

      await dashboard.doc(docID).set({
        // 'ROI': widget.amountvalue,
        // 'portfolio': investment,
        'user': userId,
        'docId': docID,
        'type': screen
      }, SetOptions(merge: true));

      print('investment ho gyi');
      print('value added in all properties');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  Future<void> _downloadZipFile(String url) async {
    // setState(() {
    //   _downloading = true;
    // });

    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/pdf.zip');
    await file.writeAsBytes(response.bodyBytes);

    // setState(() {
    //   _downloading = false;
    // });

    // Perform actions after download if needed
  }

  Color getRandomColor() {
  Random random = Random();
  int red = random.nextInt(256);
  int green = random.nextInt(256);
  int blue = random.nextInt(256);

  double luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
  // Check if luminance is less than the threshold for light colors
  if (luminance < 0.7) {
    // Lighten the color by adding to RGB values
    return Color.fromARGB(255, red + 100, green + 100, blue + 100);
  } else {
    // Return the color as is
    return Color.fromARGB(255, red, green, blue);
  }
}

  Future<void> addIntoDashBoardProperty() async {
    try {
      CollectionReference kycDetails =
          FirebaseFirestore.instance.collection('sell');

      await kycDetails.doc().set({
        'documents': pdf,
        'projected_ROI': roi,
        'property_image': image,
        'property_name': property_name,
        'land_area': land_area,
        'land_market_value': land_market_value,
        'sale_value': sale_value,
        'project_value': project_value,
        'current_value': current_value,
        'invested': invested,
        'investors': investors,
        // 'returns': returns,
        'shares': shares,
        // 'value_asset': value_asset,
        'users': [userId],
        'type': type,
        "location": location ?? "",
        "bookingAmount": booking,
        "status": ""
      });

      print('property add ho gyi');
    } catch (e) {
      // Handle the exception
      print('Error adding user: ${e.toString()}');
    }
  }

  List<PieChartSectionData> _generatePieChartSections(
      List<double> pieList, List<dynamic> investors) {
    List<PieChartSectionData> sections = [];

    double totalPercentage =
        pieList.reduce((value, element) => value + element);

    for (int i = 0; i < pieList.length; i++) {
      String investorName = investors[i]['name'];
      double currentPercentage = pieList[i];
      if (i == pieList.length - 1 && totalPercentage != 100.0) {
        double remainingPercentage = 100.0 - totalPercentage;
        sections.add(
          PieChartSectionData(
            titleStyle: TextStyle(color: Colors.black),
            value: currentPercentage,
            title: '${currentPercentage}%',
            color: getRandomColor(),
            radius: 80,
          ),
        );
        sections.add(
          PieChartSectionData(
            titleStyle: TextStyle(color: Colors.black),
            value: remainingPercentage,
            title: '${remainingPercentage}%',
            color: getRandomColor(),
            radius: 80,
          ),
        );
        break; // Break the loop after adding the "Others" section
      } else {
        sections.add(
          PieChartSectionData(
            titleStyle: TextStyle(color: Colors.black),
            value: currentPercentage,
            title: '${currentPercentage}%',
            color: getRandomColor(),
            radius: 80,
          ),
        );
      }
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: Image.asset("assets/images/bottom_layout.png"),
      backgroundColor: Colors.white,
      drawer: Drawer(),
      key: _scaffoldKey,
      body: Column(
        children: [
          appbar(
            header: '$property_name',
            iconData2: null,
            onPressed1: () {
              Navigator.of(context).pop();
            },
            onPressed2: () {},
            iconData1: Icons.arrow_back_ios_new,
            fontSize: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          // shape: BoxDecoration(shape: BorderSide()),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Container(
                                    // height: 170,
                                    width: MediaQuery.of(context).size.width,
                                    child: (image.isNotEmpty)
                                        ? ImageCarousel(imageUrls: image)
                                        : Text(
                                            "No Image Available",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Barlow',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: currentWidth < 370
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$property_name',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: 'Barlow',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$property_name',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.5,
                                              fontFamily: 'Barlow',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Project Value\n',
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 14,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (project_value.isEmpty)
                                            ? "No Project Value \nAvailable"
                                            : project_value,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 12,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                VerticalDivider(),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Land Area\n',
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 14,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (land_area.isEmpty)
                                            ? "No Land Area \nAvailable"
                                            : land_area,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 12,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Divider(
                            height: 10,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Land Market Value\n',
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 14,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (land_market_value.isEmpty)
                                            ? "No Land Market Value\nAvailable"
                                            : land_market_value,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 12,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                currentWidth < 370
                                    ? SizedBox(
                                        width: 0.5,
                                      )
                                    : SizedBox(
                                        width: 0.25,
                                      ),
                                VerticalDivider(),
                                SizedBox(
                                  width: 10.75,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Sale Value\n',
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 14,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: (sale_value.isEmpty)
                                            ? "No Sale Value\nAvailable"
                                            : sale_value,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 12,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                currentWidth < 370
                                    ? SizedBox(
                                        width: 12,
                                      )
                                    : SizedBox(
                                        width: 2,
                                      )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
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
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: LinearProgressIndicator(
                            backgroundColor: Color(0xFFD9D9D9),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFECC00)),
                            value: roi,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: GestureDetector(
                            onTap: () {
                              if (listUsers.contains(userId)) {
                                Get.snackbar(
                                    animationDuration:
                                        Duration(milliseconds: 500),
                                    backgroundColor:
                                        Color.fromARGB(246, 235, 69, 69),
                                    "You can't Invest in same Property twice",
                                    '');
                              } else {
                                Get.to(() => Payment(), arguments: [
                                  roi,
                                  project_value,
                                  land_area,
                                  land_market_value,
                                  sale_value,
                                  invested,
                                  current_value,
                                  property_name,
                                  image,
                                  docID,
                                  pdf,
                                  screen,
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
                                  color: Color(0xFFFECC00),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        offset: Offset(2, 2))
                                  ]),
                              // width: 315,
                              height: 42,
                              child: Center(
                                child: Text(
                                  'INVEST NOW',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF302F2E),
                                    fontSize: 13,
                                    fontFamily: 'Barlow',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Text("TYPE:-    "),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: (type == "closed")
                                            ? Colors.grey.shade300
                                            : (type == "open")
                                                ? Colors.lightGreen.shade100
                                                : (type == "fully funded")
                                                    ? Colors.yellow.shade100
                                                    : type.isEmpty
                                                        ? Colors.white
                                                        : Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        ),
                                    // width: 315,
                                    height: 42,
                                    child: Center(
                                      child: Text(
                                        // type,
                                        (type == "closed")
                                            ? "CLOSED"
                                            : (type == "open")
                                                ? "OPEN"
                                                : (type == "fully funded")
                                                    ? "FULLY FUNDED"
                                                    : type.isEmpty
                                                        ? "Not Status Available"
                                                        : "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF302F2E),
                                          fontSize: 13,
                                          fontFamily: 'Barlow',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: GestureDetector(
                            onTap: toggleFirstDropdown,
                            child: Container(
                              // width: 314,
                              // height: isFirstDropdownOpened
                              //     ? 280
                              //     : 38, // Height changes based on dropdown state
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFD2D2D2)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 5, bottom: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Property Details',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF7C7C7C),
                                            fontSize: 14,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                            letterSpacing: -0.14,
                                          ),
                                        ),
                                        Icon(dropdown1Icon),
                                      ],
                                    ),
                                  ),
                                  if (isFirstDropdownOpened) ...[
                                    // Divider(color: Color(0xFFD2D2D2)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 40),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Project Value:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                              Text(
                                                (project_value.isEmpty)
                                                    ? "No Project Value Available"
                                                    : project_value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Land Area:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                              Text(
                                                (land_area.isEmpty)
                                                    ? "No Land Area Data Available"
                                                    : land_area,
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
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Sale Value:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                              Text(
                                                (sale_value.isEmpty)
                                                    ? "No Sale Value Available"
                                                    : sale_value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Current Value:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                              Text(
                                                (current_value.isEmpty)
                                                    ? "No Current Value Available"
                                                    : current_value,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Projected ROI:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                              Text(
                                                (roi == 0)
                                                    ? "No ROI Available "
                                                    : '${roi * 100 % 1 == 0 ? (roi * 100).toInt() : (roi * 100).toStringAsFixed(2)}%',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Project Proposed:-',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF302F2E),
                                                  fontSize: 12,
                                                  fontFamily: 'Barlow',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  maxLines: 5,
                                                  (location.isEmpty)
                                                      ? "No Proposed Data Available"
                                                      : location,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Color(0xFF302F2E),
                                                    fontSize: 12,
                                                    fontFamily: 'Barlow',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                    letterSpacing: -0.24,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: Color(0xFFE2E2E2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )

                                    // Add more options here
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: GestureDetector(
                            onTap: toggleSecondDropdown,
                            child: Container(
                              // width: 314,
                              // Height changes based on dropdown state
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFD2D2D2)),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Property Investors',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF7C7C7C),
                                            fontSize: 14,
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                            letterSpacing: -0.14,
                                          ),
                                        ),
                                        Icon(dropdown2Icon),
                                      ],
                                    ),
                                  ),
                                  if (isSecondDropdownOpened) ...[
                                    Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 25),
                                      // padding:
                                      //     EdgeInsets.only(left: 20, right: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          (investors.isEmpty)
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Icon(
                                                      Icons.group_off_outlined,
                                                      size: 30,
                                                      color: Color(0xFFFECC00),
                                                    ),
                                                    Text(
                                                      'No Data Available',
                                                      style: TextStyle(
                                                          fontFamily: 'Bardow',
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: investors.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final item =
                                                        investors[index];
                                                    return Column(
                                                      children: [
                                                        Container(
                                                            decoration:
                                                                ShapeDecoration(
                                                              color:
                                                                  Colors.white,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xFFDEDEDE)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 45,
                                                                  width: 45,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(6),
                                                                    child: Image
                                                                        .network(
                                                                      item[
                                                                          'imageURL'],
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      item[
                                                                          'name'],
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
                                                                            FontWeight.w500,
                                                                        height:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),

                                    // Add more options here
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            // padding: EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: (shares.isEmpty)
                                          ? Column(
                                              children: [
                                                Icon(
                                                  Icons.web_asset_off_rounded,
                                                  size: 30,
                                                  color: Color(0xFFFECC00),
                                                ),
                                                Text(
                                                  'No Data Available',
                                                  style: TextStyle(
                                                      fontFamily: 'Bardow',
                                                      fontSize: 12),
                                                )
                                              ],
                                            ) 
                                          : Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 150,
                                                  width: 150,
                                                  child: PieChart(
                                                    PieChartData(
                                                      sectionsSpace: 0.5,
                                                      centerSpaceRadius: 15,
                                                      sections:
                                                          _generatePieChartSections(
                                                              pieList,
                                                              investors),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 45),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Invested: ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 13,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                            (invested.isNotEmpty)
                                                ? Text(
                                                    invested,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFECC00),
                                                      fontSize: 14,
                                                      fontFamily: 'Barlow',
                                                      fontWeight: FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  )
                                                : Text(
                                                    "No Amount Invested",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFECC00),
                                                      fontSize: 14,
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
                                        child: Row(
                                          children: [
                                            Text(
                                              'Current Value: ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF302F2E),
                                                fontSize: 13,
                                                fontFamily: 'Barlow',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                            // Divider(
                                            //   color: Colors.black,
                                            // ),
                                            (current_value.isNotEmpty)
                                                ? Text(
                                                    current_value,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFECC00),
                                                      fontSize: 14,
                                                      fontFamily: 'Barlow',
                                                      fontWeight: FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  )
                                                : Text(
                                                    "No Current Value",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFECC00),
                                                      fontSize: 14,
                                                      fontFamily: 'Barlow',
                                                      fontWeight: FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 55,
                                ),
                                currentWidth < 370
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    () => Documents(docs: pdf));
                                              },
                                              child: Container(
                                                height: 33,
                                                // width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 2))
                                                    ]),
                                                // padding: EdgeInsets.only(left: 20),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 13),
                                                    child: Text(
                                                      'All Documents',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF302F2E),
                                                        fontSize: 14,
                                                        fontFamily: 'Barlow',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                        letterSpacing: 0.24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            listUsers.contains(userId)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      print('tapped');

                                                      await addIntoSell();
                                                      Get.snackbar(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          backgroundColor:
                                                              Colors.green,
                                                          'Alright..!!',
                                                          'Micro Mitti will reach you once have matched with the buyer..!!');
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  800), () {
                                                        Get.to(() =>
                                                            HomePageScreen());
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                    2, 2))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color(
                                                              0xFFFECC00)),
                                                      // width: 100,
                                                      height: 33,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      17),
                                                          child: Text(
                                                            'Sell Now',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF302F2E),
                                                              fontSize: 14,
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
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
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
                                                          "You can't sell the Property",
                                                          'To Sell the property you have to purchase it first');
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  blurRadius: 2,
                                                                  offset:
                                                                      Offset(
                                                                          2, 2))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Color(
                                                                0xFFFECC00)),
                                                        // width: 100,
                                                        height: 33,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        17),
                                                            child: Text(
                                                              'Sell Now',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 14,
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
                                                  ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(
                                                    'Document container tapped');
                                                // _launchURL();
                                                Get.to(
                                                    () => Documents(docs: pdf));
                                              },
                                              child: Container(
                                                height: 33,
                                                // width: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 2))
                                                    ]),
                                                // padding: EdgeInsets.only(left: 20),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 13),
                                                    child: Text(
                                                      'All Documents',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF302F2E),
                                                        fontSize: 14,
                                                        fontFamily: 'Barlow',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                        letterSpacing: 0.24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            listUsers.contains(userId)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      print('tapped');

                                                      await addIntoDashBoardProperty();
                                                      Get.snackbar(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          backgroundColor:
                                                              Colors.green,
                                                          'Alright..!!',
                                                          'Micro Mitti will reach you once have matched with the buyer..!!');
                                                      Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  800), () {
                                                        Get.to(() =>
                                                            HomePageScreen());
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                    2, 2))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Color(
                                                              0xFFFECC00)),
                                                      // width: 120,
                                                      height: 33,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      17),
                                                          child: Text(
                                                            'Sell Now',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF302F2E),
                                                              fontSize: 14,
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
                                                      ),
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
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
                                                          "You can't sell the Property",
                                                          'To Sell the property you have to purchase it first');
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  blurRadius: 2,
                                                                  offset:
                                                                      Offset(
                                                                          2, 2))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Color(
                                                                0xFFFECC00)),
                                                        // width: 120,
                                                        height: 33,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        13),
                                                            child: Text(
                                                              'Sell Now',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF302F2E),
                                                                fontSize: 14,
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
                                                  ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                            // width: 314,
                            // height: 313,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFD2D2D2)),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
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
