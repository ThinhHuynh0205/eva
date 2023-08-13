import 'package:eva/users/screens/home/components/calendar_screen.dart';
import 'package:eva/users/screens/home/components/profile_screen.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:flutter/material.dart';
import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  final String nameFromFirestore;
  final VoidCallback signOutCallback;

  const SideBar({Key? key,
    required this.nameFromFirestore,
    required this.signOutCallback,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();

}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               InfoCard(
                name: widget.nameFromFirestore,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                          });
                          if (menu.title == "Profile") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(), // Điều hướng tới trang ProfilePage
                              ),
                            );
                          }
                          if (menu.title == "Calendar") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventCalendarScreen(), // Điều hướng tới trang ProfilePage
                              ),
                            );
                          }
                          if (menu.title == "My Courses") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SemesterPage1(), // Điều hướng tới trang ProfilePage
                              ),
                            );
                          }
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 200),
                    OutlinedButton(
                        onPressed: widget.signOutCallback,
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding:  EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            )
                        ),
                      child: Text(
                          'Đăng xuất',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,fontWeight: FontWeight.w200),
                      )
                  ),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
