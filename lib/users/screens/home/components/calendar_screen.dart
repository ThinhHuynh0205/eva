import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  CollectionReference _eventsCollection =
  FirebaseFirestore.instance.collection('Event');

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  Future<void> _addEventToFirestore() async {
    if (_selectedDate != null) {
      String dateKey =
          "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String title = _titleController.text;
      String descp = _descpController.text;

      await _eventsCollection
          .doc(uid)
          .collection('Events')
          .doc(dateKey)
          .set({
        'eventDate': dateKey,
        'eventTitle': title,
        'eventDescp': descp,
      });

      _titleController.clear();
      _descpController.clear();
    }
  }

  Future<void> _deleteEvent(String eventKey) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await _eventsCollection
        .doc(uid)
        .collection('Events')
        .doc(eventKey)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF14AEE7),
        title: const Text(
          'Lịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: "en_US",
              rowHeight: 50,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2040, 1, 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              eventLoader: (date) => _listOfDayEvents(date, FirebaseAuth.instance.currentUser!.uid),

            ),
            StreamBuilder<QuerySnapshot>(
              stream: _eventsCollection
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Events')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<Widget> eventWidgets = [];
                snapshot.data!.docs.forEach((document) {
                  Map<String, dynamic> event =
                  document.data() as Map<String, dynamic>;
                  eventWidgets.add(
                    ListTile(
                      leading: const Icon(
                        Icons.done,
                        color: Colors.teal,
                      ),
                      title: Text('Ngày: ${event['eventDate']}'),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text('Tiêu đề: ${event['eventTitle']}'),
                              Text('Nội dung: ${event['eventDescp']}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteEvent(document.id);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  );
                });

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: eventWidgets,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Thêm sự kiện'),
      ),
    );
  }

  List<dynamic> _listOfDayEvents(DateTime dateTime, String uid) {
    final dateKey = DateFormat('yyyy-MM-dd').format(dateTime);
    if (mySelectedEvents[dateKey] != null) {
      return mySelectedEvents[dateKey]!;
    } else {
      return [];
    }
  }





  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Text(
          'Sự kiện mới',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Tựa đề',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nội dung'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            child: const Text('Thêm sự kiện'),
            onPressed: () async {
              if (_titleController.text.isEmpty &&
                  _descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tựa đề và nội dung bắt buộc'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                await _addEventToFirestore();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: EventCalendarScreen(),
    ),
  );
}