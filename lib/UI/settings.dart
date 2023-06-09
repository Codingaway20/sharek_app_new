import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/UI/login_page.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

final TextEditingController _newUsername = TextEditingController();
final TextEditingController _newPhoneNumber = TextEditingController();

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          //chnage phone number
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text('newPhoneNumber')),
                          content: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: "new phone number...",
                                ),
                                controller: _newPhoneNumber,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                if (_newPhoneNumber.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "fill all the fields!",
                                    textColor: Colors.red,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  return;
                                }
                                try {
                                  await AppDatabase()
                                      .updatePhoneNumber(_newPhoneNumber.text);
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    textColor: Colors.red,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Change Phone number"))
            ],
          ),
          //chnage name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.change_circle),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text('Chnage username')),
                          content: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: "new username...",
                                ),
                                controller: _newUsername,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_newUsername.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "fill all the fields",
                                    textColor: Colors.red,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  return;
                                }

                                //update DB
                                try {
                                  await AppDatabase()
                                      .updateUsername(_newUsername.text);
                                  _newUsername.clear();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    textColor: Colors.red,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }

                                // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Change name"))
            ],
          ),

          Spacer(),
          GestureDetector(
            onTap: () {
              Get.offAll(
                () => LoginPage(),
                transition: Transition.circularReveal,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Sign out",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
