import 'package:device_activity_web/utils/colors.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,

            style: SideMenuStyle(
                // showTooltip: false,
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: Colors.deepPurple.shade50,
                selectedColor: Colors.deepPurpleAccent,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: whiteColor,
                decoration: const BoxDecoration(),
                backgroundColor: Colors.grey.shade200),
            // title: Column(
            //   children: [
            //     ConstrainedBox(
            //         constraints: BoxConstraints(
            //           maxHeight: 150,
            //           maxWidth: 150,
            //         ),
            //         child: Image.network(
            //             "https://companieslogo.com/img/orig/ADNOCDIST.AE-45611d69.png?t=1673160675")),
            //     const Divider(
            //       indent: 8.0,
            //       endIndent: 8.0,
            //     ),
            //   ],
            // ),
            footer: SideMenuItem(
              onTap: (index, sideMenuController) {},
              title: 'Logout',
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
            alwaysShowFooter: true,
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "Dashboard to show device info",
              ),
              SideMenuItem(
                title: 'Users',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: 'Settings',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/details");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                "https://images.samsung.com/is/image/samsung/p6pim/in/sm-s911bzebins/gallery/in-galaxy-s23-s911-sm-s911bzebins-535265834?imwidth=480",
                              ),
                              title: const Text(
                                "Samsung Galaxy S23 Ultra",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              subtitle: const Text(
                                "Active",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 13),
                              ),
                              trailing: const Icon(Icons.more_vert_rounded),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Users',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
