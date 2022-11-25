// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../Login/forgotVerify.dart';

class DrawerNotifier extends ChangeNotifier {
  double drawerWidth = 75;
  bool isHalfExpanded = false;

  void setExpansion({required bool isHalf}) {
    isHalfExpanded = !isHalfExpanded;
    if (isHalf) {
      drawerWidth = 75;
      notifyListeners();
    } else {
      drawerWidth = 0;
      notifyListeners();
    }
  }

  void change() {
    notifyListeners();
  }
}

class FlutterExpandableDrawer extends StatelessWidget {
  late var a;
  late final ScreenArguments arguments;
  var title;
  FlutterExpandableDrawer(this.a, this.title, this.arguments, {super.key});

  @override
  Widget build(BuildContext context) {
    DrawerNotifier drawerNotifier({required bool renderUI}) =>
        Provider.of<DrawerNotifier>(context, listen: renderUI);

    bool isHalfExpanded = drawerNotifier(renderUI: true).isHalfExpanded;
    double drawerWidth = drawerNotifier(renderUI: true).drawerWidth;

    Widget buildExpansionButton() {
      if (isHalfExpanded) {
        return CircleAvatar(
          backgroundColor: Colors.red,
          child: IconButton(
              onPressed: () {
                drawerNotifier(renderUI: false).setExpansion(isHalf: false);
              },
              icon: const Icon(
                size: 30,
                color: Colors.white70,
                Icons.close,
              )),
        );
      } else {
        return CircleAvatar(
          backgroundColor: Colors.green,
          child: IconButton(
              onPressed: () {
                drawerNotifier(renderUI: false).setExpansion(isHalf: true);
              },
              icon: const Icon(
                size: 30,
                color: Colors.white70,
                Icons.open_in_browser,
              )),
        );
      }
    }

    Widget shell(
        {required double width,
        required IconData iconData,
        required String title,
        required bool isHalfExpanded}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          width: width,
          height: 30,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 30,
                color: Colors.white70,
                iconData,
              ),
              if (isHalfExpanded) const SizedBox(width: 20),
              if (isHalfExpanded)
                Text(
                  title,
                ),
            ],
          ),
        ),
      );
    }

    Widget buildSecondaryButton(
        {required IconData iconData, required String title}) {
      if (isHalfExpanded) {
        return shell(
            isHalfExpanded: isHalfExpanded,
            width: 200,
            iconData: iconData,
            title: title);
      } else {
        return shell(
            isHalfExpanded: isHalfExpanded,
            width: 30,
            iconData: iconData,
            title: title);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 25),
        ),
      ),
      drawer: Drawer(
        width: drawerWidth,
        backgroundColor: Colors.transparent,
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1.5)]),
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                      Navigator.of(context).popAndPushNamed('/estimatecalendar',
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
                    child: Icon(size: 30, color: Colors.white, Icons.settings)),
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
      body: ListView(children: a),
    );
  }
}
