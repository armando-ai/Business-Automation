import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_app/Components/Requests.dart';

import '../Login/forgotVerify.dart';

class ClientSettings extends StatefulWidget {
  final ScreenArguments arguments;
  const ClientSettings(this.arguments, {super.key});

  @override
  State<ClientSettings> createState() => _ClientSettingsState(this.arguments);
}

class _ClientSettingsState extends State<ClientSettings> {
  late final ScreenArguments arguments;
  _ClientSettingsState(this.arguments);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

    return Scaffold(
        key: _key,
        appBar: AppBar(
            title: Text("Settings"),
            leading: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF395B64))),
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
                child: const Icon(size: 30, color: Colors.white, Icons.menu))),
        drawer: Drawer(
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
                  SizedBox(height: MediaQuery.of(context).size.height * .15),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/quotes',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: Icon(
                          size: 30, color: Colors.white, Icons.request_quote)),
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(
                            '/guestappointments',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: Icon(
                          size: 30, color: Colors.white, Icons.edit_calendar)),
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
                              "token": jsonDecode(arguments.message)['token'],
                              "reschedule": true
                            }));
                      },
                      child: Icon(
                          size: 30, color: Colors.white, Icons.calendar_month)),
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/clientsettings',
                            arguments: json.encode({
                              "id": jsonDecode(arguments.message)['id'],
                              "token": jsonDecode(arguments.message)['token'],
                            }));
                      },
                      child:
                          Icon(size: 30, color: Colors.white, Icons.settings)),
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/');
                      },
                      child: Icon(size: 30, color: Colors.white, Icons.logout)),
                ],
              )),
        ),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: LimitedBox(
                maxWidth: MediaQuery.of(context).size.width * .83,
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        'Account',
                        style: TextStyle(fontSize: 40, fontFamily: 'opjn'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .30,
                      ),
                      Icon(
                        Icons.person_search,
                        size: 50,
                        color: Color(0xFFE7F6F2),
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        leading: Text(
                          'My Information',
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/clientupdate',
                              arguments: json.encode({
                                "id": jsonDecode(this.arguments.message)['id'],
                                "token":
                                    jsonDecode(this.arguments.message)['token']
                              }));
                        },
                        shape: Border(
                            bottom: BorderSide(
                                color: Color(0xFFE7F6F2), width: 1.2)),
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )
                          ],
                        )),
                    ListTile(
                        leading: Text(
                          'Terminate Service',
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text('Termination of service'),
                                content: const Text(
                                  'Are you sure you want to cancel this will cancel all appointments scheduled',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                      style: ButtonStyle(

                                          //?
                                          ),
                                      onPressed: () {
                                        Requests()
                                            .terminateService(
                                                "http://10.0.2.2:8080/calendar/calendar/delclient/${json.decode(arguments.message)["id"]}")
                                            .then((value) {});
                                        Navigator.pop(context, 'OK');

                                        //will hit different endpoint if business owner
                                      },
                                      child: const Text('OK'))
                                ]),
                          );
                        },
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ],
                ))));
  }
}
