import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/home/components/calendar_screen.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:eva/users/screens/home/components/text.dart';
import 'package:eva/users/screens/home/components/profile_screen.dart';
import 'package:eva/users/screens/home/home_screen1.dart';
import 'package:eva/users/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  bool isPlaying = false;
  UpdateStatus _updateStatus = UpdateStatus();
  UpdateEnd _updateEnd = UpdateEnd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SemesterPage1(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFF5DC4EA),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              "My Courses",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white,fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 20),
                              Icon(
                                CupertinoIcons.home,
                                  color: Colors.white,
                                size: 50,
                              ),
                            ]
                          ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF14AEE7),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                              "Profile",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,fontWeight: FontWeight.w900),
                            ),
                              SizedBox(height: 20),
                              const Icon(
                                CupertinoIcons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventCalendarScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF69ADC9),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                "Calendar",
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,fontWeight: FontWeight.w900),
                              ),
                                SizedBox(height: 20),
                                const Icon(
                                  CupertinoIcons.time,
                                  color: Colors.white,
                                  size: 50,
                                ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    height: 320,
                    width: 190,
                    child: OutlinedButton(
                      onPressed: (){
                        setState(() {
                          if (isPlaying) {
                            // Khi đang play thì thực hiện logic update 'end' thành '1'
                            // ở document có UID là uid của collection User
                            _updateEnd.updateEndTo1();
                          } else {
                            // Khi đang pause thì thực hiện logic update 'status' thành '1'
                            // ở document có UID là uid của collection User
                            _updateStatus.updateStatusTo1();
                          }
                          isPlaying = !isPlaying; // Đảo trạng thái play/pause
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFF0891C4),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          )
                      ),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6, right: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                "Hardware ",
                                  textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,fontWeight: FontWeight.w900),
                              ),
                                SizedBox(height: 20),
                                Icon(
                                  isPlaying
                                      ? CupertinoIcons.pause_solid
                                      : CupertinoIcons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class UpdateEnd {
  Future<void> updateEndTo1() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      // Lấy danh sách các documents thỏa mãn điều kiện
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('User')
          .where('UID', isEqualTo: uid)
          .get();

      // Lấy ID của document đầu tiên nếu có
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs[0].id;

        // Cập nhật dữ liệu 'status' thành '1' cho document có ID là documentId
        await FirebaseFirestore.instance.collection('User').doc(documentId).update({
          'end': 1,
        });

        print('Status updated successfully for document with ID: $documentId');
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
class UpdateStatus {
  Future<void> updateStatusTo1() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      // Lấy danh sách các documents thỏa mãn điều kiện
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('User')
          .where('UID', isEqualTo: uid)
          .get();

      // Lấy ID của document đầu tiên nếu có
      if (snapshot.docs.isNotEmpty) {
        String documentId = snapshot.docs[0].id;

        // Cập nhật dữ liệu 'status' thành '1' cho document có ID là documentId
        await FirebaseFirestore.instance.collection('User').doc(documentId).update({
          'status': 1,
        });

        print('Status updated successfully for document with ID: $documentId');
      } else {
        print('No matching documents found');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}