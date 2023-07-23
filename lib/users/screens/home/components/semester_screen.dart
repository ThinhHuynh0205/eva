import 'package:eva/users/model/course.dart';
import 'package:eva/users/screens/home/components/course_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemesterPage extends StatefulWidget {
  const SemesterPage({super.key});

  @override
  State<SemesterPage> createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {
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
                  children: courses
                      .map(
                        (course) => Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: CourseCard(
                        title: course.title,
                        iconSrc: course.iconSrc,
                        color: course.color,
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
