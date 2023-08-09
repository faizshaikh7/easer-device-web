import 'dart:developer';

import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/widgets/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootProvider extends ChangeNotifier {
  bool showLicenceCode = false;

  Future<bool> signUpWithEmailAndPassword(
    context,
    UserModel u,
  ) async {
    try {
      var auth = FirebaseAuth.instance;

      await auth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      customWidgets.showToast("Created Successfully");

      return true;
    } catch (e) {
      log(e.toString());
      customWidgets.showToast(e.toString());
    }
    return false;
  }

  Future<bool> signInWithEmailAndPassword(
    context,
    UserModel u,
  ) async {
    try {
      var _auth = FirebaseAuth.instance;
      var result = await _auth.signInWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );

      customWidgets.showToast("Logged In Successfully");
      return true;
    } catch (e) {
      customWidgets.showToast(e.toString());
    }
    return false;
  }
}
