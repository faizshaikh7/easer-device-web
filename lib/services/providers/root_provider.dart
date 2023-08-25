// ignore_for_file: invalid_return_type_for_catch_error, body_might_complete_normally_catch_error

import 'dart:developer';
import 'dart:math' as mt;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_activity_web/models/device_info_model.dart';
import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/utils/database/database_method.dart';
import 'package:device_activity_web/widgets/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootProvider extends ChangeNotifier {
  bool showLicenceCode = false;
  String userLicenceCode = "";
  String userUID = "";
  SharedPreferences? prefs;
  List? deviceDataList;
  bool? isSuperAdmin = false;

  UserModel user = UserModel();
// TODO check below Code
  Future<void> getDeviceDetails(context) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("devices")
        .where("licenceCode", isEqualTo: userLicenceCode)
        .get();

    deviceDataList = querySnapshot.docs.map((doc) => doc.data()).toList();
    notifyListeners();
  }

  Future<bool> signUpWithEmailAndPassword(
    context,
    UserModel u,
  ) async {
    try {
      var auth = FirebaseAuth.instance;

      await auth.createUserWithEmailAndPassword(
        email: u.email!,
        password: u.password!,
      );

      userUID = auth.currentUser!.uid;
      u.uid = userUID;

      // Licence Gen
      var random = mt.Random();
      int randomNumber = random.nextInt(9000) + 1000;
      userLicenceCode = randomNumber.toString();
      u.licenceCode = userLicenceCode;

      // print(randomNumber);

      // Test
      log(u.email!);
      log(u.deviceLimit!);
      log(u.name!);
      log(u.password!);
      log(u.uid!);
      log(u.licenceCode!);

      if (u.email == "admin@gmail.com") {
        isSuperAdmin = true;
      }

      // Prefs
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", u.uid!);
      prefs.setString("email", u.email!);
      prefs.setString("name", u.name!);
      prefs.setString("deviceLimit", u.deviceLimit!);
      prefs.setString("licenceCode", u.licenceCode!);
      prefs.setBool("isSuperAdmin", isSuperAdmin!);

      // Add Data
      DatabaseMethods().addDataToDB("users", userUID, {
        "email": u.email,
        "licenceCode": u.licenceCode,
        "name": u.name,
        "uid": u.uid,
        "deviceLimit": u.deviceLimit,
        // "isSuperAdmin": u.isSuperAdmin,
      }).then((value) {
        log("successfully added");
        setupValues();

        log(user.licenceCode ?? "");
        log(user.name!);
        return true;
      }).catchError((err) {
        log("Failed to add: $err");
      });

      // Toast
      customWidgets.showToast("Created Successfully");
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      customWidgets.showToast(e.toString());
    }
    return false;
  }

// add notifylistner
  Future<bool> signInWithEmailAndPassword(
    context,
    email,
    password,
  ) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      prefs = await SharedPreferences.getInstance();

      if (user != null) {
        try {
          return getAndUpatePref(context, uid: user.uid, prefs: prefs);
        } catch (e) {
          log(e.toString());
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      customWidgets.showToast(e.toString());
    }
    return false;
  }

  setupValues() {
    // userLicenceCode = prefs?.getString("licenceCode") ?? "na";
    user.uid = prefs?.getString("uid") ?? "";
    user.email = prefs?.getString("email") ?? "";
    user.name = prefs?.getString("name") ?? "";
    user.deviceLimit = prefs?.getString("deviceLimit") ?? "";
    user.licenceCode = prefs?.getString("licenceCode") ?? "";
    isSuperAdmin = prefs?.getBool("isSuperAdmin") ?? false;
  }

  Future<bool> getAndUpatePref(context, {uid, prefs}) async {
    var data;

    data = await DatabaseMethods().getDataFromDB("users", uid);
    data["uid"] = uid;

    if (data == null) {
      return false;
    }

    userLicenceCode = data['licenceCode'];

    if (data["email"] == "admin@gmail.com") {
      isSuperAdmin = true;
    }

    prefs.setBool("isSuperAdmin", isSuperAdmin);
    prefs.setString("email", data["email"] ?? "");
    prefs.setString("uid", data["uid"] ?? "");
    prefs.setString("name", data["name"] ?? "");
    prefs.setString("licenceCode", data["licenceCode"] ?? "");
    setupValues();
    getDeviceDetails(context);

    log(user.licenceCode ?? "whow");
    log(user.name!);
    return true;
  }

  Future<void> updateDeviceData(deviceId, context, deviceName) async {
    try {
      await FirebaseFirestore.instance
          .collection('devices')
          .doc(deviceId)
          .update({
        'isReset': true,
      }).then(
        (value) {
          print("User Updated");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Resetting $deviceName..."),
            ),
          );
        },
      ).catchError((error) => print("Failed to update user: $error"));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => customWidgets
            .showToast("Request sent on ${auth.currentUser!.email}"))
        .catchError((e) => print(e));
  }

  signout(context) async {
    deviceDataList!.clear();
    prefs?.setBool("isSuperAdmin", false);
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.pushNamedAndRemoveUntil(
            context,
            "/signin",
            (route) => true,
          ),
        );
  }
}
