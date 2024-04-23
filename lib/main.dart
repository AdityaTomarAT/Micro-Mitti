// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micro_mitti/Auth/splashscreen.dart';
import 'package:micro_mitti/dashboard.dart';
import 'package:micro_mitti/firebase_options.dart';
import 'package:micro_mitti/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:micro_mitti/upcoming_properties.dart';
import 'package:micro_mitti/usercontroller.dart';
import "package:responsive_builder/responsive_builder.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(UserController());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) {
        return GetMaterialApp(
          // Change GetMaterialApp to GetMaterialApp
          title: 'Flutter Demo',
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
        );
      },
    );
  }
}
