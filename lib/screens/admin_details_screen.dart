// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:developer';
import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:device_activity_web/utils/database/database_method.dart';
import 'package:device_activity_web/utils/dimensions.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminDetailsScreen extends StatefulWidget {
  AdminDetailsScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  String name;
  String uid;

  @override
  State<AdminDetailsScreen> createState() => _AdminDetailsScreenState();
}

class _AdminDetailsScreenState extends State<AdminDetailsScreen> {
  var appBarHeight = AppBar().preferredSize.height;
  bool? testAdmin;
  UserModel user = UserModel();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    var usrProv = Provider.of<RootProvider>(context, listen: false);

    Future.delayed(Duration.zero, () {
      updateData();
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    });
    usrProv.setupValues();
  }

  deviceDetailsDialogBox(BuildContext context, RootProvider prov, index) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        "${prov.adminViewDeviceDataList?[index]['deviceMake']} ${prov.adminViewDeviceDataList?[index]['deviceModel']}",
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      content: SizedBox(
        height: size.height / 3.2,
        width: size.width / 3,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Make:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${prov.adminViewDeviceDataList?[index]['deviceMake']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Model:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${prov.adminViewDeviceDataList?[index]['deviceModel']}",
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // new
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Licence Code:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${prov.adminViewDeviceDataList?[index]['licenceCode']}",

                    // user.licenceCode ?? "dad",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Device Status:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${prov.adminViewDeviceDataList?[index]['deviceStatus']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Network Status:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${prov.adminViewDeviceDataList?[index]['networkStatus']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  updateData() async {
    var prov = Provider.of<RootProvider>(context, listen: false);
    // var uid = auth.currentUser!.uid;
    var data = await DatabaseMethods().getDataFromDB("users", widget.uid);
    print(data?['licenceCode']);
    prov.adminViewUserLicenceCode = data?['licenceCode'];
    await prov.getDeviceDetails(context, isAdminView: true);
    // print(prov.adminViewDeviceDataList?[0]);
    print(prov.adminViewDeviceDataList);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    bool isWebScreen = true;
    if (width <= webScreenSize) {
      setState(() {
        isWebScreen = false;
      });
    }
    var prov = Provider.of<RootProvider>(context);

    testAdmin = true;

    return Scaffold(
      body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: (_isLoading)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.deepPurpleAccent.shade200,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Loading..."),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      (prov.adminViewDeviceDataList?.length != 0)
                          ? "Availble Devices"
                          : "No Device Available",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "VIEWING ${widget.name.toUpperCase()}",
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    prov.adminViewDeviceDataList != null
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: prov.adminViewDeviceDataList?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: (prov.adminViewDeviceDataList!
                                              .isNotEmpty)
                                          ? ListTile(
                                              title: Row(
                                                children: [
                                                  (isWebScreen)
                                                      ? Image.network(
                                                          "https://images.samsung.com/is/image/samsung/p6pim/in/sm-s911bzebins/gallery/in-galaxy-s23-s911-sm-s911bzebins-535265834?imwidth=480",
                                                          height: 150,
                                                        )
                                                      : const SizedBox.shrink(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 15,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: (isWebScreen)
                                                              ? width / 2.5
                                                              : width * 0.70,
                                                          child: Text(
                                                            "${prov.adminViewDeviceDataList?[index]['deviceMake']} ${prov.adminViewDeviceDataList?[index]['deviceModel']}",
                                                            softWrap: false,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${prov.adminViewDeviceDataList?[index]['deviceStatus']}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red
                                                                        .shade400,
                                                              ),
                                                              onPressed: () {
                                                                var deviceId =
                                                                    prov.adminViewDeviceDataList?[
                                                                            index]
                                                                        [
                                                                        'deviceId'];
                                                                var isReset =
                                                                    prov.adminViewDeviceDataList?[
                                                                            index]
                                                                        [
                                                                        'isReset'];

                                                                print(isReset);
                                                                log(deviceId);
                                                                if (deviceId !=
                                                                        null ||
                                                                    deviceId !=
                                                                        "") {
                                                                  prov.updateDeviceData(
                                                                    deviceId,
                                                                    context,
                                                                    "${prov.adminViewDeviceDataList?[index]['deviceMake']} ${prov.adminViewDeviceDataList?[index]['deviceModel']}",
                                                                  );
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Reset",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                log(index
                                                                    .toString());
                                                                showDialog<
                                                                    bool>(
                                                                  context:
                                                                      context,
                                                                  builder: (_) {
                                                                    return deviceDetailsDialogBox(
                                                                        context,
                                                                        prov,
                                                                        index);
                                                                  },
                                                                );
                                                              },
                                                              child: const Text(
                                                                  "Details"),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              // trailing: IconButton(
                                              //   onPressed: () {},
                                              //   icon:
                                              //       const Icon(Icons.more_vert_rounded),
                                              // ),
                                            )
                                          : const Center(
                                              child:
                                                  Text("No Device Available.."),
                                            ),
                                    ));
                              },
                            ),
                          )
                        : const Center(
                            child:
                                Text("No Device Available! Add to Continue."),
                          ),
                  ],
                )),
    );
  }
}
