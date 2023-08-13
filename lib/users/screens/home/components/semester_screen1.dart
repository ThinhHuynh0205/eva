import 'package:cloud_firestore/cloud_firestore.dart';
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
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Semester')
                    .doc('9irYKoLVl0uH61ztrbpn')
                    .snapshots(), // Stream để lắng nghe thay đổi dữ liệu
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Đã xảy ra lỗi: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // Kiểm tra xem document có tồn tại và có trường 'semester' không
                  if (snapshot.data == null || !snapshot.data!.exists) {
                    return Text('Không có dữ liệu học kỳ.');
                  }

                  List<dynamic> semesterArray = snapshot.data!['semester'];
                  semesterArray.sort((a, b) {
                    final partsA = a.split('-');
                    final partsB = b.split('-');

                    final comparisonB = partsB[1].compareTo(partsA[1]);
                    if (comparisonB != 0) {
                      return comparisonB; // Sắp xếp theo phần B trước nếu khác nhau
                    }

                    return partsB[0].compareTo(partsA[0]); // Nếu phần B giống nhau, sắp xếp theo phần A giảm dần
                  });

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: semesterArray
                          .map((semesterTitle) => Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: SemesterCard(
                          title: semesterTitle,
                          onPressed: () {
                            GlobalsSe.titleSemester = semesterTitle; // Lưu giá trị title vào biến global
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoursePage(),
                              ),
                            );
                          },
                        ),
                      ))
                          .toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}