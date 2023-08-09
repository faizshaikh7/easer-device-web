class UserModel {
  String email = "";
  String name = "";
  String password = "";
  String uid = "";
  UserModel();
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
    name = json["name"];
    name = json["uid"];
  }
}
