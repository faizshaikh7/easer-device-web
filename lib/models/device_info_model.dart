class DeviceInfoModel {
  String deviceMake = "";
  String deviceModel = "";
  String licenceCode = "";
  String deviceStatus = "";
  String networkStatus = "";
  String joinedDate = "";
  bool isReset = false;
  DeviceInfoModel();
  DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    deviceMake = json["deviceMake"];
    deviceModel = json["deviceModel"];
    licenceCode = json["licenceCode"];
    deviceStatus = json["deviceStatus"];
    networkStatus = json["networkStatus"];
    joinedDate = json["joinedDate"];
    isReset = json["isReset"];
  }
}
