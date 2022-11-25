import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Login/forgotVerify.dart';

class OwnerSettings extends StatefulWidget {
  final ScreenArguments arguments;
  const OwnerSettings(this.arguments, {super.key});

  @override
  State<OwnerSettings> createState() => _OwnerSettingsState(this.arguments);
}

class _OwnerSettingsState extends State<OwnerSettings> {
  late final ScreenArguments arguments;
  _OwnerSettingsState(this.arguments);

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
                  boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1)]),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .11),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/ownerestimates',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: const Icon(
                          size: 30, color: Colors.white, Icons.request_quote)),
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/ownerdaily',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: const Icon(
                          size: 30, color: Colors.white, Icons.calendar_today)),
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/ownerappts',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: const Icon(
                          size: 30, color: Colors.white, Icons.edit_calendar)),
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/clients',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: const Icon(
                          size: 30,
                          color: Colors.white,
                          Icons.supervised_user_circle_rounded)),
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/ownersettings',
                            arguments: json.encode({
                              "id": jsonDecode(this.arguments.message)['id'],
                              "token":
                                  jsonDecode(this.arguments.message)['token']
                            }));
                      },
                      child: const Icon(
                          size: 30, color: Colors.white, Icons.settings)),
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/');
                      },
                      child: const Icon(
                          size: 30, color: Colors.white, Icons.logout)),
                ],
              )),
        ),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: LimitedBox(
                maxWidth: MediaQuery.of(context).size.width * .83,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        textDirection: TextDirection.ltr,
                        children: [
                          Text(
                            'Preferences',
                            style: TextStyle(fontSize: 40, fontFamily: 'opjn'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .15,
                          ),
                          Icon(
                            Icons.room_preferences_sharp,
                            size: 50,
                            color: Color(0xFFE7F6F2),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        leading: Text(
                          'Availabilty',
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/ownerprefupdate',
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
                        onTap: () {
                          Navigator.of(context).pushNamed('/excluded_days',
                              arguments: json.encode({
                                "id": jsonDecode(this.arguments.message)['id'],
                                "token":
                                    jsonDecode(this.arguments.message)['token'],
                                "update": true
                              }));
                        },
                        leading: const Text(
                          'Excluded Days',
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )
                          ],
                        ))
                  ],
                ))));
  }
}
