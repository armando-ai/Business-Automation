import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Login/forgotVerify.dart';

class ClientInfo extends StatefulWidget {
  const ClientInfo(this.arguments, {super.key});
  final ScreenArguments arguments;
  @override
  State<ClientInfo> createState() => _ClientInfoState(this.arguments);
}

class _ClientInfoState extends State<ClientInfo> {
  late final ScreenArguments arguments;

  _ClientInfoState(this.arguments);
  @override
  Widget build(BuildContext context) {
    String message = arguments.message;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            jsonDecode(message)["user"]["name"] + "'s Information",
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: LimitedBox(
              maxWidth: MediaQuery.of(context).size.width * .83,
              child: Column(children: [
                CircleAvatar(
                  minRadius: 40,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
                Center(
                  child: Text(
                    "Email: ${jsonDecode(message)["user"]["email"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Address: ${jsonDecode(message)["user"]["address"].toString().trim()}",
                      style: TextStyle(fontSize: 20),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text("Per Appointment:",
                            style: TextStyle(fontSize: 20)),
                        Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text(
                            "${jsonDecode(message)["user"]["due"].toString().trim()}",
                            style: TextStyle(fontSize: 20))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text("Past Due Balance:",
                            style: TextStyle(fontSize: 20)),
                        Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text("${jsonDecode(message)["user"]["balance"]}",
                            style: TextStyle(fontSize: 20))
                      ],
                    ))
              ])),
        ));
  }
}
