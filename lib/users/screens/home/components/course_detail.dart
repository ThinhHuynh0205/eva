import 'package:eva/users/screens/home/components/course_sreen.dart';
import 'package:eva/users/screens/home/components/semester_screen1.dart';
import 'package:eva/users/screens/home/components/student_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}
class SV {
  final String mssv;
  final String name;

  SV({
    required this.mssv,
    required this.name
  });
}

class Eval{
  final int eval;

  Eval({
    required this.eval
  });
}

class _DetailPageState extends State<DetailPage> {
  String? course = GlobalsCo.titleCourse;
  String? day = GlobalsCo.dayCourse;
  String? time = GlobalsCo.timeCourse;
  String? semester = GlobalsCo.semester;
  List<String> ListSV = GlobalsCo.listSV;
  List<SV> people = [];
  List<Eval> evalSV = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Gọi hàm getDataFromFirestore để lấy dữ liệu từ Firestore khi trang được khởi tạo
    getDataFromFirestore();
    getDataFromFirestore1();
  }

  Future<void> getDataFromFirestore() async {
    try {
      ListSV.sort();
      for (var mssv in ListSV) {
        var snapshot = await FirebaseFirestore.instance
            .collection('SV')
            .where('MSSV', isEqualTo: mssv)
            .get();
        if (snapshot.docs.isNotEmpty) {
          // Kiểm tra xem trường "Name" có tồn tại trong document không
          if (snapshot.docs.first.data().containsKey('Name')) {
            var name = snapshot.docs.first['Name'];
            people.add(SV(mssv: mssv, name: name));
          } else {
            print('Không tìm thấy trường "Name" trong tài liệu Firestore');
          }
        } else {
          print('Không tìm thấy sinh viên với MSSV = $mssv');
        }
      }
      setState(() {
        isLoading = false; // Khi dữ liệu đã được tải xong, đặt isLoading thành false
      });
    } catch (e) {
      print('Lỗi khi truy vấn Firestore: $e');
      setState(() {
        isLoading = false; // Khi xảy ra lỗi, vẫn đặt isLoading thành false để dừng biểu tượng tải
      });
    }
  }

  Future<void> getDataFromFirestore1() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('Atend_Eval')
          .where('Class', isEqualTo: course)
          .get();
      // Chuyển dữ liệu từ snapshot sang danh sách lop
      processData(snapshot);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }
  void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    evalSV.clear(); // Xóa dữ liệu cũ trong danh sách

    for (var docSnapshot in snapshot.docs) {
      var evalData = docSnapshot['Evaluation'];

      // Tạo đối tượng LopHoc từ dữ liệu trong docSnapshot và thêm vào danh sách lop
      evalSV.add(Eval(
        eval: evalData,
      ));
    }
    // Gọi setState để cập nhật giao diện
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Để cho phép ngang kéo lướt
          child: Text(
            '$course',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Học kỳ',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$semester'), // Đặt giá trị mặc định
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ngày',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$day'), // Đặt giá trị mặc định
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Thời gian',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$time'), // Đặt giá trị mặc định
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Trung bình đánh giá từ sinh viên',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: evalSV.isNotEmpty ? (evalSV.fold(0, (sum, eval) => sum + eval.eval) / evalSV.length).toStringAsFixed(2) : '0.00'), // Đặt giá trị mặc định
              ),
              SizedBox(height: 16),
              Text(
                "Danh sách lớp",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.deepPurpleAccent,fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(), // Hiển thị biểu tượng tải
                    )
                    : Table(
                      border: TableBorder.all(color: Colors.deepPurpleAccent),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'MSSV',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Colors.black,fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      'Tên sinh viên',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Colors.black,fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var person in people)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        person.mssv,
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          color: Colors.black,fontWeight: FontWeight.w100),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SvPage(personName: person.name, personMSSV: person.mssv),
                                          ),
                                        );
                                      },
                                      child: Text(
                                          person.name,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            color: Colors.black,fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


