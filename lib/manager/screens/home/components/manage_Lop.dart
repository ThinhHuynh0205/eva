import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/manager/screens/home/components/class_card.dart';
import 'package:eva/manager/screens/home/components/class_detail.dart';
import 'package:eva/manager/screens/home/components/manage_HK.dart';
import 'package:eva/manager/screens/home/components/manage_SV.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageLopPage extends StatefulWidget {
  const ManageLopPage({Key? key}) : super(key: key);

  @override
  State<ManageLopPage> createState() => _ManageLopPageState();
}

class GlobalsClass{
  static String? nameclass;
  static String? namegv;
  static String? day;
  static String? time;
  static String? UID;
  static String? card_id;
  static List<String> listSV = [];
}

class CLASS {
  final String nameClass, giangvien, day, time, UID, card_id;
  final List<String> listSV;

  CLASS({
    required this.nameClass,
    required this.giangvien,
    required this.UID,
    required this.card_id,
    required this.day,
    required this.time,
    required this.listSV,
  });
}

class _ManageLopPageState extends State<ManageLopPage> {
  String? hk = GlobalsHK.hk;
  List<CLASS> lophoc = [];
  String nameClass = '';
  String giangvien = '';
  String time = '';
  String day = '';
  String UID = '';
  String card_id = '';


  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
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

  Future<void> _fetchDataFromFirestore() async {
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('LopHoc')
          .where('Semaster', isEqualTo: hk)
          .get();

      // Chuyển dữ liệu từ snapshot sang danh sách lophoc
      processData(snapshot);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }

  void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    lophoc.clear(); // Xóa dữ liệu cũ trong danh sách

    for (var docSnapshot in snapshot.docs) {
      var data = docSnapshot.data();
      var dayData = docSnapshot['Day'];
      String dayDate = getDayDate(dayData);
      List<String> listSVData = List<String>.from(docSnapshot['ListSV']);
      //List<String> listSVData = data.containsKey('listSV')
       //   ? List<String>.from(data['listSV'])
        //  : [];

      lophoc.add(CLASS(
        nameClass: data.containsKey('Class') ? data['Class'] : '',
        giangvien: data.containsKey('GV') ? data['GV'] : '',
        UID: data.containsKey('UID') ? data['UID'] : '',
        card_id: data.containsKey('card_id') ? data['card_id'] : '',
        day: dayDate,
        time: data.containsKey('Time') ? data['Time'] : '',
        listSV: listSVData,
      ));
    }

    // Gọi setState để cập nhật giao diện
    setState(() {});
  }


  Future<void> _addClassToFirestore() async {
    try {
      String id = generateRandomId();
      await FirebaseFirestore.instance.collection('LopHoc').doc(id).set({
        'Class': nameClass,
        'GV': giangvien,
        'Semaster': hk,
        'Day': day,
        'Time': time,
        'UID': '',
        'card_id': '',
        'ListSV': [],
      });

      Navigator.pop(context); // Đóng hộp thoại sau khi thêm thành công
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Lỗi khi thêm lớp học: $error');
    }
  }

  void _showDeleteDialog(BuildContext context, CLASS classItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa lớp học này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Truy vấn document có tên và MSSV tương ứng
                  QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance
                      .collection('LopHoc')
                      .where('Class', isEqualTo: classItem.nameClass)
                      .where('GV', isEqualTo: classItem.giangvien)
                      .get();

                  if (querySnapshot.size > 0) {
                    // Xóa document khỏi Cloud Firestore
                    await querySnapshot.docs[0].reference.delete();

                    // Cập nhật lại danh sách sinh viên
                    _fetchDataFromFirestore();

                    // Đóng hộp thoại và hiển thị thông báo xóa thành công
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Xóa lớp học thành công.'),
                    ));
                  } else {
                    // Không tìm thấy document phù hợp
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Không tìm thấy lớp học.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (error) {
                  // Xử lý lỗi xóa
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Xóa lớp học không thành công.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await _fetchDataFromFirestore(); // Gọi hàm _fetchDataFromFirestore để load lại dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF14AEE7),
        title:  Text(
          '$hk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Text('Thêm lớp học'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              nameClass = value;
                            },
                            decoration: InputDecoration(labelText: 'Lớp học'),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            onChanged: (value) {
                              giangvien = value;
                            },
                            decoration: InputDecoration(labelText: 'Giảng viên'),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            onChanged: (value) {
                              time = value;
                            },
                            decoration: InputDecoration(labelText: 'Thời gian'),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            onChanged: (value) {
                              day = value;
                            },
                            decoration: InputDecoration(labelText: 'Thứ'),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addClassToFirestore();
                        },
                        child: Text('Thêm'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
            iconSize: 40,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: lophoc
                        .map((classItem) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: ClassCard(
                        nameClass: classItem.nameClass,
                        giangvien: classItem.giangvien,
                        semester: '$hk',
                        onPressed: () {
                          GlobalsClass.nameclass = classItem.nameClass;
                          GlobalsClass.namegv = classItem.giangvien;
                          GlobalsClass.day = classItem.day;
                          GlobalsClass.time = classItem.time;
                          GlobalsClass.listSV = classItem.listSV;
                          GlobalsClass.UID = classItem.UID;
                          GlobalsClass.card_id = classItem.card_id;
                          print(classItem.listSV);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassDetail(),
                            ),
                          );
                        },
                        onDelete: () {
                          _showDeleteDialog(context, classItem); // Sự kiện xóa
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
      ),
    );
  }
}