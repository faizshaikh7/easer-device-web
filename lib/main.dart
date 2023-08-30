// ignore_for_file: unused_local_variable

import 'package:device_activity_web/screens/admin_create_account_screen.dart';
import 'package:device_activity_web/screens/admin_dashboard_screen.dart';
import 'package:device_activity_web/screens/auth/signin_screen.dart';
import 'package:device_activity_web/screens/auth/signup_screen.dart';
import 'package:device_activity_web/screens/details_screen.dart';
import 'package:device_activity_web/screens/home_screen.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAg8rIF_XYMGmiM2Xo9SY-RCUbGyaKkK0o",
      appId: "1:863661298593:web:50ea9817354c2ffddff1e0",
      messagingSenderId: "863661298593",
      projectId: "easer-device-521",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RootProvider(),
        )
      ],
      child: MaterialApp(
        title: 'System Settings',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,

        // home: const SignInScreen(),
        // home: const ResponsiveLayout(
        //     appLayout: AppLayout(), webLayout: WebLayout()),
        initialRoute: "/signin",
        routes: {
          // "/": (context) => const HomeScreen(),
          "/home": (context) => const HomeScreen(),
          "/signup": (context) => const SignUpScreen(),
          "/signin": (context) => const SignInScreen(),
          "/details": (context) => const DetailsScreen(),
          "/admin_screen": (context) => const AdminCreateAccountScreen(),
          "/admin_dashboard": (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
