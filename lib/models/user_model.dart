class UserModel {
  String? email;
  String? name;
  // bool? isSuperAdmin;
  String? deviceLimit;
  String? password;
  String? licenceCode;
  String? uid;

  static fromSnapshot(Map<String, dynamic> json) {
    var z = UserModel();
    z.email = json["email"];
    z.password = json["password"];
    z.name = json["name"];
    // z.isSuperAdmin = json["isSuperAdmin"];
    z.deviceLimit = json["deviceLimit"];
    z.licenceCode = json["licenceCode"];
    z.uid = json["uid"];
    return z;
  }
}
