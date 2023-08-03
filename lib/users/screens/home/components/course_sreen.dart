import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/home/components/course_card.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:eva/users/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}
class LopHoc {
  final String title, description;
  final Color color;

  LopHoc({
    required this.title,
    required this.description,
    this.color = const Color(0xFF7553F6),
  });
}

class _CoursePageState extends State<CoursePage> {
  String? uid = UserAuthData.uid;
  String? selectedTitle = Globals.titleSemester;
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
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('LopHoc')
          .where('UID', isEqualTo: uid)
          .where('Semester', isEqualTo: selectedTitle)
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

      String dayDate = getDayDate(dayData);

      // Tạo đối tượng LopHoc từ dữ liệu trong docSnapshot và thêm vào danh sách lop
      lop.add(LopHoc(title: classData, description: '$dayDate'));
    }

    // Gọi setState để cập nhật giao diện
    setState(() {});
  }
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
                  children: lop
                      .map((course) => Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20),
                    child: CourseCard(
                      title: course.title, description: course.description,
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
