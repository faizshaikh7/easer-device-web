// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:math' as mt;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_activity_web/screens/admin_create_account_screen.dart';
import 'package:device_activity_web/screens/admin_details_screen.dart';
import 'package:device_activity_web/services/providers/root_provider.dart';
import 'package:device_activity_web/utils/database/database_method.dart';
import 'package:device_activity_web/utils/dimensions.dart';
import 'package:device_activity_web/widgets/custom_textfield.dart';
import 'package:device_activity_web/widgets/custom_widget.dart';
import 'package:device_activity_web/widgets/wsized.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int srNo = 0;

  final TextEditingController _deviceLimitController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List? _foundUsers = [];

  @override
  void dispose() {
    _deviceLimitController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndFoundList();
  }

  Future<void> getAndFoundList() async {
    var uProv = Provider.of<RootProvider>(context, listen: false);
    await uProv.getAllUser(context);
    _foundUsers = uProv.usersList;
  }

  void filterSearchResults(String enteredKeyword, BuildContext context) {
    var prov = Provider.of<RootProvider>(context, listen: false);
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = prov.usersList!;
    } else {
      results = prov.usersList!
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  editUserDetails(context, isWebScreen, RootProvider prov, index) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text(
        "Edit Details",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      content: SizedBox(
        height: size.height / 5.5,
        width: size.width / 3,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                  controller: _nameController,
                  borderradius: 20,
                  bordercolor: Colors.deepPurple.shade100,
                  widh: isWebScreen ? 0.32 : 0.90,
                  height: isWebScreen ? 0.05 : 0.062,
                  icon: Icons.credit_card,
                  iconColor: Colors.grey.shade800,
                  textcolor: Colors.black,
                  keyboardType: TextInputType.number,
                  hinttext: 'Name',
                  hintColor: Colors.grey.shade800,
                  fontsize: 15,
                  obscureText: false),
              WSizedBox(wval: 0, hval: 0.02),
              CustomTextField(
                  controller: _deviceLimitController,
                  borderradius: 20,
                  bordercolor: Colors.deepPurple.shade100,
                  widh: isWebScreen ? 0.32 : 0.90,
                  height: isWebScreen ? 0.05 : 0.062,
                  icon: Icons.numbers_rounded,
                  iconColor: Colors.grey.shade800,
                  textcolor: Colors.black,
                  keyboardType: TextInputType.number,
                  hinttext: 'Device Limit',
                  hintColor: Colors.grey.shade800,
                  fontsize: 15,
                  obscureText: false),
              WSizedBox(wval: 0, hval: 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 25),
                child: Row(
                  children: [
                    Text(
                      "Do you wanna",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Licence Gen
                        var random = mt.Random();
                        int randomNumber = random.nextInt(9000) + 1000;
                        prov.regenLicenceCode = randomNumber;
                        customWidgets.showToast(
                            "Generated Licence Code is ${prov.regenLicenceCode}");

                        print(prov.regenLicenceCode);
                      },
                      child: Text(
                        "Regenerate Code?",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // child: const Icon(Icons.repeat_outlined),
                    ),
                  ],
                ),
              )
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
        TextButton(
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () async {
            var userUID = prov.usersList?[index]['uid'];
            if (_nameController.text != "" &&
                _deviceLimitController.text != "") {
              var res = await prov.updateUserData(
                  context,
                  userUID,
                  prov.regenLicenceCode,
                  _nameController.text,
                  _deviceLimitController.text);

              if (res) {
                var prov = Provider.of<RootProvider>(context, listen: false);
                await prov.getAllUser(context);
                _foundUsers = prov.usersList;
                prov.regenLicenceCode = null;
                _nameController.clear();
                _deviceLimitController.clear();
                // setState(() {});
              }
            } else {
              customWidgets.showToast("All Fields Required");
            }
          },
        ),
      ],
    );
  }

  // getRealtimeUpdate() async {
  //   var db = FirebaseFirestore.instance;

  //   final docRef = db.collection("users");
  //   docRef.snapshots().listen(
  //     (event) async {
  //       log("yes it works");
  //       print("yes it works");
  //     },
  //     onError: (error) => log("Listen failed: $error"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<RootProvider>(context);
    double width = MediaQuery.of(context).size.width;
    // TextEditingController editingController = TextEditingController();
    // getRealtimeUpdate();

    bool isWebScreen = true;
    if (width <= webScreenSize) {
      setState(() {
        isWebScreen = false;
      });
    }

    // void filterSearchResults(String query) {
    //   setState(() {
    //     // items = prov.usersList.where((item) => item.toLowerCase().contains(query.toLowerCase()))
    //     //     .toList();
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.antonio(
            fontSize: 25,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              print("open admin dash");
              var updateData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminCreateAccountScreen(),
                  ));

              if (updateData) {
                await prov.getAllUser(context);
                _foundUsers = prov.usersList;
              }
            },
            child: isWebScreen
                ? Text("Create Admin Account")
                : Icon(Icons.person_add_alt),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "All Users",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    isWebScreen
                        ? Container(
                            width: width / 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value) =>
                                    filterSearchResults(value, context),
                                decoration: const InputDecoration(
                                  hintText: "Search by name",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        25.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                !isWebScreen
                    ? Container(
                        height: 80,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) =>
                                filterSearchResults(value, context),
                            decoration: const InputDecoration(
                              hintText: "Search by name",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: (_foundUsers == null)
                      ? const Center(
                          child: Text("Loading..."),
                        )
                      : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sr.No",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.01,
                                    // ),
                                    Container(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "Name",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "Email",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "Licence Code",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "Device Limit",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          textAlign: TextAlign.start,
                                          "Action",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _foundUsers!.length,
                                itemBuilder: (context, index) {
                                  srNo = index + 1;
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "#$srNo",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  textAlign: TextAlign.start,
                                                  "${_foundUsers?[index]['name']}",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 150,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  textAlign: TextAlign.start,
                                                  "${_foundUsers?[index]['email']}",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${_foundUsers?[index]['licenceCode']}",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "${_foundUsers?[index]['deviceLimit']}",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    log(
                                                      _foundUsers![index]
                                                          ["name"],
                                                    );
                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (_) {
                                                        return editUserDetails(
                                                            _,
                                                            isWebScreen,
                                                            prov,
                                                            index);
                                                      },
                                                    );
                                                  },
                                                  child: const Text("Edit"),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    log(_foundUsers?[index]
                                                        ['uid']);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminDetailsScreen(
                                                          uid: _foundUsers?[
                                                              index]['uid'],
                                                          name: _foundUsers?[
                                                              index]['name'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("View"),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    var res =
                                                        await DatabaseMethods()
                                                            .deleteDataFromDatabase(
                                                      colName: "users",
                                                      userDoc:
                                                          _foundUsers?[index]
                                                              ['uid'],
                                                    );

                                                    if (res) {
                                                      await prov
                                                          .getAllUser(context);
                                                      _foundUsers =
                                                          prov.usersList;
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outlined,
                                                    color: Colors.red.shade200,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      (index <
                                              _foundUsers!.length -
                                                  1) // use list len here instead of static num
                                          ? const Divider()
                                          : const SizedBox.shrink()
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
    );
  }
}
