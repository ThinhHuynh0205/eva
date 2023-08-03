import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void _deleteEvent(int index) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    setState(() {
      mySelectedEvents[dateKey]?.removeAt(index);
    });

    // Lưu lại dữ liệu vào bộ nhớ
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mySelectedEvents', json.encode(mySelectedEvents));
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;

    loadPreviousEvents();
  }

  void loadPreviousEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsString = prefs.getString('mySelectedEvents');

    if (eventsString != null) {
      mySelectedEvents = Map<String, List>.from(json.decode(eventsString));
    } else {
      mySelectedEvents = {};
    }
  }


  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            child: const Text('Add Event'),
            onPressed: () async {
              if (titleController.text.isEmpty &&
                  descpController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Required title and description'),
                    duration: Duration(seconds: 2),
                  ),
                );
                //Navigator.pop(context);
                return;
              } else {
                print(titleController.text);
                print(descpController.text);

                final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                setState(() {
                  if (mySelectedEvents[dateKey] != null) {
                    mySelectedEvents[dateKey]?.add({
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                    });
                  } else {
                    mySelectedEvents[dateKey] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                      }
                    ];
                  }
                });

                // Lưu lại dữ liệu vào bộ nhớ
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('mySelectedEvents', json.encode(mySelectedEvents));

                print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");
                titleController.clear();
                descpController.clear();
                Navigator.pop(context);
                return;
              }
            },
          )
        ],
      ),
    );
  }

  // _showAddEventDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         'Add New Event',
  //         textAlign: TextAlign.center,
  //       ),
  //       content: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           TextField(
  //             controller: titleController,
  //             textCapitalization: TextCapitalization.words,
  //             decoration: const InputDecoration(
  //               labelText: 'Title',
  //             ),
  //           ),
  //           TextField(
  //             controller: descpController,
  //             textCapitalization: TextCapitalization.words,
  //             decoration: const InputDecoration(labelText: 'Description'),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           child: const Text('Add Event'),
  //           onPressed: () {
  //             if (titleController.text.isEmpty &&
  //                 descpController.text.isEmpty) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('Required title and description'),
  //                   duration: Duration(seconds: 2),
  //                 ),
  //               );
  //               //Navigator.pop(context);
  //               return;
  //             } else {
  //               print(titleController.text);
  //               print(descpController.text);
  //
  //               setState(() {
  //                 if (mySelectedEvents[
  //                 DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
  //                     null) {
  //                   mySelectedEvents[
  //                   DateFormat('yyyy-MM-dd').format(_selectedDate!)]
  //                       ?.add({
  //                     "eventTitle": titleController.text,
  //                     "eventDescp": descpController.text,
  //                   });
  //                 } else {
  //                   mySelectedEvents[
  //                   DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
  //                     {
  //                       "eventTitle": titleController.text,
  //                       "eventDescp": descpController.text,
  //                     }
  //                   ];
  //                 }
  //               });
  //
  //               print(
  //                   "New Event for backend developer ${json.encode(mySelectedEvents)}");
  //               titleController.clear();
  //               descpController.clear();
  //               Navigator.pop(context);
  //               return;
  //             }
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Event Calendar Example'),
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
              firstDay:DateTime.utc(2010, 1, 1),
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
              eventLoader: _listOfDayEvents,
            ),
            ..._listOfDayEvents(_selectedDate!).asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;

              return ListTile(
                leading: const Icon(
                  Icons.done,
                  color: Colors.teal,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Event Title: ${event['eventTitle']}'),
                ),
                subtitle: Text('Description: ${event['eventDescp']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteEvent(index),
                ),
              );
            }).toList(),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        label: const Text('Add Event'),
      ),
    );
  }
}