// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/screens/auth/signin_screen.dart';
import 'package:device_activity_web/screens/home_screen.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:flutter/material.dart';

import 'package:device_activity_web/widgets/custom_button.dart';
import 'package:device_activity_web/widgets/text_widget.dart';
import 'package:device_activity_web/widgets/wsized.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/cutom_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  signUpFunction(context, name, email, password) async {
    Provider.of<RootProvider>(context, listen: false).showLicenceCode = true;

    UserModel usr = UserModel();

    usr.name = name;
    usr.email = email;
    usr.password = password;

    var res = await Provider.of<RootProvider>(
      context,
      listen: false,
    ).signUpWithEmailAndPassword(
      context,
      usr,
    );
    if (res) {
      Navigator.pushReplacementNamed(
        context,
        "/home",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              // color: const Color.fromARGB(255, 40, 42, 57),
              // color: const Color.fromARGB(255, 40, 42, 57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WSizedBox(wval: 0, hval: 0.2),
                  Row(
                    children: [
                      WSizedBox(wval: 0.05, hval: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WSizedBox(wval: 0, hval: 0.02),
                          TextWidget(
                            text: 'Create Account',
                            textcolor: Colors.black,
                            textsize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                          WSizedBox(wval: 0, hval: 0.03),
                          Row(
                            children: [
                              TextWidget(
                                text: 'Already A member?',
                                textcolor: Colors.grey,
                                textsize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    //  Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => SignInScreen(),
                                    //   ),
                                    // ),
                                    Navigator.pushNamed(context, "/signin"),
                                child: TextWidget(
                                  text: 'Login',
                                  textcolor: Colors.deepPurpleAccent,
                                  textsize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          WSizedBox(wval: 0, hval: 0.03),
                          Row(
                            children: [
                              CustomTextField(
                                  controller: _firstNameController,
                                  borderradius: 20,
                                  widh: 0.15,
                                  bordercolor: Colors.grey.shade200,
                                  height: 0.05,
                                  icon: Icons.credit_card,
                                  textcolor: Colors.black,
                                  iconColor: Colors.grey,
                                  hinttext: 'First Name',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false),
                              WSizedBox(wval: 0.02, hval: 0),
                              CustomTextField(
                                  controller: _lastNameController,
                                  borderradius: 20,
                                  widh: 0.15,
                                  bordercolor: Colors.grey.shade200,
                                  height: 0.05,
                                  icon: Icons.credit_card,
                                  textcolor: Colors.black,
                                  iconColor: Colors.grey,
                                  hinttext: 'Last Name',
                                  hintColor: Colors.grey,
                                  fontsize: 15,
                                  obscureText: false),
                            ],
                          ),
                          WSizedBox(wval: 0, hval: 0.02),
                          CustomTextField(
                              controller: _emailController,
                              borderradius: 20,
                              bordercolor: Colors.grey.shade200,
                              widh: 0.32,
                              height: 0.05,
                              icon: Icons.mail,
                              iconColor: Colors.grey,
                              textcolor: Colors.black,
                              hinttext: 'Email',
                              hintColor: Colors.grey,
                              fontsize: 15,
                              obscureText: false),
                          WSizedBox(wval: 0, hval: 0.02),
                          CustomTextField(
                              controller: _passwordController,
                              borderradius: 20,
                              bordercolor: Colors.grey.shade200,
                              widh: 0.32,
                              height: 0.05,
                              icon: Icons.lock,
                              iconColor: Colors.grey,
                              textcolor: Colors.black,
                              hinttext: 'Password',
                              hintColor: Colors.grey,
                              fontsize: 15,
                              obscureText: true),
                          WSizedBox(wval: 0, hval: 0.04),
                          CustomButton(
                            buttontext: 'Create Account',
                            width: 0.32,
                            height: 0.05,
                            bordercolor: Colors.deepPurpleAccent.shade700,
                            borderradius: 25,
                            fontsize: 16,
                            fontweight: FontWeight.bold,
                            fontcolor: Colors.white,
                            onPressed: () {
                              signUpFunction(
                                context,
                                _firstNameController.text +
                                    _lastNameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const CustomImageWidget(
            height: 1,
            width: 0.57,
            // imgpath: 'assets/images/bg.png',
            imgpathNet:
                "https://images.unsplash.com/photo-1483354483454-4cd359948304?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
          ),
        ],
      ),
    );
  }
}
