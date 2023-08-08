import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/home/components/course_sreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SvPage extends StatefulWidget {
  final String personName;
  final String personMSSV;

  SvPage({required this.personName, required this.personMSSV});

  @override
  State<SvPage> createState() => _SvPageState();
}

class Date{
  final String date;

  Date({
   required this.date
});
}

class _SvPageState extends State<SvPage> {
  String? course = GlobalsCo.titleCourse;
  List<Date> ngayhoc = [];

  @override
  void initState() {
    super.initState();
    // Gọi hàm getDataFromFirestore để lấy dữ liệu từ Firestore khi trang được khởi tạo
    getDataFromFirestore();
  }

  Future<void> getDataFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('Atend_Eval')
          .where('Class', isEqualTo: course)
          .where('Name', isEqualTo: '${widget.personName}')
          .get();
      // Chuyển dữ liệu từ snapshot sang danh sách lop
      processData(snapshot);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }

  void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    ngayhoc.clear(); // Xóa dữ liệu cũ trong danh sách

    for (var docSnapshot in snapshot.docs) {
      var dateData = docSnapshot['Date'];

      // Tạo đối tượng LopHoc từ dữ liệu trong docSnapshot và thêm vào danh sách lop
      ngayhoc.add(Date(
        date: dateData,
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
        title: const Text(
            'Thông tin sinh viên',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      labelText: 'Tên sinh viên',
                      hintText: '',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                        text: '${widget.personName}',
                    ), // Đặt giá trị mặc định
                  ),
                  SizedBox(height: 50),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mã số sinh viên',
                      hintText: '',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: '${widget.personMSSV}'), // Đặt giá trị mặc định
                  ),
                  SizedBox(height: 50),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Số buổi đã học',
                      hintText: '',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: '${ngayhoc.length}'), // Đặt giá trị mặc định
                  ),
                  SizedBox(height: 50),
                  Text(
                      "Các ngày đã học",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,fontWeight: FontWeight.w100),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Table(
                            children: [
                              for (var ngay in ngayhoc)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(ngay.date),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        ),
                      )
                  )
              ]
            )
        ),
      ),
    );
  }
}
