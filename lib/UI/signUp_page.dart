import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sharek_app_new/classes/user.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';
import 'package:sharek_app_new/controllers/signUpController.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  final SignUpController _signUpController = Get.find();
  final AppController _appController = Get.find();
  List<TextEditingController> fields = [];

  bool isDriver = false;
  bool isCustomer = false;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.orange,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     image: AssetImage(
          //       "assets/images/Login_backgrounnd_image.jpg",
          //     ),
          //   ),
          // ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.white),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Sign Up here",
                    ),
                  ),
                ),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                    ),
                    TextButton(onPressed: () {}, child: Text("Upload image"))
                  ],
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: "name"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "email"),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(hintText: "phone number"),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "password"),
                ),
                TextField(
                  controller: _rePasswordController,
                  decoration: const InputDecoration(hintText: "re password"),
                ),
                Obx(
                  () => AnimatedOpacity(
                    opacity: _signUpController.isLicenseVisible.value ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: TextField(
                      controller: _licenseController,
                      decoration:
                          const InputDecoration(hintText: "License number"),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Driver'),
                  value: isDriver,
                  onChanged: (value) {
                    setState(() {
                      isDriver = value!;
                      if (isDriver) {
                        _signUpController.isLicenseVisible.value = true;
                      } else {
                        _signUpController.isLicenseVisible.value = false;
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Customer'),
                  value: isCustomer,
                  onChanged: (value) {
                    setState(() {
                      isCustomer = value!;
                    });
                  },
                ),
                TextButton(
                  onPressed: () async {
                    //clear the fileds
                    fields.clear();
                    //add the fileds
                    fields.add(_nameController);
                    fields.add(_emailController);
                    fields.add(_phoneNumberController);
                    fields.add(_passwordController);
                    fields.add(_rePasswordController);
                    if (isDriver) {
                      fields.add(_licenseController);
                    }
                    //chekc the fileds
                    if (!_appController.checkFields(fields)) {
                      Fluttertoast.showToast(
                        msg: "Please fill all the fileds!",
                        textColor: Colors.red,
                      );
                      return;
                    }
                    //chekc if the password fileds are similar
                    if (_passwordController.text !=
                        _rePasswordController.text) {
                      Fluttertoast.showToast(
                        msg: "Please enter similar passwords!",
                        textColor: Colors.red,
                      );
                      return;
                    }

                    //create new user
                    await AppDatabase().registerUser(
                      User(
                        email: _emailController.text.trim(),
                        name: _nameController.text.trim(),
                        password: _passwordController.text.trim(),
                        phoneNumber: _rePasswordController.text.trim(),
                        profilePicture: "",
                        available: true,
                        licence: _licenseController.text.trim(),
                        lastApperance: "",
                        driverFlag: isDriver,
                        customerFlag: isCustomer,
                      ),
                    );

                    _appController.currentUserEmail.value =
                        _emailController.text;

                    _appController.currentCustomerId = await AppDatabase()
                        .getUserId(_appController.currentUserEmail.value);

                    Get.to(
                      () => HomePage(),
                    );

                    //here update the DB
                  },
                  child: const Text(
                    "Sign up",
                  ),
                ),
              ])),
    );
  }
}
