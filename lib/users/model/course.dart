import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description, iconSrc;
  final Color color;

  Course({
    required this.title,
    this.description = 'Build and animate an iOS app from scratch',
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF7553F6),
  });
}

final List<Course> courses = [
  Course(
    title: "2017-2018 ",
  ),
  Course(
    title: "2018-2019",
    iconSrc: "assets/icons/code.svg",
    color: const Color(0xFF80A4FF),
  ),
  Course(
    title: "2019-2020",
  ),
  Course(
    title: "2019-2020",
  ),
  Course(
    title: "2019-2020",
  ),
  Course(
    title: "2021-2022",
    iconSrc: "assets/icons/code.svg",
    color: const Color(0xFF80A4FF),
  ),
];

final List<Course> recentCourses = [
  Course(title: "19DVT_CLC1"),
  Course(
    title: "19DVT_CLC1",
    color: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
  Course(title: "19DVT_CLC1"),
  Course(
    title: "19DVT_CLC1",
    color: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
  Course(title: "19DVT_CLC1"),
  Course(
    title: "19DVT_CLC1",
    color: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
  Course(title: "19DVT_CLC1"),
  Course(
    title: "19DVT_CLC1",
    color: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/code.svg",
  ),
];
