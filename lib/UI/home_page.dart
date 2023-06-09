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

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  //adding new Vehicle
  final TextEditingController _plateNumber = TextEditingController();
  final TextEditingController _capacity = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final TextEditingController _registrationNumber = TextEditingController();

  //add new Bus company
  final TextEditingController _busCompanyName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          actions: [
            Obx(
              () => Visibility(
                  visible: _appController.pageindex.value == 0 ? true : false,
                  child: createCustomerPostButton(context)),
            ),
          ],
        ),
        drawer: Drawer(
          shadowColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              children: [
                //chnage role
                chnageRoleButton(),
                //add car
                addNewVehicleButton(context),

                //add bus company
                addNewBusCompanyButton(context),
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

  Visibility chnageRoleButton() {
    return Visibility(
      visible: _appController.isCurrentUserDriver.value,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: TextButton(
            onPressed: () async {},
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
    );
  }

  Visibility addNewVehicleButton(BuildContext context) {
    return Visibility(
      visible: _appController.isCurrentUserDriver.value,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: TextButton(
            onPressed: () {
              //add new car here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(child: Text('Add new Vehicle ')),
                    content: ListView(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "plateNumber",
                          ),
                          controller: _plateNumber,
                        ),
                        TextField(
                          controller: _capacity,
                          decoration: const InputDecoration(
                            hintText: "capacity",
                          ),
                        ),
                        TextField(
                          controller: _model,
                          decoration: const InputDecoration(
                            hintText: "model",
                          ),
                        ),
                        TextField(
                          controller: _color,
                          decoration: const InputDecoration(
                            hintText: "color",
                          ),
                        ),
                        TextField(
                          controller: _registrationNumber,
                          decoration: const InputDecoration(
                            hintText: "registrationNumber",
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Perform action when the "Cancel" button is pressed
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_plateNumber.text.isEmpty ||
                              _capacity.text.isEmpty ||
                              _model.text.isEmpty ||
                              _color.text.isEmpty ||
                              _registrationNumber.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "fill all the fileds",
                              textColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                            );
                            return;
                          }
                          //insert to DB
                          try {
                            await AppDatabase().createNewVehicle(
                                _plateNumber.text,
                                int.parse(_capacity.text),
                                _model.text,
                                _color.text,
                                _registrationNumber.text);

                            _plateNumber.clear();
                            _capacity.clear();
                            _model.clear();
                            _color.clear();
                            _registrationNumber.clear();

                            Navigator.of(context).pop();
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: e.toString(), textColor: Colors.red);
                          }
                        },
                        child: const Text('add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "add Vehicle",
              style: TextStyle(
                fontSize: _appController.drawerTextSize,
                color: Colors.amber,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility addNewBusCompanyButton(BuildContext context) {
    return Visibility(
      visible: _appController.isCurrentUserDriver.value,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: TextButton(
            onPressed: () {
              //add new car here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text(
                        'Add new Bus Company ',
                      ),
                    ),
                    content: ListView(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: "company name",
                          ),
                          controller: _busCompanyName,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Perform action when the "Cancel" button is pressed
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_busCompanyName.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "fill all the fields",
                              textColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                            );
                            return;
                          }

                          //insert in DB
                          try {} catch (e) {}
                        },
                        child: const Text('add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Add new Bus Company",
              style: TextStyle(
                fontSize: _appController.drawerTextSize,
                color: Colors.amber,
              ),
            ),
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
