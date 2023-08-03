import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  String? uid = UserAuthData.uid;
  String? nameFromFirestore;

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore when the profile page is loaded
    getDataFromFirestore();
  }
  Future<void> getDataFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('User')
          .where('UID', isEqualTo: "$uid")
          .get();
      if (snapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên (nếu có nhiều tài liệu thỏa mãn truy vấn, ta có thể lặp qua snapshot.docs để xử lý nhiều tài liệu)
        Map<String, dynamic> data = snapshot.docs.first.data();
        // Lấy giá trị của trường "Name" và gán vào biến nameFromFirestore
        String? name = data['Name'];
        // Gọi phương thức để cập nhật giá trị name cho toàn bộ widget con trong _TextPageState
        updateName(name);

      } else {
        // Không tìm thấy tài liệu nào thỏa mãn truy vấn
        print('Không tìm thấy tài liệu có UID là "$uid"');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi truy vấn Firestore: $e');
    }
  }
  // Phương thức để cập nhật giá trị name cho toàn bộ widget con trong _TextPageState
  void updateName(String? newName) {
    setState(() {
      nameFromFirestore = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: ProfileCard(name: nameFromFirestore),
        ),
    );
  }
}
class ProfileCard extends StatefulWidget {
  final String? name;

  const ProfileCard({Key? key, this.name}) : super(key: key);
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name ?? '';
    _titleController.text = 'Software Engineer';
    _phoneController.text = '123-456-7890';
    _emailController.text = 'johndoe@example.com';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Định dạng thành hình tròn
                border: Border.all(
                  color: Color(0xFF80A4FF), // Màu của viền khung tròn
                  width: 3, // Độ dày của viền khung tròn
                ),
              ),
              padding: EdgeInsets.all(8), // Khoảng cách giữa biểu tượng và khung tròn
              child: Icon(
                Icons.person,
                size: 150,
                color: Color(0xFF80A4FF),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 50),
            TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
              ),
            SizedBox(height: 50),
            TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFF80A4FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )
              ),
              onPressed: () {
                // Xử lý sự kiện lưu thông tin chỉnh sửa
                _saveChanges();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // Ở đây, bạn có thể sử dụng các giá trị từ các controller để lưu thông tin
    // chỉnh sửa vào các biến khác hoặc đối tượng, hoặc lưu vào cơ sở dữ liệu.
    String name = _nameController.text;
    String title = _titleController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;

    // In thông tin mới sau khi lưu (để xem kết quả trong terminal)
    print('New name: $name');
    print('New title: $title');
    print('New phone: $phone');
    print('New email: $email');

    // Thông báo cho người dùng rằng thông tin đã được lưu thành công (nếu có)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Changes saved successfully!')),
    );
  }
}