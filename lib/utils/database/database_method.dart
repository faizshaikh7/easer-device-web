import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;

class DatabaseMethods {
  Future addDataToDB(
      String colName, String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection(colName)
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Map<String, dynamic>?> getDataFromDB(
      String colName, String userId) async {
    return (await FirebaseFirestore.instance
            .collection(colName)
            .doc(userId)
            .get())
        .data();
  }

  Future<bool> deleteDataFromDatabase(
      {String? colName, String? userDoc}) async {
    return await FirebaseFirestore.instance
        .collection(colName ?? "users")
        .doc(userDoc)
        .delete()
        .then((value) {
      print("User $userDoc Deleted");
      return true;
    }).catchError((error) {
      print(
        "Failed to delete user: $error",
      );
      return false;
    });
  }
}
