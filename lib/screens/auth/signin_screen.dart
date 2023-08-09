// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:device_activity_web/screens/auth/signup_screen.dart';
import 'package:device_activity_web/screens/home_screen.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:device_activity_web/widgets/custom_button.dart';
import 'package:device_activity_web/widgets/text_widget.dart';
import 'package:device_activity_web/widgets/wsized.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/cutom_image.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  signInFunction(
    BuildContext context,
    String email,
    String password,
  ) async {
    UserModel usr = UserModel();

    usr.email = email;
    usr.password = password;

    var res = await Provider.of<RootProvider>(
      context,
      listen: false,
    ).signInWithEmailAndPassword(
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
                            text: 'Login Account',
                            textcolor: Colors.black,
                            textsize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                          WSizedBox(wval: 0, hval: 0.03),
                          Row(
                            children: [
                              TextWidget(
                                text: 'Not A member?',
                                textcolor: Colors.grey,
                                textsize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              TextButton(
                                // onPressed: () => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => SignUpScreen(),
                                //   ),
                                // ),
                                onPressed: () =>
                                    Navigator.pushNamed(context, "/signup"),
                                child: Text(
                                  ' Sign up',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          WSizedBox(wval: 0, hval: 0.03),
                          CustomTextField(
                              controller: _emailController,
                              borderradius: 20,
                              bordercolor: Colors.grey.shade200,
                              widh: 0.32,
                              height: 0.05,
                              icon: Icons.mail,
                              textcolor: Colors.black,
                              iconColor: Colors.grey,
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
                              textcolor: Colors.black,
                              iconColor: Colors.grey,
                              hinttext: 'Password',
                              hintColor: Colors.grey,
                              fontsize: 15,
                              obscureText: true),
                          WSizedBox(wval: 0, hval: 0.04),
                          CustomButton(
                            buttontext: 'Login Account',
                            width: 0.32,
                            height: 0.05,
                            bordercolor: Colors.deepPurpleAccent.shade700,
                            borderradius: 25,
                            fontsize: 16,
                            fontweight: FontWeight.bold,
                            fontcolor: Colors.white,
                            onPressed: () {
                              signInFunction(
                                context,
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
