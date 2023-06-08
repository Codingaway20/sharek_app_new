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
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              const Text(
                "Create Post",
              ),
              IconButton(
                onPressed: () async {
                  //create post
                  

                  //add to DB
                },
                icon: const Icon(
                  Icons.create,
                  semanticLabel: "Create Post",
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() => ListView(
            padding: const EdgeInsets.all(10),
            reverse: true,
            children: _appController.customersPosts,
          )),
    );
  }
}
