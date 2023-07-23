import 'package:eva/users/screens/home/components/secondary_course_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/course.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Lớp học',
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
                  children: recentCourses
                      .map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: SecondaryCourseCard(
                      title: course.title,
                      iconsSrc: course.iconSrc,
                      colorl: course.color,
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
