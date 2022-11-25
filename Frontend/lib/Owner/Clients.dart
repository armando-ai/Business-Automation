import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Components/Requests.dart';
import '../Login/forgotVerify.dart';

class Clients extends StatefulWidget {
  final ScreenArguments arguments;
  const Clients(this.arguments, {super.key});

  @override
  State<Clients> createState() => _ClientsState(this.arguments);
}

class _ClientsState extends State<Clients> {
  late final ScreenArguments arguments;
  _ClientsState(this.arguments);

  @override
  void initState() {
    super.initState();
    if (allBody == null) {
      getClients();
    }
  }

  Widget? allBody;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

    return Scaffold(
        key: _key,
        appBar: AppBar(
            title: Text("All Clients"),
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
                        Navigator.of(context).popAndPushNamed('/clientsettings',
                            arguments: json.encode({
                              "id": jsonDecode(arguments.message)['id'],
                              "token": jsonDecode(arguments.message)['token'],
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
        body: allBody);
  }

  getClients() async {
    List<Widget> allclients = [
      Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: TextDirection.ltr,
          children: [
            Text(
              'Clients',
              style: TextStyle(fontSize: 40, fontFamily: 'opjn'),
            ),
            SizedBox(
              width: 150,
            ),
            Icon(
              Icons.verified_user_sharp,
              size: 50,
              color: Color(0xFFE7F6F2),
            ),
          ]),
      SizedBox(
        height: 20,
      ),
    ];
    await Requests().getClients().then((value) {
      List allValues = jsonDecode(value);
      for (var i = 0; i < allValues.length; i++) {
        var element = allValues.elementAt(i);
        if (element["state"] == "Owner Responded2") {
        } else {
          allclients.add(ListTile(
              leading: Text(
                '${element["name"]}',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/clientInfo',
                    arguments: json.encode({
                      "id": jsonDecode(this.arguments.message)['id'],
                      "token": jsonDecode(this.arguments.message)['token'],
                      "user": element
                    }));
              },
              shape: i == allValues.length - 1
                  ? null
                  : Border(
                      bottom: BorderSide(color: Color(0xFFE7F6F2), width: 1.2)),
              contentPadding: EdgeInsets.only(left: 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ],
              )));
        }
      }
    });
    print(allclients.length);
    Widget clients = Padding(
        padding: EdgeInsets.all(30),
        child: LimitedBox(maxWidth: 300, child: Column(children: allclients)));
    setState(() {
      allBody = clients;
    });
  }
}
