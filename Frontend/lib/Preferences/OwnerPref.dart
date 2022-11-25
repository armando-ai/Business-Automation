import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:test_app/Login/forgotVerify.dart';

import '../Components/Requests.dart';

class OwnerPref extends StatefulWidget {
  final ScreenArguments arguments;
  static const String route = '/preferences';
  const OwnerPref(this.arguments, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _OwnerPrefState createState() => _OwnerPrefState(this.arguments);
}

class _OwnerPrefState extends State<StatefulWidget> {
  late final ScreenArguments arguments;

  // ignore: use_key_in_widget_constructors, non_constant_identifier_names
  _OwnerPrefState(this.arguments);

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

  final List<String> _selectedItems = [];
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Business Automation',
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
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Preferences',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w300),
                  )),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'This is your first time signing in go ahead and select the days you are available',
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
        SizedBox(height:20),
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
                  child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  onPressed: () async {
                    Work();

                    Requests()
                        .addOwnerPref(
                            // ignore: prefer_interpolation_to_compose_strings
                            "http://localhost:8080/users/owner/update/preferences/" +
                                jsonDecode(rawMessage)['id'],
                            preferences,
                            jsonDecode(rawMessage)['token'])
                        .then((value) {
                      Navigator.of(context).pushNamed('/excluded_days',
                          arguments: json.encode({
                            "id": jsonDecode(rawMessage)['id'],
                            "token": jsonDecode(rawMessage)['token']
                          }));
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
