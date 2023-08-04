import 'package:device_activity_web/responsive/responsive_layout.dart';
import 'package:device_activity_web/responsive/web_layout.dart';
import 'package:device_activity_web/screens/auth/signin_screen.dart';
import 'package:device_activity_web/screens/auth/signup_screen.dart';
import 'package:device_activity_web/screens/details_screen.dart';
import 'package:device_activity_web/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'responsive/app_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Settings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),
      home: const ResponsiveLayout(
          appLayout: AppLayout(), webLayout: WebLayout()),
      initialRoute: "/signup",
      routes: {
        "/home": (context) => const HomeScreen(),
        "/signup": (context) => const SignUpScreen(),
        "/signin": (context) => const SignInScreen(),
        "/details": (context) => const DetailsScreen(),
      },
    );
  }
}
