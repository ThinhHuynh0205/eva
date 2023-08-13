import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/home/components/course_card.dart';
import 'package:eva/users/screens/home/components/course_detail.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:eva/users/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class GlobalsCo{
  static String? titleCourse;
  static String? timeCourse;
  static String? dayCourse;
  static String? semester;
  static List<String> listSV = [];
}

class LopHoc {
  final String title, description,time,semester;
  final Color color;
  final List<String> listSV;

  LopHoc({
    required this.title,
    required this.semester,
    required this.time,
    required this.description,
    required this.listSV,
    this.color = const Color(0xFF7553F6),
  });
}

class _CoursePageState extends State<CoursePage> {
  String? selectedTitle = GlobalsSe.titleSemester;
  List<LopHoc> lop = [];

  @override
  void initState() {
    super.initState();
    // Gọi hàm getDataFromFirestore để lấy dữ liệu từ Firestore khi trang được khởi tạo
    getDataFromFirestore();
  }
  String getDayDate(String day) {
    switch (day) {
      case '1':
        return 'Chủ nhật';
      case '2':
        return 'Thứ hai';
      case '3':
        return 'Thứ ba';
      case '4':
        return 'Thứ tư';
      case '5':
        return 'Thứ năm';
      case '6':
        return 'Thứ sáu';
      case '7':
        return 'Thứ bảy';
      default:
        return 'Không xác định';
    }
  }

  Future<void> getDataFromFirestore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('LopHoc')
          .where('UID', isEqualTo: uid)
          .where('Semaster', isEqualTo: selectedTitle)
          .get();
      // Chuyển dữ liệu từ snapshot sang danh sách lop
      processData(snapshot);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }

  // Hàm chuyển dữ liệu từ snapshot sang danh sách lop
  void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    lop.clear(); // Xóa dữ liệu cũ trong danh sách

    for (var docSnapshot in snapshot.docs) {
      var classData = docSnapshot['Class'];
      var dayData = docSnapshot['Day'];
      var timeData = docSnapshot['Time'];
      var semesterData = docSnapshot['Semaster'];

      String dayDate = getDayDate(dayData);
      List<String> listSVData = List<String>.from(docSnapshot['ListSV']);

      // Tạo đối tượng LopHoc từ dữ liệu trong docSnapshot và thêm vào danh sách lop
      lop.add(LopHoc(
          title: classData,
          description: '$dayDate',
          time: timeData,
          semester: semesterData,
        listSV: listSVData,
      ));
    }

    // Gọi setState để cập nhật giao diện
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF14AEE7),
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
                  children: lop
                      .map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: CourseCard(
                      title: course.title, description: course.description,
                      onPressed: () {
                        GlobalsCo.titleCourse = course.title;
                        GlobalsCo.dayCourse = course.description;
                        GlobalsCo.timeCourse = course.time;
                        GlobalsCo.semester = course.semester;
                        GlobalsCo.listSV = course.listSV;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(),
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
