import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sharek_app_new/UI/settings.dart';
import 'package:sharek_app_new/classes/driverPost.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';

import '../db/app_database_new.dart';
import 'posts/customerPosts_page.dart';
import 'posts/driverPosts_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Widget> _pages = [
    CustomerPosts(),
    const DriverPosts(),
    const Settings(),
  ];

  final AppController _appController = Get.find();
  //controllers for creating new post
  final TextEditingController _tripDate = TextEditingController();
  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _numberOfCustomers = TextEditingController();
  final TextEditingController _price = TextEditingController();

  final dateRegExp =
      RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          actions: [
            createCustomerPostButton(context),
          ],
        ),
        drawer: Drawer(
          shadowColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Visibility(
                  visible: _appController.isCurrentUserDriver.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "chnage role",
                          style: TextStyle(
                            fontSize: _appController.drawerTextSize,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Row createCustomerPostButton(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Create customer post",
        ),
        IconButton(
          onPressed: () async {
            //Get post info from the user
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(child: Text('Enter Post Info below')),

                  //Text fileds
                  content: SingleChildScrollView(
                    child: Obx(
                      () => Column(children: [
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "trip Date {yyyy-mm-dd}"),
                          controller: _tripDate,
                          keyboardType: TextInputType.datetime,
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "from"),
                          controller: _from,
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "to"),
                          controller: _to,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: "number of Customers"),
                          controller: _numberOfCustomers,
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "price"),
                          controller: _price,
                        ),
                        TextField(
                          decoration: const InputDecoration(hintText: "Notes"),
                          controller: _notes,
                        ),
                        CheckboxListTile(
                          title: const Text('Shared'),
                          value: _appController.isShared.value,
                          onChanged: (value) {
                            _appController.isShared.value = value!;
                          },
                        ),
                      ]),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Perform action when the "Cancel" button is pressed
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        //check the filds
                        if (_tripDate.text.isEmpty ||
                            _from.text.isEmpty ||
                            _to.text.isEmpty ||
                            _notes.text.isEmpty ||
                            _numberOfCustomers.text.isEmpty ||
                            _price.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Fill all the fields",
                            textColor: Colors.red,
                            fontSize: 20,
                            gravity: ToastGravity.CENTER,
                          );
                          return;
                        }
                        //check the fomrat of date
                        if (_tripDate.text.length == 10 &&
                            dateRegExp.hasMatch(_tripDate.text)) {
                          //date is ok now

                          print(
                              "${DateFormat('yyyy-MM-dd').format(DateTime.now())}");

                          //insert To dB
                          try {
                            AppDatabase().createNewCustomerPost(
                                DateTime.parse(_tripDate.text),
                                _notes.text,
                                DateTime.parse(DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())),
                                _to.text,
                                _from.text,
                                int.parse(_numberOfCustomers.text),
                                int.parse(_price.text),
                                _appController.isShared.value,
                                _appController.currentCustomerId);
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: e.toString(),
                              textColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }

                          //clearing the fieds
                          _price.clear();
                          _numberOfCustomers.clear();
                          _notes.clear();
                          _to.clear();
                          _from.clear();
                          _tripDate.clear();
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(
                            msg: "incorrect date format!",
                            textColor: Colors.red,
                            fontSize: 20,
                            gravity: ToastGravity.CENTER,
                          );
                          return;
                        }
                      },
                      child: const Text(
                        'create',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                );
              },
            );

            //create post

            //add to DB
          },
          icon: const Icon(
            Icons.create,
            semanticLabel: "Create Post",
          ),
        ),
      ],
    );
  }
}
