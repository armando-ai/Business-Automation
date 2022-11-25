import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_app/Login/forgotVerify.dart';

import 'DrawerNotifier.dart';

class OwnerMenu extends StatelessWidget {
  late var a;
  late final ScreenArguments arguments;
  var title;
  OwnerMenu(this.a, this.title, this.arguments, {super.key});

  @override
  Widget build(BuildContext context) {
    DrawerNotifier drawerNotifier({required bool renderUI}) =>
        Provider.of<DrawerNotifier>(context, listen: renderUI);

    bool isHalfExpanded = drawerNotifier(renderUI: true).isHalfExpanded;
    double drawerWidth = drawerNotifier(renderUI: true).drawerWidth;

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
                color: Colors.white,
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
          style: const TextStyle(fontSize: 25),
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                            "token": jsonDecode(this.arguments.message)['token']
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
                            "token": jsonDecode(this.arguments.message)['token']
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
      body: ListView(children: a),
    );
  }
}
