import 'package:eva/users/screens/home/components/calendar_screen.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:eva/users/screens/home/components/text.dart';
import 'package:eva/users/screens/home/components/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  CityPage(),
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
                                "Search",
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,fontWeight: FontWeight.w900),
                              ),
                                const Icon(
                                  CupertinoIcons.search,
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
