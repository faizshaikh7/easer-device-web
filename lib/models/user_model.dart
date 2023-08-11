class UserModel {
  String? email;
  String? name;
  String? password;
  String? licenceCode;
  String? uid;

  static fromSnapshot(Map<String, dynamic> json) {
    var z = UserModel();
    z.email = json["email"];
    z.password = json["password"];
    z.name = json["name"];
    z.licenceCode = json["licenceCode"];
    z.uid = json["uid"];
    return z;
  }
}
