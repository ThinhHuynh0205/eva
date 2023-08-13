import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/manager/screens/home/components/sv_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageSvPage extends StatefulWidget {
  const ManageSvPage({Key? key}) : super(key: key);

  @override
  State<ManageSvPage> createState() => _ManageSvPageState();
}
String generateRandomId() {
  const int length = 21;
  const String chars =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  Random random = Random();
  List<int> charCodes = List.generate(length, (index) {
    return chars.codeUnitAt(random.nextInt(chars.length));
  });

  return String.fromCharCodes(charCodes);
}

class SV {
  final String nameSV, MSSV, card_id, email;

  SV({
    required this.nameSV,
    required this.MSSV,
    required this.card_id,
    required this.email,
  });
}

class _ManageSvPageState extends State<ManageSvPage> {
  List<SV> sinhvien = [];
  String nameSV = '';
  String email = '';
  String MSSV = '';
  String Card_id = '';

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('SV').get();

      final List<SV> fetchedSinhVien = querySnapshot.docs
          .map((doc) {
        final data = doc.data(); // Lấy dữ liệu từ DocumentSnapshot
        return SV(
          nameSV: data.containsKey('Name') ? data['Name'] : '',
          MSSV: data.containsKey('MSSV') ? data['MSSV'] : '',
          card_id: data.containsKey('card_id') ? data['card_id'] : '',
          email: data.containsKey('email') ? data['email'] : '',
        );
      })
          .toList();

      setState(() {
        sinhvien = fetchedSinhVien;
      });
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Lỗi khi lấy dữ liệu từ Firestore: $error');
    }
  }

  Future<void> _addStudentToFirestore() async {
    try {
      String id = generateRandomId();
      await FirebaseFirestore.instance.collection('SV').doc(id).set({
        'Name': nameSV,
        'MSSV': MSSV,
        'email': email,
        'card_id': Card_id,
      });

      Navigator.pop(context); // Đóng hộp thoại sau khi thêm thành công
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Lỗi khi thêm sinh viên: $error');
    }
  }

  Future<void> _refreshData() async {
    await _fetchDataFromFirestore(); // Gọi hàm _fetchDataFromFirestore để load lại dữ liệu
  }

  void _showDetailDialog(BuildContext context, SV sinhvienItem) {
    String updatedName = sinhvienItem.nameSV;
    String updatedMSSV = sinhvienItem.MSSV;
    String updatedEmail = sinhvienItem.email;
    String updatedCardId = sinhvienItem.card_id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Thông tin sinh viên'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tên sinh viên'),
                  controller: TextEditingController(text: updatedName),
                  onChanged: (value) {
                    updatedName = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Mã số sinh viên'),
                  controller: TextEditingController(text: updatedMSSV),
                  onChanged: (value) {
                    updatedMSSV = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: TextEditingController(text: updatedEmail),
                  onChanged: (value) {
                    updatedEmail = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Card ID'),
                  controller: TextEditingController(text: updatedCardId),
                  onChanged: (value) {
                    updatedCardId = value;
                  },
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
              onPressed: () async {
                try {
                  // Truy vấn document có tên và MSSV tương ứng
                  QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance
                      .collection('SV')
                      .where('Name', isEqualTo: sinhvienItem.nameSV)
                      .where('MSSV', isEqualTo: sinhvienItem.MSSV)
                      .get();

                  if (querySnapshot.size > 0) {
                    // Cập nhật thông tin sinh viên trên Cloud Firestore
                    await querySnapshot.docs[0].reference.update({
                      'Name': updatedName,
                      'MSSV': updatedMSSV,
                      'email': updatedEmail,
                      'card_id': updatedCardId,
                    });

                    // Đóng hộp thoại và hiển thị thông báo cập nhật thành công
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Cập nhật thông tin thành công.'),
                    ));
                  } else {
                    // Không tìm thấy document phù hợp
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Không tìm thấy sinh viên.'),
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
                  // Xử lý lỗi cập nhật
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Cập nhật thông tin không thành công.'),
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
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }
  void _showDeleteDialog(BuildContext context, SV sinhvienItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa sinh viên này?'),
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
                      .collection('SV')
                      .where('Name', isEqualTo: sinhvienItem.nameSV)
                      .where('MSSV', isEqualTo: sinhvienItem.MSSV)
                      .get();

                  if (querySnapshot.size > 0) {
                    // Xóa document khỏi Cloud Firestore
                    await querySnapshot.docs[0].reference.delete();

                    // Cập nhật lại danh sách sinh viên
                    _fetchDataFromFirestore();

                    // Đóng hộp thoại và hiển thị thông báo xóa thành công
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Xóa sinh viên thành công.'),
                    ));
                  } else {
                    // Không tìm thấy document phù hợp
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Không tìm thấy sinh viên.'),
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
                        content: Text('Xóa sinh viên không thành công.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF14AEE7),
        title: const Text(
          'Sinh viên',
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
                      title: Text('Thêm sinh viên'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                nameSV = value;
                              },
                              decoration: InputDecoration(labelText: 'Tên sinh viên'),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              onChanged: (value) {
                                MSSV = value;
                              },
                              decoration: InputDecoration(labelText: 'MSSV'),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              onChanged: (value) {
                                Card_id = value;
                              },
                              decoration: InputDecoration(labelText: 'Card ID'),
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
                            _addStudentToFirestore();
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
                    children: sinhvien
                        .map((sinhvienItem) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: SvCard(
                        nameSV: sinhvienItem.nameSV,
                        MSSV: sinhvienItem.MSSV,
                        onPressed: () {
                          _showDetailDialog(context, sinhvienItem); // Truyền giá trị vào đây
                        },
                        onDelete: () {
                          _showDeleteDialog(context, sinhvienItem); // Sự kiện xóa
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
