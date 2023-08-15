import 'package:eva/manager/screens/home/components/manage_GV.dart';
import 'package:eva/manager/screens/home/components/manage_HK.dart';
import 'package:eva/manager/screens/home/components/manage_Lop.dart';
import 'package:eva/manager/screens/home/components/manage_SV.dart';
import 'package:eva/users/screens/home/components/calendar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageManager extends StatefulWidget {
  const HomePageManager({Key? key}) : super(key: key);

  @override
  State<HomePageManager> createState() => _HomePageManagerState();
}

class _HomePageManagerState extends State<HomePageManager> {
  bool isPlaying = false;
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
                            builder: (context) => const ManageGvPage(),
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
                                  "Giảng viên",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: 20),
                                Icon(
                                  CupertinoIcons.person_2_alt,
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
                            builder: (context) => const ManageSvPage(),
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
                                  "Sinh viên",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: 20),
                                const Icon(
                                  CupertinoIcons.person_2_fill,
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
                            builder: (context) =>  EventCalendarScreen(),
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
                                  "Lịch",
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: 20),
                                const Icon(
                                  CupertinoIcons.calendar,
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
                            builder: (context) => const ManageHkPage(),
                          ),
                        );
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
                                  "Lớp học",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Colors.white,fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: 20),
                                Icon(
                                  CupertinoIcons.person_crop_rectangle,
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
