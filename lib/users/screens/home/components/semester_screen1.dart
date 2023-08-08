import 'package:eva/users/model/course.dart';

import 'package:eva/users/screens/home/components/course_sreen.dart';
import 'package:eva/users/screens/home/components/semester_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemesterPage1 extends StatefulWidget {
  const SemesterPage1({Key? key}) : super(key: key);

  @override
  State<SemesterPage1> createState() => _SemesterPage1State();
}

class GlobalsSe {
  static String? titleSemester;
}

class _SemesterPage1State extends State<SemesterPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Học kỳ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: semester
                      .map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: SemesterCard(
                      title: course.title,
                      onPressed: () {
                        GlobalsSe.titleSemester = course.title; // Lưu giá trị title vào biến global
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
