import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/manager/screens/home/components/gv_card.dart';
import 'package:eva/manager/screens/home/components/manage_Lop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageGvPage extends StatefulWidget {
  const ManageGvPage({Key? key}) : super(key: key);

  @override
  State<ManageGvPage> createState() => _ManageGvPageState();
}

class GV {
  final String nameGV, chucvu, UID, card_id, email;

  GV({
    required this.nameGV,
    required this.chucvu,
    required this.UID,
    required this.card_id,
    required this.email,
  });
}

class _ManageGvPageState extends State<ManageGvPage> {
  List<GV> giangvien = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('User').get();

      final List<GV> fetchedGiangVien = querySnapshot.docs
          .map((doc) {
        final data = doc.data(); // Lấy dữ liệu từ DocumentSnapshot
        return GV(
          nameGV: data.containsKey('Name') ? data['Name'] : '',
          chucvu: data.containsKey('Chức vụ') ? data['Chức vụ'] : '',
          UID: data.containsKey('UID') ? data['UID'] : '',
          card_id: data.containsKey('card_id') ? data['card_id'] : '',
          email: data.containsKey('email') ? data['email'] : '',
        );
      })
          .toList();

      setState(() {
        giangvien = fetchedGiangVien;
      });
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Lỗi khi lấy dữ liệu từ Firestore: $error');
    }
  }


  void _showRegistrationDialog(BuildContext context) {
    String name = '';
    String email = '';
    String password = '';
    String confirmPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Thêm giảng viên'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tên giảng viên'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
                  obscureText: true,
                  onChanged: (value) {
                    confirmPassword = value;
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
                if (password == confirmPassword) {
                  try {
                    // Đăng ký tài khoản mới trên Authentication
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Lấy UID của tài khoản vừa tạo
                    String uid = FirebaseAuth.instance.currentUser!.uid;

                    // Lưu thông tin vào Firestore
                    await FirebaseFirestore.instance.collection('User').doc(uid).set({
                      'Name': name,
                      'Chức vụ': '',
                      'UID': uid,
                      'card_id': '',
                      'email': email,
                      'end': '0',
                      'status': '0',
                    });

                    // Đóng hộp thoại và hiển thị thông báo đăng ký thành công
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Thành công'),
                          content: Text('Đăng ký tài khoản thành công.'),
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
                  } catch (e) {
                    // Xử lý lỗi đăng ký
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Lỗi'),
                          content: Text('Đăng ký tài khoản không thành công.'),
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
                } else {
                  // Hiển thị thông báo mật khẩu không khớp
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Mật khẩu không khớp.'),
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
              child: Text('Đăng ký'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await _fetchDataFromFirestore(); // Gọi hàm _fetchDataFromFirestore để load lại dữ liệu
  }

  void _showDetailDialog(BuildContext context, GV giangvienItem) {
    String updatedName = giangvienItem.nameGV;
    String updatedChucvu = giangvienItem.chucvu;
    String updatedEmail = giangvienItem.email;
    String updatedCardId = giangvienItem.card_id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Thông tin giảng viên'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tên giảng viên'),
                  controller: TextEditingController(text: updatedName),
                  onChanged: (value) {
                    updatedName = value;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Chức vụ'),
                  controller: TextEditingController(text: updatedChucvu),
                  onChanged: (value) {
                    updatedChucvu = value;
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

                  QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance
                      .collection('User')
                      .where('UID', isEqualTo: giangvienItem.UID)
                      .get();

                  for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
                  in querySnapshot.docs) {
                    await docSnapshot.reference.update({
                      'Name': updatedName,
                      'Chức vụ': updatedChucvu,
                      'email': updatedEmail,
                      'card_id': updatedCardId,
                    });
                  }

                  // Đóng hộp thoại và hiển thị thông báo cập nhật thành công
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Cập nhật thông tin thành công.'),
                  ));
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
  void _showDeleteDialog(BuildContext context, GV giangvienItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa giảng viên này?'),
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
                  // Xóa dữ liệu từ Firestore
                  await FirebaseFirestore.instance
                      .collection('User')
                      .doc(giangvienItem.UID)
                      .delete();

                  // Cập nhật lại danh sách giảng viên
                  _fetchDataFromFirestore();

                  // Đóng hộp thoại và hiển thị thông báo xóa thành công
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Xóa giảng viên thành công.'),
                  ));
                } catch (error) {
                  // Xử lý lỗi xóa
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Lỗi'),
                        content: Text('Xóa giảng viên không thành công.'),
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
          'Giảng viên',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: (){
                _showRegistrationDialog(context);
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
                    children: giangvien
                        .map((giangvienItem) => Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: GvCard(
                        nameGV: giangvienItem.nameGV,
                        description: giangvienItem.chucvu,
                        onPressed: () {
                          _showDetailDialog(context, giangvienItem); // Truyền giá trị vào đây
                        },
                        onDelete: () {
                          _showDeleteDialog(context, giangvienItem); // Sự kiện xóa
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
