import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

class CustomerPosts extends StatelessWidget {
  CustomerPosts({super.key});

  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView(
            children: _appController.customersPosts.value,
          )),
    );
  }
}
