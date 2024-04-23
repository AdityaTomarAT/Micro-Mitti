// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "dart:io";

import "package:flutter/material.dart";
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import "package:get/get.dart";
import 'package:micro_mitti/documents/pdfView.dart';
import "package:micro_mitti/documents/webview.dart";
import "package:micro_mitti/widget/myWidget.dart";
import 'package:open_filex/open_filex.dart';
import "package:path_provider/path_provider.dart";
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Documents extends StatefulWidget {
  final List<dynamic> docs;
  Documents({super.key, required this.docs});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  void initState() {
    super.initState();
    print('Documents List: ${widget.docs}');
  }

  Future<void> downloadFile(
      String url, String fileName, BuildContext context) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$fileName');
    await file.writeAsBytes(bytes);
    // Show a snackbar or toast to indicate download completion
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('File downloaded successfully'),
    ));
  }

  double? _progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(child: Image.asset('assets/images/bottom_layout.png'),),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/bottom_layout.png',
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          appbar(
            header: 'All DOCUMENTS',
            iconData1: Icons.arrow_back_ios_new,
            onPressed2: () {},
            onPressed1: () {
              Navigator.of(context).pop();
            },
            fontSize: 18,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: widget.docs.length,
                    itemBuilder: (context, index) {
                      final item = widget.docs[index];

                      Uri uri = Uri.parse(item['url']);
                      String path = uri.path;
                      List<String> pathSegments = path.split('/');

                      // Decode the last path segment (file name) as it may contain encoded characters
                      String fileName = Uri.decodeComponent(pathSegments.last);
                      if (fileName.startsWith("files/")) {
                        fileName = fileName.substring("files/".length);
                      }

                      if (widget.docs.isNotEmpty) {
                        return Column(
                          children: [
                            ListTile(
                                onTap: () {
                                  // Get.to(() => WebViewScreen(),
                                  //     arguments: [item['url']]);
                                  Get.to(() => PdfViewerPage(
                                        pdfUrl: item['url'],
                                        fileName: fileName,
                                      ));
                                },
                                leading: CircleAvatar(
                                    backgroundColor: Color(0xFFFECC00),
                                    child: Text('${index + 1}')),
                                title: Text(fileName),
                                trailing: (item['downloadable'] == true)
                                    ? IconButton(
                                        icon: Icon(Icons.download),
                                        onPressed: () async {
                                          FileDownloader.downloadFile(
                                              url: item['url'].trim(),
                                              onProgress: (name, progress) {
                                                setState(() {
                                                  _progress = progress;
                                                });
                                              },
                                              onDownloadCompleted: (value) {
                                                print('path  $value ');
                                                setState(() {
                                                  _progress = null;
                                                });
                                                // OpenFile.open(value);
                                                Get.snackbar(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 92, 206, 95),
                                                    'Download Complete',
                                                    'Go to downloads section of your device');
                                              });
                                          // OpenFilex.open(path);
                                        },
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Icon(Icons.file_download_off),
                                      )),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [Text('No Documents Availabe')],
                        );
                      }
                    })
              ],
            ),
          ))
        ],
      ),
    );
    ;
  }
}
