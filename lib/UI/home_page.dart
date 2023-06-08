import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/UI/settings.dart';
import 'package:sharek_app_new/classes/driverPost.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';

import 'posts/customerPosts_page.dart';
import 'posts/driverPosts_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Widget> _pages = [
    CustomerPosts(),
    DriverPosts(),
    Settings(),
  ];

  final AppController _appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Customers Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Driver Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Settings',
              ),
            ],
            currentIndex: _appController.pageindex.value,
            selectedItemColor: Colors.orange,
            onTap: (int index) {
              _appController.pageindex.value = index;
              if (_appController.pageindex.value == 0) {
                _appController.getAllCustomersPosts();
              }
            },
          ),
        ),
        body: Obx(
          () => IndexedStack(
            index: _appController.pageindex.value,
            children: _pages,
          ),
        ),
      ),
    );
  }
}
