// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Components/Requests.dart';
import '../Login/forgotVerify.dart';
import './utils.dart';

class EstimateCalendar extends StatefulWidget {
  final ScreenArguments arguments;

  const EstimateCalendar(this.arguments, {super.key});
  @override
  _TableEventsExampleState createState() =>
      _TableEventsExampleState(this.arguments);
}

class _TableEventsExampleState extends State<EstimateCalendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  LinkedHashMap<DateTime, List<Event>> events =
      LinkedHashMap<DateTime, List<Event>>();
  late final ScreenArguments arguments;
  _TableEventsExampleState(this.arguments);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    events = LinkedHashMap<DateTime, List<Event>>();
    super.initState();

    getParsedDates().then((value) {
      setState(() {
        events = value;
      });
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();

    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example

    return this.events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(
      DateTime? start, DateTime? end, DateTime focusedDay) async {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    getParsedDates();

    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      width = MediaQuery.of(context).size.width * 0.8;

      // print("1");
    } else {
      width = MediaQuery.of(context).size.width * 0.45;

      // print("2");
    }
    var rawMessage = "testing";
    // ignore: unnecessary_null_comparison
    if (arguments.message == null) {
    } else {
      rawMessage = arguments.message;
    }
    var reschedule = false;
    print(reschedule);
    if (jsonDecode(rawMessage)['reschedule'] != null) {
      setState(() {
        reschedule = true;
      });
    }
    print(reschedule);
    final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

    return Scaffold(
      key: _key,
      appBar: AppBar(
          title: reschedule
              ? const Text(
                  "Available Appointments",
                  style: TextStyle(fontSize: 25),
                )
              : Text("Estimates"),
          leading: reschedule
              ? ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF395B64))),
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  child: const Icon(size: 30, color: Colors.white, Icons.menu))
              : null),
      drawer: reschedule
          ? Drawer(
              width: 75,
              backgroundColor: Colors.transparent,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 1.5)
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .15),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed('/quotes',
                                arguments: json.encode({
                                  "id":
                                      jsonDecode(this.arguments.message)['id'],
                                  "token": jsonDecode(
                                      this.arguments.message)['token']
                                }));
                          },
                          child: Icon(
                              size: 30,
                              color: Colors.white,
                              Icons.request_quote)),
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed(
                                '/guestappointments',
                                arguments: json.encode({
                                  "id":
                                      jsonDecode(this.arguments.message)['id'],
                                  "token": jsonDecode(
                                      this.arguments.message)['token']
                                }));
                          },
                          child: Icon(
                              size: 30,
                              color: Colors.white,
                              Icons.edit_calendar)),
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed(
                                '/estimatecalendar',
                                arguments: json.encode({
                                  "id": jsonDecode(arguments.message)['id'],
                                  "token":
                                      jsonDecode(arguments.message)['token'],
                                  "reschedule": true
                                }));
                          },
                          child: Icon(
                              size: 30,
                              color: Colors.white,
                              Icons.calendar_month)),
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed(
                                '/clientsettings',
                                arguments: json.encode({
                                  "id": jsonDecode(arguments.message)['id'],
                                  "token":
                                      jsonDecode(arguments.message)['token'],
                                }));
                          },
                          child: Icon(
                              size: 30, color: Colors.white, Icons.settings)),
                      SizedBox(height: MediaQuery.of(context).size.height * .1),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed('/');
                          },
                          child: Icon(
                              size: 30, color: Colors.white, Icons.logout)),
                    ],
                  )),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            LimitedBox(
                maxWidth: width * .98,
                child: Container(
                    padding: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        color: Color(0xFF0000000),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF0000), spreadRadius: 3)
                        ]),
                    child: TableCalendar<Event>(
                      headerStyle: const HeaderStyle(
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          headerMargin: EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                              color: Color(0xFF395B64),
                              border: Border(
                                left: BorderSide(
                                  //                   <--- left side
                                  color: Color(0xFF395B64),
                                  width: 1.3,
                                ),
                                top: BorderSide(
                                  //                    <--- top side
                                  color: Color(0xFF395B64),
                                  width: 1.3,
                                ),
                                bottom: BorderSide(
                                  //                   <--- left side
                                  color: Color(0xFF395B64),
                                  width: 1.3,
                                ),
                                right: BorderSide(
                                  //                    <--- top side
                                  color: Color(0xFF395B64),
                                  width: 1.3,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(
                                      10.0) //,                 <--- border radius here
                                  )),
                          formatButtonDecoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  //                   <--- left side
                                  color: Colors.white,
                                  width: 1.3,
                                ),
                                top: BorderSide(
                                  //                    <--- top side
                                  color: Colors.white,
                                  width: 1.3,
                                ),
                                bottom: BorderSide(
                                  //                   <--- left side
                                  color: Colors.white,
                                  width: 1.3,
                                ),
                                right: BorderSide(
                                  //                    <--- top side
                                  color: Colors.white,
                                  width: 1.3,
                                ),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(
                                      10.0) //                 <--- border radius here
                                  )),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          )),
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Color(0xFFffffff),
                            fontSize: 17.5,
                            overflow: TextOverflow.visible,
                          ),
                          weekendStyle: TextStyle(
                              color: Colors.yellowAccent[100],
                              fontSize: 17.5,
                              overflow: TextOverflow.visible)),
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      calendarStyle: const CalendarStyle(

                          // Use `CalendarStyle` to customize the UI
                          cellMargin: EdgeInsets.all(2.5),
                          markerSize: 10,
                          markerMargin: EdgeInsets.only(top: 20),
                          canMarkersOverflow: true,
                          markerDecoration: BoxDecoration(
                              color: Color(0xFFffffff), shape: BoxShape.circle),
                          outsideDaysVisible: false,
                          selectedDecoration: BoxDecoration(
                              color: const Color(0xFF395B64),
                              shape: BoxShape.circle),
                          todayDecoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          defaultTextStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          weekendTextStyle:
                              TextStyle(color: Colors.white, fontSize: 20)),
                      onDaySelected: _onDaySelected,
                      onRangeSelected: _onRangeSelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    )))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LimitedBox(
                  maxWidth: width * .98,
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                            'Days with a dot have avaialble time slots which will be shown below once selected.\n\nYou can then select the desired slot ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 20,
                            )),
                      )))
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LimitedBox(
                  maxWidth: width * .98,
                  child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color(0xFF395B64),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFF395B64), spreadRadius: 3)
                          ]),
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                            '${_selectedDay?.month}/${_selectedDay?.day}/${_selectedDay?.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 30,
                            )),
                      )))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            LimitedBox(
                maxWidth: width * .98,
                maxHeight: 500,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF0000000),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF0000), spreadRadius: 3)
                        ]),
                    height: 300,
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Time Slots Available',
                                  style:
                                      TextStyle(fontSize: 22, letterSpacing: 2),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    //                   <--- left side
                                    color: index == value.length - 1
                                        ? Colors.black
                                        : Colors.white,
                                    width: 1.3,
                                  ))),
                                  child: ListTile(
                                    onTap: () {
                                      var x = events[DateTime(
                                              _selectedDay!.year,
                                              _selectedDay!.month,
                                              _selectedDay!.day)] ??
                                          [];

                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(20),
                                                actionsPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 40),
                                                title:
                                                    const Text('Confirm Slot'),
                                                content: Text(
                                                  'Choosen day: ${_selectedDay?.month}/${_selectedDay?.day}/${_selectedDay?.year}\nChosen time slot:${x.elementAt(index)}',
                                                ),
                                                actions: <Widget>[
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.black)
                                                    //?
                                                    ),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, 'Decline');
                                                },
                                                child: const Text('Decline',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily: 'opjn')),
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.black)
                                                    //?
                                                    ),
                                                onPressed: () {
                                                  Map<String, dynamic>
                                                      appointment_slot = {
                                                    "date": DateTime(
                                                            _selectedDay!.year,
                                                            _selectedDay!.month,
                                                            _selectedDay!.day)
                                                        .toString(),
                                                    "time": x
                                                        .elementAt(index)
                                                        .toString(),
                                                    "type": reschedule
                                                        ? "client_appointment"
                                                        : "client_estimate",
                                                    "clientId": jsonDecode(
                                                        rawMessage)['id']
                                                  };
                                                  x.removeAt(index);
                                                  var slotsAvailable = [];
                                                  for (var i = 0;
                                                      i < x.length;
                                                      i++) {
                                                    slotsAvailable.add(x
                                                        .elementAt(i)
                                                        .toString());
                                                  }
                                                  Map<String, dynamic>
                                                      estimateDay = {
                                                    "date": DateTime(
                                                            _selectedDay!.year,
                                                            _selectedDay!.month,
                                                            _selectedDay!.day)
                                                        .toString(),
                                                    "appointment_slots": [
                                                      appointment_slot
                                                    ],
                                                    "daySlotsAvailable":
                                                        slotsAvailable
                                                  };
                                                  print("new obj " +
                                                      json.encode(estimateDay));
                                                  Requests()
                                                      .createEstimate(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          "http://10.0.2.2:8080/calendar/calendar/estimate",
                                                          estimateDay,
                                                          jsonDecode(
                                                                  rawMessage)[
                                                              'token'])
                                                      .then((value) {
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            '/guestappointments',
                                                            arguments: json
                                                                .encode({
                                                              "id": jsonDecode(
                                                                      rawMessage)[
                                                                  'id'],
                                                              "token": jsonDecode(
                                                                      rawMessage)[
                                                                  'token']
                                                            }));
                                                  });
                                                },
                                                child: const Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'opjn'),
                                                ),
                                              ),
                                              SizedBox(width: 25),
                                              SizedBox(height: 30)
                                            ]),
                                      );

                                      // print(
                                      //     'confirmed for ${_selectedDay} at ${value[index]}');
                                    },
                                    title: Text('${value[index]}'),
                                  ),
                                )
                              ]);
                            }
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                //                   <--- left side
                                color: index == value.length - 1
                                    ? Colors.black
                                    : Colors.white,
                                width: 1.3,
                              ))),
                              child: ListTile(
                                onTap: () {
                                  var x = events[DateTime(
                                          _selectedDay!.year,
                                          _selectedDay!.month,
                                          _selectedDay!.day)] ??
                                      [];

                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            contentPadding: EdgeInsets.all(20),
                                            actionsPadding:
                                                const EdgeInsets.only(
                                                    bottom: 40),
                                            title: const Text('Confirm Slot'),
                                            content: Text(
                                              'Choosen day: ${_selectedDay?.month}/${_selectedDay?.day}/${_selectedDay?.year}\nChosen time slot:${x.elementAt(index)}',
                                            ),
                                            actions: <Widget>[
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)
                                                //?
                                                ),
                                            onPressed: () {
                                              Navigator.pop(context, 'Decline');
                                            },
                                            child: const Text('Decline',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'opjn')),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                foregroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)
                                                //?
                                                ),
                                            onPressed: () {
                                              Map<String, dynamic>
                                                  appointment_slot = {
                                                "date": DateTime(
                                                        _selectedDay!.year,
                                                        _selectedDay!.month,
                                                        _selectedDay!.day)
                                                    .toString(),
                                                "time": x
                                                    .elementAt(index)
                                                    .toString(),
                                                "type": "client_estimate",
                                                "clientId":
                                                    jsonDecode(rawMessage)['id']
                                              };
                                              x.removeAt(index);
                                              var slotsAvailable = [];
                                              for (var i = 0;
                                                  i < x.length;
                                                  i++) {
                                                slotsAvailable.add(
                                                    x.elementAt(i).toString());
                                              }
                                              Map<String, dynamic> estimateDay =
                                                  {
                                                "date": DateTime(
                                                        _selectedDay!.year,
                                                        _selectedDay!.month,
                                                        _selectedDay!.day)
                                                    .toString(),
                                                "appointment_slots": [
                                                  appointment_slot
                                                ],
                                                "daySlotsAvailable":
                                                    slotsAvailable
                                              };
                                              print("new obj " +
                                                  json.encode(estimateDay));
                                              Requests()
                                                  .createEstimate(
                                                      // ignore: prefer_interpolation_to_compose_strings
                                                      "http://10.0.2.2:8080/calendar/calendar/estimate",
                                                      estimateDay,
                                                      jsonDecode(
                                                          rawMessage)['token'])
                                                  .then((value) {
                                                print(value);
                                                Navigator.of(context)
                                                    .popAndPushNamed(
                                                        '/guestappointments',
                                                        arguments: json.encode({
                                                          "id": jsonDecode(
                                                              rawMessage)['id'],
                                                          "token": jsonDecode(
                                                                  rawMessage)[
                                                              'token']
                                                        }));
                                              });
                                            },
                                            child: const Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'opjn'),
                                            ),
                                          ),
                                          SizedBox(width: 25),
                                          SizedBox(height: 30)
                                        ]),
                                  );

                                  // print(
                                  //     'confirmed for ${_selectedDay} at ${value[index]}');
                                },
                                title: Text('${value[index]}'),
                              ),
                            );
                          },
                        );
                      },
                    )))
          ])
        ],
      ),
    );
  }
}
