import 'package:calendar_demo/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(2021),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,
            //Day changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,
            // To style the selected date
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(6.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                //color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),

            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: true,
              formatButtonShowsNext: false,
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(event.title),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Add Event'),
                  content: TextFormField(
                    controller: _eventController,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_eventController.text.isEmpty) {
                        } else {
                          if (selectedEvents[selectedDay] != null &&
                              selectedEvents[selectedDay]!.length <= 2) {
                            selectedEvents[selectedDay]!
                                .add(Event(title: _eventController.text));
                          }
                          // else if (selectedEvents[selectedDay]!.length >1) {
                          //   print('Day already got an event');
                          // }
                          else {
                            selectedEvents[selectedDay] = [
                              Event(title: _eventController.text)
                            ];
                          }
                        }
                        Navigator.pop(context);
                        _eventController.clear();
                        setState(() {});
                        return;
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                )),
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
