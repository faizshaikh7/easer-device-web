class DeviceInfoModel {
  String deviceMake = "";
  String deviceModel = "";
  String licenceCode = "";
  String deviceStatus = "";
  String networkStatus = "";
  bool isReset = false;
  DeviceInfoModel();
  DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    deviceMake = json["deviceMake"];
    deviceModel = json["deviceModel"];
    licenceCode = json["licenceCode"];
    deviceStatus = json["deviceStatus"];
    networkStatus = json["networkStatus"];
    isReset = json["isReset"];
  }
}
