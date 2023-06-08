import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';
import 'package:flutter/services.dart';
import 'package:sharek_app_new/db/app_database_new.dart';
import 'package:intl/intl.dart';

class CustomerPosts extends StatefulWidget {
  CustomerPosts({super.key});

  @override
  State<CustomerPosts> createState() => _CustomerPostsState();
}

class _CustomerPostsState extends State<CustomerPosts> {
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
                  //Get post info from the user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            const Center(child: Text('Enter Post Info below')),

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
                                decoration:
                                    const InputDecoration(hintText: "from"),
                                controller: _from,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: "to"),
                                controller: _to,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "number of Customers"),
                                controller: _numberOfCustomers,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: "price"),
                                controller: _price,
                              ),
                              TextField(
                                decoration:
                                    const InputDecoration(hintText: "Notes"),
                                controller: _notes,
                              ),
                              CheckboxListTile(
                                title: const Text('Shared'),
                                value: _appController.isShared.value,
                                onChanged: (value) {
                                  setState(() {
                                    _appController.isShared.value = value!;
                                  });
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
