import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/onboding/onboding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../model/menu.dart';
import '../home/home_screen1.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    getDataFromFirestore();
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  String? nameFromFirestore;
  Future<void> getDataFromFirestore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('User')
          .where('UID', isEqualTo: uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên (nếu có nhiều tài liệu thỏa mãn truy vấn, ta có thể lặp qua snapshot.docs để xử lý nhiều tài liệu)
        Map<String, dynamic> data = snapshot.docs.first.data();
        // Lấy giá trị của trường "Name" và gán vào biến nameFromFirestore
        String? name = data['Name'];
        setState(() {
          nameFromFirestore = name;
        });

      } else {
        // Không tìm thấy tài liệu nào thỏa mãn truy vấn
        print('Không tìm thấy tài liệu có UID là "$uid"');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }

  void navigateToLogin()async{
    // Xóa UID khỏi SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnbodingScreen(),
      ),
    );
  }

  void exitApp() {
    // Thoát ứng dụng
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child:   SideBar(
                nameFromFirestore: '$nameFromFirestore',
              signOutCallback: navigateToLogin,
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child:  ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: WillPopScope(
                      onWillPop: () async {
                        if (Navigator.of(context).userGestureInProgress) {
                          return true;
                        } else {
                          exitApp();
                          return false;
                        }
                      },
                      child: HomePage1()),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration:  Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                  () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                    controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
