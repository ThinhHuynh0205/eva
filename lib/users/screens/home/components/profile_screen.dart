import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/users/screens/onboding/components/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class ProfileGV {
  final String nameGV, chucvuGV, emailGV;

  ProfileGV({
    required this.nameGV,
    required this.chucvuGV,
    required this.emailGV,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  List<ProfileGV> profile = [];
  String? queriedUid; // Thêm biến tạm thời để lưu uid từ truy vấn

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore when the profile page is loaded
    getDataFromFirestore();
  }

  Future<void> getDataFromFirestore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid'); // Truy xuất uid từ SharedPreferences

      if (uid != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('User')
            .where('UID', isEqualTo: uid)
            .get();
        queriedUid = snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null; // Lưu uid tạm thời
        processData(snapshot);
      }
    } catch (e) {
      // Handle errors if any
      print('Firestore Query Error: $e');
    }
  }


  void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
    profile.clear(); // Clear the list before adding new data
    for (var docSnapshot in snapshot.docs) {
      var nameData = docSnapshot['Name'];
      var chucvuData = docSnapshot['Chức vụ'];
      var emailData = docSnapshot['email'];

      profile.add(ProfileGV(
        nameGV: nameData,
        chucvuGV: chucvuData,
        emailGV: emailData,
      ));
    }

    // Call setState to update the UI
    setState(() {});
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
        child: (profile.isNotEmpty)
            ? ProfileCard(
          name: profile[0].nameGV,
          chucvu: profile[0].chucvuGV,
          email: profile[0].emailGV,
          queriedUid: queriedUid,
        )
            : CircularProgressIndicator(), // Show loading indicator if profile is empty
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  final String? name;
  final String? chucvu;
  final String? email;
  final String? queriedUid;

  const ProfileCard(
      {Key? key,
        required this.name,
        required this.chucvu,
        required this.email,
        required this.queriedUid,})
      : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name ?? '';
    _titleController.text = widget.chucvu ?? '';
    _emailController.text = widget.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF80A4FF),
                    width: 3,
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.person,
                  size: 150,
                  color: Color(0xFF80A4FF),
                ),
              ),
              SizedBox(height: 70),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên giảng viên'),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Chức vụ'),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF80A4FF),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: () {
                  _saveChanges();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (widget.queriedUid != null) {
      String name = _nameController.text;
      String title = _titleController.text;
      String email = _emailController.text;

      try {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(widget.queriedUid) // Use widget.queriedUid
            .update({
          'Name': name,
          'Chức vụ': title,
          'email': email,
        });

        print('Data updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved successfully!')),
        );
      } catch (e) {
        print('Error updating data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating data')),
        );
      }
    }
  }
}