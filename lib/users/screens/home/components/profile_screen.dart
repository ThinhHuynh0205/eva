import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          child: ProfileCard(),
        ),
    );
  }
}
class ProfileCard extends StatefulWidget {
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
    _nameController.text = 'John Doe';
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