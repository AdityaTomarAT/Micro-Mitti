// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String initialUrl;
  const WebViewScreen({
    super.key,
    required this.title,
    required this.initialUrl,
  });

  @override
  State<WebViewScreen> createState() => _WebViewState();
}

final String url = Get.arguments[0];

class _WebViewState extends State<WebViewScreen> {
  // WebViewController? controller;

  // String urlId = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;

      print('Final Base Url: $url');
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Color(0xFFFECC00),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFECC00),
              ),
            )
          : WebViewWidget(
              controller: controller!,
            ),
    );
  }
}
