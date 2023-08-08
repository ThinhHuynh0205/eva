import 'package:flutter/material.dart' show Color;

class Course {
  final String title, description;
  final Color color;


  Course( {
    required this.title,
    required this.description,
    this.color = const Color(0xFF7553F6),
  });
}
final List<Course> semester = [
  Course(
      title: "1/2019-2020", description: ''
  ),
  Course(
      title: "1/2022-2023", description: ''
  ),
  Course(
    title: "2/2022-2023", description: '',
  ),
  Course(
      title: "3/2022-2023", description: ''
  ),
];


