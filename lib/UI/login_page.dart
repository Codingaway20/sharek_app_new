import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharek_app_new/UI/signUp_page.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

import '../controllers/app_controller.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AppController _appController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/Login_backgrounnd_image.jpg",
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              "assets/images/taxi_flag-removebg-preview.png",
              width: 120,
              height: 150,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black38,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),

                    //Email text field
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            hintText: "email@example.com",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white30,
                            icon: Icon(
                              Icons.email,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //Password
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        child: TextField(
                          controller: _passwordController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white30,
                            hintText: "***********",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            icon: Icon(
                              Icons.password,
                              color: Colors.orange,
                            ),
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        bool loginStatus = await AppDatabase().userLogin(
                            _emailController.text.trim(),
                            _passwordController.text.trim());

                        if (loginStatus) {
                          _appController.currentUserEmail.value =
                              _emailController.text;
                          Get.to(
                            () => HomePage(),
                            transition: Transition.fade,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "forgot password ?",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "new here?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(
                                () => const SignUp(),
                                transition: Transition.fade,
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await AppDatabase().readAllUsersData();
                },
                icon: Icon(Icons.read_more)),
          ],
        ),
      ),
    );
  }
}
