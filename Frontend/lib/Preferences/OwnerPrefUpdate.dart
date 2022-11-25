import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:test_app/Login/forgotVerify.dart';

import '../Components/Requests.dart';

class OwnerPrefUpdate extends StatefulWidget {
  final ScreenArguments arguments;

  const OwnerPrefUpdate(this.arguments, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _OwnerPrefUpdate createState() => _OwnerPrefUpdate(this.arguments);
}

class _OwnerPrefUpdate extends State<StatefulWidget> {
  late final ScreenArguments arguments;

  // ignore: use_key_in_widget_constructors, non_constant_identifier_names
  _OwnerPrefUpdate(this.arguments);
  @override
  void initState() {
    super.initState();
    getOwnerPref();
  }

  TextEditingController mondayT1 = new TextEditingController();
  TextEditingController mondayT2 = new TextEditingController();
  TextEditingController tuesdayT1 = new TextEditingController();
  TextEditingController tuesdayT2 = new TextEditingController();
  TextEditingController wednesdayT1 = new TextEditingController();
  TextEditingController wednesdayT2 = new TextEditingController();
  TextEditingController thursdayT1 = new TextEditingController();
  TextEditingController thursdayT2 = new TextEditingController();
  TextEditingController fridayT1 = new TextEditingController();
  TextEditingController fridayT2 = new TextEditingController();
  TextEditingController saturdayT1 = new TextEditingController();
  TextEditingController saturdayT2 = new TextEditingController();
  TextEditingController sundayT1 = new TextEditingController();
  TextEditingController sundayT2 = new TextEditingController();
  getOwnerPref() {
    Requests().getOwnerPref().then((value) {
      List prefs = json.decode(value);
      for (var i = 0; i < prefs.length; i++) {
        var element = prefs.elementAt(i);
        switch (element["day"]) {
          case (1):
            _selectedItems.add("monday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              monday = true;
              mondayT1.text = timeslots[0];
              mondayT2.text = ending.toString() + ":" + splitted[1];
            });

            break;
          case (2):
            _selectedItems.add("tuesday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              tuesday = true;
              tuesdayT1.text = timeslots[0];
              tuesdayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
          case (3):
            _selectedItems.add("wednesday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              wednesday = true;
              wednesdayT1.text = timeslots[0];
              wednesdayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
          case (4):
            _selectedItems.add("thursday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              thursday = true;
              thursdayT1.text = timeslots[0];
              thursdayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
          case (5):
            _selectedItems.add("friday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              friday = true;
              fridayT1.text = timeslots[0];
              fridayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
          case (6):
            _selectedItems.add("saturday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              saturday = true;
              saturdayT1.text = timeslots[0];
              saturdayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
          case (0):
            _selectedItems.add("sunday");
            List timeslots = element["time_slots"];
            var end = timeslots[timeslots.length - 1].toString();
            var splitted = end.split(':');
            var ending = int.parse(splitted[0]) + 1;
            setState(() {
              sunday = true;
              sundayT1.text = timeslots[0];
              sundayT2.text = ending.toString() + ":" + splitted[1];
            });
            break;
        }
      }
    });
  }

  late List<String> _selectedItems = [];
  late bool monday = false;
  late bool tuesday = false;
  late bool wednesday = false;
  late bool thursday = false;
  late bool friday = false;
  late bool saturday = false;
  late bool sunday = false;
  Map<String, dynamic> preferences = {};

  Map<String, dynamic> Work() {
    preferences = {};
    for (var i = 0; i < _selectedItems.length; i++) {
      switch (_selectedItems.elementAt(i)) {
        case ("monday"):
          preferences.addAll(<String, dynamic>{
            "Pref1": {
              "day": "Monday",
              "from": mondayT1.text,
              "to": mondayT2.text
            }
          });
          break;
        case ("tuesday"):
          preferences.addAll(<String, dynamic>{
            "Pref2": {
              "day": "Tuesday",
              "from": tuesdayT1.text,
              "to": tuesdayT2.text
            }
          });
          break;
        case ("wednesday"):
          preferences.addAll(<String, dynamic>{
            "Pref3": {
              "day": "Wednesday",
              "from": wednesdayT1.text,
              "to": wednesdayT2.text
            }
          });
          break;
        case ("thursday"):
          preferences.addAll(<String, dynamic>{
            "Pref4": {
              "day": "Thursday",
              "from": thursdayT1.text,
              "to": thursdayT2.text
            }
          });
          break;
        case ("friday"):
          preferences.addAll(<String, dynamic>{
            "Pref5": {
              "day": "Friday",
              "from": fridayT1.text,
              "to": fridayT2.text
            }
          });
          break;
        case ("saturday"):
          preferences.addAll(<String, dynamic>{
            "Pref6": {
              "day": "Saturday",
              "from": saturdayT1.text,
              "to": saturdayT2.text
            }
          });
          break;
        case ("sunday"):
          preferences.addAll(<String, dynamic>{
            "Pref7": {
              "day": "Sunday",
              "from": sundayT1.text,
              "to": sundayT2.text
            }
          });
          break;
      }
    }
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3), () {

    // });

    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.9;
    } else {
      width = 700;
    }
    // ignore: avoid_print
    var rawMessage = "testing";
    // ignore: unnecessary_null_comparison
    if (arguments.message == null) {
    } else {
      rawMessage = arguments.message;
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Day Availability',
              style: TextStyle(
                color: Color(0xFFA5C9CA),
                fontWeight: FontWeight.w100,
                fontSize: 30,
              ))),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Update days and time slots as desired',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("monday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("monday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("monday")) {
                      setState(() {
                        _selectedItems.add("monday");
                        monday = true;
                      });
                    } else if (_selectedItems.contains("monday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "monday");
                        monday = false;
                        mondayT1.text = '';
                        mondayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'open'),
                      textAlign: TextAlign.center,
                      'Monday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: monday,
                child: Center(
                    child: TextField(
                  controller: mondayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        mondayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
            //getdata iterate through in list then get contorller from slecetd as they are mapped append to list of obbjects return
            //postable date pref obj
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: monday,
                child: Center(
                    child: TextField(
                  controller: mondayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        mondayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("tuesday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("tuesday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("tuesday")) {
                      setState(() {
                        _selectedItems.add("tuesday");
                        tuesday = true;
                      });
                    } else if (_selectedItems.contains("tuesday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "tuesday");
                        tuesday = false;
                        tuesdayT1.text = '';
                        tuesdayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                          fontSize: 50,
                          fontFamily: 'open'),
                      textAlign: TextAlign.center,
                      'Tuesday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: tuesday,
                child: Center(
                    child: TextField(
                  controller: tuesdayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        tuesdayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: tuesday,
                child: Center(
                    child: TextField(
                  controller: tuesdayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        tuesdayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("wednesday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("wednesday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("wednesday")) {
                      setState(() {
                        _selectedItems.add("wednesday");
                        wednesday = true;
                      });
                    } else if (_selectedItems.contains("wednesday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "wednesday");
                        wednesday = false;
                        wednesdayT1.text = '';
                        wednesdayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'open',
                          letterSpacing: 1),
                      textAlign: TextAlign.center,
                      'Wednesday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: wednesday,
                child: Center(
                    child: TextField(
                  controller:
                      wednesdayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        wednesdayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: wednesday,
                child: Center(
                    child: TextField(
                  controller:
                      wednesdayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        wednesdayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("thursday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("thursday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("thursday")) {
                      setState(() {
                        _selectedItems.add("thursday");
                        thursday = true;
                      });
                    } else if (_selectedItems.contains("thursday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "thursday");
                        thursday = false;
                        thursdayT1.text = '';
                        thursdayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'open',
                          letterSpacing: 1),
                      textAlign: TextAlign.center,
                      'Thursday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: thursday,
                child: Center(
                    child: TextField(
                  controller: thursdayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        thursdayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: thursday,
                child: Center(
                    child: TextField(
                  controller: thursdayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        thursdayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("friday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("friday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("friday")) {
                      setState(() {
                        _selectedItems.add("friday");
                        friday = true;
                      });
                    } else if (_selectedItems.contains("friday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "friday");
                        friday = false;
                        fridayT1.text = '';
                        fridayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontFamily: 'open',
                          fontWeight: FontWeight.w100,
                          letterSpacing: 1),
                      textAlign: TextAlign.center,
                      'Friday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: friday,
                child: Center(
                    child: TextField(
                  controller: fridayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        fridayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: friday,
                child: Center(
                    child: TextField(
                  controller: fridayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        fridayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("saturday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("saturday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("saturday")) {
                      setState(() {
                        _selectedItems.add("saturday");
                        saturday = true;
                      });
                    } else if (_selectedItems.contains("saturday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "saturday");
                        saturday = false;
                        saturdayT1.text = '';
                        saturdayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontFamily: 'open',
                          fontWeight: FontWeight.w100,
                          letterSpacing: 1),
                      textAlign: TextAlign.center,
                      'Saturday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: saturday,
                child: Center(
                    child: TextField(
                  controller: saturdayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        saturdayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: saturday,
                child: Center(
                    child: TextField(
                  controller: saturdayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "End" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        saturdayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                decoration: BoxDecoration(
                  color: (_selectedItems.contains("sunday"))
                      ? Color(0xFFA5C9CA)
                      : Color(0xffE7F6F2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: (_selectedItems.contains("sunday"))
                            ? Color(0xFFA5C9CA)
                            : Color(0xFFE7F6F2),
                        spreadRadius: 3),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    if (!_selectedItems.contains("sunday")) {
                      setState(() {
                        _selectedItems.add("sunday");
                        sunday = true;
                      });
                    } else if (_selectedItems.contains("sunday")) {
                      setState(() {
                        _selectedItems.removeWhere((val) => val == "sunday");
                        sunday = false;
                        sundayT1.text = '';
                        sundayT2.text = '';
                      });
                    }
                  },
                  title: const Text(
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                          fontSize: 50,
                          fontFamily: 'open'),
                      textAlign: TextAlign.center,
                      'Sunday'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: sunday,
                child: Center(
                    child: TextField(
                  controller: sundayT1, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        sundayT1.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              )),
          SizedBox(
            width: 10,
          ),
          LimitedBox(
              maxWidth: width * .445,
              child: Visibility(
                visible: sunday,
                child: Center(
                    child: TextField(
                  controller: sundayT2, //editing controller of this TextField
                  decoration: InputDecoration(
                      //icon of text field
                      labelText: "Start" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        sundayT2.text = pickedTime
                            .format(context); //set the value of text field.
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },
                )),
              ))
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: Container(
                width: width,
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    //?
                  ),
                  child: Icon(
                    Icons.update,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Work();

                    Requests()
                        .addOwnerPref(
                            // ignore: prefer_interpolation_to_compose_strings
                            "http://10.0.2.2:8080/users/owner/update/preferences/" +
                                jsonDecode(rawMessage)['id'],
                            preferences,
                            jsonDecode(rawMessage)['token'])
                        .then((value) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text('Day Availability'),
                            content: const Text(
                              'Days have been updated ',
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black)
                                    //?
                                    ),
                                onPressed: () {
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(fontFamily: 'opjn'),
                                ),
                              )
                            ]),
                      );
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
