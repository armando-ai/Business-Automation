import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Components/DrawerNotifier.dart';
import 'package:test_app/Components/OwnerMenu.dart';
import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/forgotVerify.dart';

class Daily extends StatefulWidget {
  final ScreenArguments arguments;
  const Daily(this.arguments, {super.key});

  @override
  State<Daily> createState() => _DailyState(this.arguments);
}

class _DailyState extends State<Daily> {
  late final ScreenArguments arguments;
  List<Widget> upcomingDates = [];

  _DailyState(this.arguments);
  Future<void> work() async {
    getOwnerSchedule(jsonDecode(arguments.message)['id'], context)
        .then((value) {
      setState(() {
        upcomingDates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingDates.isEmpty) {
      getOwnerSchedule(jsonDecode(arguments.message)['id'], context)
          .then((value) {
        setState(() {
          upcomingDates = value;
        });
      });
    }
    print(new DateTime.now().hour);
    return ChangeNotifierProvider(
        create: ((context) => DrawerNotifier()),
        child: Scaffold(
          body: RefreshIndicator(
              onRefresh: work,
              child:
                  OwnerMenu(upcomingDates, "Daily Schedule", this.arguments)),
        ));
  }
}

Future<List<Widget>> getOwnerSchedule(id, context) async {
  // jsonDecode(arguments.message)['id'];
  // jsonDecode(arguments.message)['token'];
  var selectedDate = DateTime.now();
  double width = MediaQuery.of(context).size.width;
  if (width < 500) {
    width = MediaQuery.of(context).size.width * 0.82;
  } else {
    width = 700;
  }
  print("hello");
  List<Widget> boxAppt = [
    SizedBox(
      height: 20,
    ),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      LimitedBox(
          maxWidth: width,
          child: Text(
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 40,
                  fontFamily: 'open'),
              textAlign: TextAlign.center,
              '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))
    ])
  ];
  await Requests()
      .getOwnerAppts('http://10.0.2.2:8080/calendar/calendar/ownerschedule/')
      .then((value) {
    if (value != '[]') {
      List appts = json.decode(value);

      for (var i = 0; i < appts.length; i++) {
        var element = appts[i];

        if (element['type'] == 'client_estimate') {
          element['type'] = 'Estimate';
        } else {
          element['type'] = 'Appointment';
        }
        boxAppt.addAll([
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            LimitedBox(
                maxWidth: width,
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xffE7F6F2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                      ],
                    ),
                    child: Text(
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontSize: 28,
                            fontFamily: 'open'),
                        textAlign: TextAlign.center,
                        '${element['type']} \n${element['name']} ${element['time']}\n Location: ${element['address']} ')))
          ])
        ]);
      }
    }
  });
  if (boxAppt.length == 2) {
    boxAppt.addAll([
      SizedBox(height: MediaQuery.of(context).size.height * .5),
      Center(child: Text('No Appointments today'))
    ]);
    return boxAppt;
  }
  return boxAppt;
}
