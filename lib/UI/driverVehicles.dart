import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';

class DriverVehicles extends StatelessWidget {
   DriverVehicles({super.key});

  final AppController _appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(10),
            children: _appController.driverVehicles,
          )),
    );
  }
}
