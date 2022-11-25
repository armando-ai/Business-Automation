import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Components/DrawerNotifier.dart';
import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/forgotVerify.dart';

class guestAppointment extends StatefulWidget {
  final ScreenArguments arguments;
  const guestAppointment(this.arguments, {super.key});

  @override
  State<guestAppointment> createState() =>
      _guestAppointmentState(this.arguments);
}

class _guestAppointmentState extends State<guestAppointment> {
  late final ScreenArguments arguments;
  List<Widget> upcomingDates = [];

  _guestAppointmentState(this.arguments);
  Future<void> work() async {
    await getClientAppts(
            jsonDecode(arguments.message)['id'], context, this.arguments)
        .then((value) {
      setState(() {
        upcomingDates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingDates.isEmpty) {
      getClientAppts(
              jsonDecode(arguments.message)['id'], context, this.arguments)
          .then((value) {
        setState(() {
          upcomingDates = value;
        });
      });
    }
    return ChangeNotifierProvider(
        create: ((context) => DrawerNotifier()),
        child: Scaffold(
          body: RefreshIndicator(
              onRefresh: work,
              child: FlutterExpandableDrawer(
                  upcomingDates, "Upcoming Appointments", this.arguments)),
        ));
  }

  Future<List<Widget>> getClientAppts(
      id, context, ScreenArguments arguments) async {
    // jsonDecode(arguments.message)['id'];
    // jsonDecode(arguments.message)['token'];
    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.9;
    } else {
      width = 700;
    }
    List<Widget> boxAppt = [
      SizedBox(height: 30),
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cancel - '),
            const Icon(
              Icons.cancel,
              color: Colors.white,
              size: 30,
            ),
            Text(' Reschedule - '),
            Icon(
              Icons.change_circle,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      )
    ];
    await Requests()
        .getClientAppts(
            'http://10.0.2.2:8080/calendar/calendar/getClientAppts/${id}')
        .then((value) {
      List appts = json.decode(value);

      for (var i = appts.length - 1; i >= 0; i--) {
        var element = appts[i];
        print("value:${element['id']}");
        var selectedDate = DateTime.parse(element['date']);
        var day = '';
        var month = '';
        if (selectedDate.day < 10) {
          day = '0${selectedDate.day}';
        } else {
          day = '${selectedDate.day}';
        }
        if (selectedDate.month < 10) {
          month = '0${selectedDate.month}';
        } else {
          month = '${selectedDate.month}';
        }
        if (element['time'].toString().length == 7) {
          element['time'] = '0' + element['time'];
        }
        if (element['type'] == 'client_estimate') {
          element['type'] = 'Estimate';
        } else {
          element['type'] = 'Appointment';
        }

        boxAppt.addAll([
          SizedBox(height: 40),
          Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LimitedBox(
                        maxWidth: width * .915,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xffE7F6F2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFFE7F6F2), spreadRadius: 3),
                            ],
                          ),
                          child: Text(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 30,
                                  fontFamily: 'open'),
                              textAlign: TextAlign.center,
                              '${element['type']} \n${element['time']} ${month}/${day}/${selectedDate.year}'),
                        ))
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                LimitedBox(
                    maxWidth: width * 1.5,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: width * .142, right: width * .142),
                      decoration: BoxDecoration(
                          color: Color(0xFF395B64),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF395B64), spreadRadius: 3),
                          ]),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFF395B64))),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Appointment will be canceled '),
                                  content: const Text(
                                    'Are you sure you want to cancel',
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
                                        Navigator.pop(context, 'Cancel');
                                      },
                                      child: const Text('Cancel'),
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
                                        Requests()
                                            .cancelAppointment(
                                                "http://10.0.2.2:8080/calendar/calendar/appointment/${element['id']}/ ")
                                            .then((value) {
                                          Navigator.of(context).popAndPushNamed(
                                              '/guestappointments',
                                              arguments: json.encode({
                                                "id": jsonDecode(
                                                    arguments.message)['id'],
                                                "token": jsonDecode(
                                                    arguments.message)['token']
                                              }));
                                        });
                                      },
                                      child: const Text('Yes'),
                                    )
                                  ]),
                            );
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 30,
                          )),
                    )),
                LimitedBox(
                    maxWidth: width * 1.5,
                    child: Container(
                        padding: EdgeInsets.only(
                            left: width * .142, right: width * .142),
                        decoration: BoxDecoration(
                            color: Color(0xFF395B64),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF395B64), spreadRadius: 3),
                            ]),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xFF395B64))),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                        'Appointment will be canceled '),
                                    content: const Text(
                                      'You will be redirected to the appointment screen',
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
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: const Text('Cancel'),
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
                                          Requests()
                                              .cancelAppointment(
                                                  "http://10.0.2.2:8080/calendar/calendar/appointment/${element['id']}/ ")
                                              .then((value) {
                                            Navigator.of(context)
                                                .popAndPushNamed(
                                                    '/estimatecalendar',
                                                    arguments: json.encode({
                                                      "id": jsonDecode(arguments
                                                          .message)['id'],
                                                      "token": jsonDecode(
                                                              arguments
                                                                  .message)[
                                                          'token'],
                                                      "reschedule": true
                                                    }));
                                          });
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]),
                              );
                            },
                            child: Icon(
                              Icons.change_circle,
                              color: Colors.white,
                              size: 30,
                            ))))
              ])
            ],
          )
        ]);
      }
    });
    boxAppt.add(SizedBox(height: 40));

    if (boxAppt.isEmpty) {
      return [
        Container(
            margin: EdgeInsets.all(20),
            child: Text('Nothing to see become a client'))
      ];
    } else {
      return boxAppt;
    }
  }
}
