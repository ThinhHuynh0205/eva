import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/manager/screens/home/components/manage_HK.dart';
import 'package:eva/manager/screens/home/components/manage_Lop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({Key? key}) : super(key: key);

  @override
  State<ClassDetail> createState() => _ClassDetailState();
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

class _ClassDetailState extends State<ClassDetail> {
  String? Class = GlobalsClass.nameclass;
  String? GV = GlobalsClass.namegv;
  String? time = GlobalsClass.time;
  String? day = GlobalsClass.day;
  String? UID = GlobalsClass.UID;
  String? card_id = GlobalsClass.card_id;
  String? semester = GlobalsHK.hk;
  List<String> ListSV = GlobalsClass.listSV;
  List<SV> people = [];
  List<Eval> evalSV = [];
  bool isLoading = true;

  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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
          .where('Class', isEqualTo: Class)
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
  Future<void> _saveChanges() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            ),
          title: Text('Cập nhật thời gian'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Ngày'),
                controller: _dayController,
              ),
              Text('Chỉ cần nhập số( T2=2,..., T7=7, Cn=1)',
                style: TextStyle(
                  fontSize: 12, // Kích thước chữ (đơn vị là điểm ảnh)
                  fontWeight: FontWeight.w200, // Độ đậm của chữ
                  color: Colors.black, // Màu chữ
                  // Các thuộc tính khác như fontFamily, letterSpacing, ...
                ),),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Thời gian'),
                controller: _timeController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await _updateDateTime(); // Hàm cập nhật Ngày và Thời gian
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _updateDateTime() async {
    try {
      String newDay = _dayController.text;
      String newTime = _timeController.text;

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('LopHoc')
          .where('Class', isEqualTo: Class)
          .where('Semaster', isEqualTo: semester)
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
      in querySnapshot.docs) {
        await docSnapshot.reference.update({
          'Day': newDay,
          'Time': newTime,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lưu thay đổi thành công.'),
      ));
    } catch (error) {
      print('Lỗi khi lưu thay đổi: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF14AEE7),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Để cho phép ngang kéo lướt
          child: Text(
            '$Class',
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
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Giảng viên',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$GV'), // Đặt giá trị mặc định
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Ngày',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$day'),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Thời gian',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(text: '$time'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                onPressed: _saveChanges, // Gọi hàm lưu thay đổi
                child: Text(
                  'Cập nhật',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Trung bình đánh giá từ sinh viên',
                  hintText: '',
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: evalSV.isNotEmpty
                      ? double.parse((evalSV.fold(0, (sum, eval) => sum + eval.eval) / evalSV.length).toString()).toStringAsFixed(2)
                      : '0.00',

                ), // Đặt giá trị mặc định
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newMSSV = '';

                      return AlertDialog(
                        title: Text('Thêm Sinh viên'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'MSSV'),
                              onChanged: (value) {
                                newMSSV = value;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if (newMSSV.isNotEmpty ) {
                                // Truy vấn tài liệu lớp học dựa trên Class và Semester
                                QuerySnapshot<Map<String, dynamic>> querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('LopHoc')
                                    .where('Class', isEqualTo: Class)
                                    .where('Semaster', isEqualTo: semester)
                                    .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  // Lấy ID của tài liệu
                                  String docId = querySnapshot.docs.first.id;

                                  // Cập nhật danh sách sinh viên trên Firestore
                                  ListSV.add(newMSSV);
                                  await FirebaseFirestore.instance
                                      .collection('LopHoc')
                                      .doc(docId)
                                      .update({'ListSV': ListSV});
                                  setState(() {});

                                  Navigator.of(context).pop(); // Đóng AlertDialog
                                }
                              }
                            },
                            child: Text('Thêm'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Đóng AlertDialog
                            },
                            child: Text('Hủy'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Danh sách lớp",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.blueAccent,fontWeight: FontWeight.w900),
                ),
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
                      border: TableBorder.all(color: Colors.blue),
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
                                      child: Text(
                                        person.name,
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            color: Colors.black,fontWeight: FontWeight.w100),
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
