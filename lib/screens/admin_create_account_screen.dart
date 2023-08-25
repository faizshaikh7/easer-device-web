import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:device_activity_web/utils/dimensions.dart';
import 'package:device_activity_web/widgets/custom_button.dart';
import 'package:device_activity_web/widgets/custom_textfield.dart';
import 'package:device_activity_web/widgets/cutom_image.dart';
import 'package:device_activity_web/widgets/text_widget.dart';
import 'package:device_activity_web/widgets/wsized.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminCreateAccountScreen extends StatefulWidget {
  const AdminCreateAccountScreen({super.key});

  @override
  State<AdminCreateAccountScreen> createState() =>
      _AdminCreateAccountScreenState();
}

class _AdminCreateAccountScreenState extends State<AdminCreateAccountScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _deviceLimitController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  signUpFunction(context, name, email, password, deviceLimit) async {
    var prefs = await SharedPreferences.getInstance();
    Provider.of<RootProvider>(context, listen: false).showLicenceCode = true;
    // var prov = Provider.of<RootProvider>(context, listen: false);

    UserModel usr = UserModel();
    usr.name = name;
    usr.email = email;
    usr.password = password;
    usr.deviceLimit = deviceLimit;

    var res = await Provider.of<RootProvider>(
      context,
      listen: false,
    ).signUpWithEmailAndPassword(
      context,
      usr,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    bool isWebScreen = true;
    if (width <= webScreenSize) {
      setState(() {
        isWebScreen = false;
      });
    }
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
                            text: 'Create Admin Account',
                            textcolor: Colors.black,
                            textsize: (isWebScreen) ? 40 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                          // WSizedBox(wval: 0, hval: 0.03),

                          WSizedBox(wval: 0, hval: 0.03),
                          Row(
                            children: [
                              CustomTextField(
                                  controller: _firstNameController,
                                  borderradius: 20,
                                  widh: isWebScreen ? 0.15 : 0.440,
                                  height: isWebScreen ? 0.05 : 0.06,
                                  bordercolor: Colors.grey.shade200,
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
                                  widh: isWebScreen ? 0.15 : 0.440,
                                  height: isWebScreen ? 0.05 : 0.06,
                                  bordercolor: Colors.grey.shade200,
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
                              controller: _deviceLimitController,
                              borderradius: 20,
                              bordercolor: Colors.grey.shade200,
                              widh: isWebScreen ? 0.32 : 0.90,
                              height: isWebScreen ? 0.05 : 0.062,
                              icon: Icons.numbers_rounded,
                              iconColor: Colors.grey,
                              textcolor: Colors.black,
                              keyboardType: TextInputType.number,
                              hinttext: 'Device Limit',
                              hintColor: Colors.grey,
                              fontsize: 15,
                              obscureText: false),
                          WSizedBox(wval: 0, hval: 0.02),
                          CustomTextField(
                              controller: _emailController,
                              borderradius: 20,
                              bordercolor: Colors.grey.shade200,
                              widh: isWebScreen ? 0.32 : 0.90,
                              height: isWebScreen ? 0.05 : 0.062,
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
                              widh: isWebScreen ? 0.32 : 0.90,
                              height: isWebScreen ? 0.05 : 0.062,
                              icon: Icons.lock,
                              iconColor: Colors.grey,
                              textcolor: Colors.black,
                              hinttext: 'Password',
                              hintColor: Colors.grey,
                              fontsize: 15,
                              obscureText: true),
                          WSizedBox(wval: 0, hval: 0.04),
                          CustomButton(
                            buttontext: 'Create Admin Account',
                            width: isWebScreen ? 0.32 : 0.90,
                            height: isWebScreen ? 0.05 : 0.06,
                            bordercolor: Colors.green.shade900,
                            borderradius: 25,
                            fontsize: 16,
                            fontweight: FontWeight.bold,
                            fontcolor: Colors.white,
                            onPressed: () {
                              signUpFunction(
                                context,
                                "${_firstNameController.text} ${_lastNameController.text}",
                                _emailController.text,
                                _passwordController.text,
                                _deviceLimitController.text,
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
          (isWebScreen)
              ? const CustomImageWidget(
                  height: 1,
                  width: 0.57,
                  // imgpath: 'assets/images/bg.png',
                  imgpathNet:
                      "https://images.unsplash.com/photo-1525498128493-380d1990a112?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80",
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
