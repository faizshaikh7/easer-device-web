// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:device_activity_web/models/user_model.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:device_activity_web/utils/colors.dart';
import 'package:device_activity_web/utils/database/database_method.dart';
import 'package:device_activity_web/utils/dimensions.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum Options { dashboard, password, logout, refresh }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  UserModel user = UserModel();
  bool? testAdmin;

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();

    var usrProv = Provider.of<RootProvider>(context, listen: false);

    if (usrProv.showLicenceCode) {
      Future.delayed(Duration.zero, () {
        getAndSaveLicenceCode(context, usrProv);
      });
    }
    if (usrProv.userLicenceCode.isEmpty) {
      Future.delayed(Duration.zero, () {
        updateData();
      });
    }
    usrProv.setupValues();
  }

  getAndSaveLicenceCode(context, RootProvider rootProv) {
    rootProv.showLicenceCode = false;
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return licenceCodeDialogBox(context, rootProv);
      },
    );
  }

  licenceCodeDialogBox(context, RootProvider prov) {
    return AlertDialog(
      title: Text("Licence Code is ${prov.userLicenceCode}"),
      // title: Text("Licence Code is ${prov.userLicenceCode}"),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      content: Text(
        textAlign: TextAlign.center,
        'Your Licence Code is ${prov.userLicenceCode}, Use this Code to access App Functions',
        style: const TextStyle(color: Colors.black54, fontSize: 20),
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

  deviceDetailsDialogBox(BuildContext context, RootProvider prov, index) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        "${prov.deviceDataList?[index]['deviceMake']} ${prov.deviceDataList?[index]['deviceModel']}",
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
                    "${prov.deviceDataList?[index]['deviceMake']}",
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
                    "${prov.deviceDataList?[index]['deviceModel']}",
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
                    "${prov.deviceDataList?[index]['licenceCode']}",

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
                    "${prov.deviceDataList?[index]['deviceStatus']}",
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
                    "${prov.deviceDataList?[index]['networkStatus']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              // const Divider(),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Joined Date:",
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       "01/01/2001",
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              //     ),
              //   ],
              // ),
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
    var uid = auth.currentUser!.uid;
    var data = await DatabaseMethods().getDataFromDB("users", uid);
    print(data?['licenceCode']);
    prov.userLicenceCode = data?['licenceCode'];
    await prov.getDeviceDetails(context);
    // print(prov.deviceDataList?[0]);
    print(prov.deviceDataList);
  }

  var _popupMenuItemIndex = 0;
  var appBarHeight = AppBar().preferredSize.height;

  PopupMenuItem _buildPopupMenuItem(
    String title,
    IconData iconData,
    int position,
  ) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(title),
        ],
      ),
    );
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

    _onMenuItemSelected(int value) {
      setState(() {
        _popupMenuItemIndex = value;
      });

      if (value == Options.password.index) {
        prov.resetPassword(email: auth.currentUser!.email!);
      } else if (value == Options.dashboard.index) {
        print("open admin dash");
        Navigator.pushNamed(context, "/admin_screen");
      } else if (value == Options.logout.index) {
        prov.signout(context);
      } else if (value == Options.refresh.index) {
        log(prov.isSuperAdmin.toString());
      } else {
        return null;
      }
    }

    testAdmin = true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Easer System",
          style: GoogleFonts.antonio(
            fontSize: 25,
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              _onMenuItemSelected(value as int);
            },
            offset: Offset(0.0, appBarHeight),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            itemBuilder: (ctx) => [
              prov.isSuperAdmin!
                  ? _buildPopupMenuItem('Create Admin Account', Icons.dashboard,
                      Options.dashboard.index)
                  : _buildPopupMenuItem('Refresh Page', Icons.refresh_rounded,
                      Options.refresh.index),
              _buildPopupMenuItem(
                  'Change Password', Icons.password, Options.password.index),
              _buildPopupMenuItem(
                  'Logout Account', Icons.exit_to_app, Options.logout.index),
            ],
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                (prov.deviceDataList?.length != 0)
                    ? "Availble Devices"
                    : "No Device Available",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              Text(
                "Use this Auto-Generated Licence Code ${prov.userLicenceCode} to Login or Add Device from Mobile App",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              prov.deviceDataList != null
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: prov.deviceDataList?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: (prov.deviceDataList!.isNotEmpty)
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: (isWebScreen)
                                                        ? width / 2.5
                                                        : width * 0.70,
                                                    child: Text(
                                                      "${prov.deviceDataList?[index]['deviceMake']} ${prov.deviceDataList?[index]['deviceModel']}",
                                                      softWrap: false,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${prov.deviceDataList?[index]['deviceStatus']}",
                                                    style: const TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                        ),
                                                        onPressed: () {
                                                          var deviceId =
                                                              prov.deviceDataList?[
                                                                      index]
                                                                  ['deviceId'];
                                                          var isReset = prov
                                                                  .deviceDataList?[
                                                              index]['isReset'];

                                                          print(isReset);
                                                          log(deviceId);
                                                          if (deviceId !=
                                                                  null ||
                                                              deviceId != "") {
                                                            prov.updateDeviceData(
                                                              deviceId,
                                                              context,
                                                              "${prov.deviceDataList?[index]['deviceMake']} ${prov.deviceDataList?[index]['deviceModel']}",
                                                            );
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Reset",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          log(index.toString());
                                                          showDialog<bool>(
                                                            context: context,
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
                                        child: Text("No Device Available.."),
                                      ),
                              ));
                        },
                      ),
                    )
                  : const Center(
                      child: Text("No Device Available! Add to Continue."),
                    ),
            ],
          )),
    );
  }
}
