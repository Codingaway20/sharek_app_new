import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                        child: const TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
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
                        child: const TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
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

                    Padding(
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
                            onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
