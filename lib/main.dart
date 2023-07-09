import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UI/login_page.dart';
import 'controllers/app_controller.dart';
import 'controllers/signUpController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AppController());
    Get.put(SignUpController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
