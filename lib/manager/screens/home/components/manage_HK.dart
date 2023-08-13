import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/manager/screens/home/components/manage_HKcard.dart';
import 'package:eva/manager/screens/home/components/manage_Lop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageHkPage extends StatefulWidget {
  const ManageHkPage({Key? key}) : super(key: key);

  @override
  State<ManageHkPage> createState() => _ManageHkPageState();
}
class GlobalsHK {
  static String? hk;
}

class _ManageHkPageState extends State<ManageHkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF14AEE7),
        title: const Text(
          'Học kỳ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 40,
            onPressed: () async {
              // Hiển thị hộp thoại để nhập thông tin học kỳ
              String? newSemester = await showDialog<String>(
                context: context,
                builder: (context) {
                  String inputValue = ''; // Biến để lưu giá trị người dùng nhập
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Text('Thêm học kỳ mới'),
                    content: TextField(
                      onChanged: (value) {
                        inputValue = value;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Đóng hộp thoại
                        },
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, inputValue); // Trả về giá trị người dùng nhập
                        },
                        child: Text('Thêm'),
                      ),
                    ],
                  );
                },
              );

              // Kiểm tra nếu có giá trị mới, thêm vào Firestore
              if (newSemester != null && newSemester.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('Semester')
                    .doc('9irYKoLVl0uH61ztrbpn')
                    .update({
                  'semester': FieldValue.arrayUnion([newSemester]),
                });
              }
            },
          ),
        ],
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
                        child: HkCard(
                          title: semesterTitle,
                          onDelete: () async {
                            // Xóa học kỳ khỏi Firestore
                            await FirebaseFirestore.instance
                                .collection('Semester')
                                .doc('9irYKoLVl0uH61ztrbpn')
                                .update({
                              'semester': FieldValue.arrayRemove([semesterTitle]),
                            });
                          },
                          onPressed: (){
                            GlobalsHK.hk = semesterTitle;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageLopPage(),
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
