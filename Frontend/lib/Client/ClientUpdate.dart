import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:test_app/Components/Requests.dart';

import '../Login/forgotVerify.dart';

class ClientUpdate extends StatefulWidget {
  final ScreenArguments arguments;

  const ClientUpdate(this.arguments);
  @override
  _ClientUpdateState createState() => _ClientUpdateState(this.arguments);
}

class _ClientUpdateState extends State<ClientUpdate> {
  final ScreenArguments arguments;
  bool value = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suiteController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  _ClientUpdateState(this.arguments);
  void getData() {
    Requests()
        .getClientInfo(
            "http://10.0.2.2:8080/calendar/calendar/client/${json.decode(arguments.message)["id"]}")
        .then((value) {
      var user = jsonDecode(value);
      setState(() {
        emailController.text = user["email"];
        cityController.text = user["address"]["city"];
        stateController.text = user["address"]["state"];
        streetController.text = user["address"]["street"];
        if (user["address"]["suite"] != null) {
          suiteController.text = user["address"]["suite"];
        }
        zipController.text = user["address"]["zip"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 730) {
      width = MediaQuery.of(context).size.width * 0.82;
    } else {
      width = 700;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Update Your Info',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 30,
              )),
          backgroundColor: const Color(0xFF395B64),
        ),
        body: Container(
            color: const Color(0xFFff2c3333),
            child: ListView(padding: const EdgeInsets.all(16.0), children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Account Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w100,
                          ),
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(color: Colors.white, Icons.mail),
                          )),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.key),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: streetController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Street Address',
                          prefixIcon: Icon(Icons.location_history),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: suiteController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Apt/Suite Number',
                          prefixIcon: Icon(Icons.location_history),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: cityController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                    maxWidth: width * 0.5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: stateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'State',
                          prefixIcon: Icon(Icons.map_sharp),
                        ),
                      ),
                    ),
                  ),
                  LimitedBox(
                    maxWidth: width * 0.5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: zipController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Zip Code',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)
                              //?
                              ),
                          child: const Icon(
                            Icons.upload_outlined,
                            color: Colors.white,
                          ),
                          //implement verification of data type
                          onPressed: () async {
                            if (!emailController.text.contains('@') ||
                                emailController.text == '' ||
                                emailController.text == null) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Invalid Email'),
                                    content: const Text(
                                      'Email is not valid or left blank. Please try again',
                                      style: TextStyle(),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            //?
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK'))
                                    ]),
                              );
                              //need validation for street
                            } else if (value == false) {
                              Map<String, dynamic> newUser = {
                                'user': {
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "address": {
                                    "suite": suiteController.text,
                                    "street": streetController.text,
                                    "city": cityController.text,
                                    "state": stateController.text,
                                    "zip": zipController.text,
                                  }
                                }
                              };
                              print(json.decode(arguments.message)["token"]);
                              Requests()
                                  .updateUser(
                                      "http://10.0.2.2:8080/users/user/${json.decode(arguments.message)["id"]}",
                                      newUser,
                                      json.decode(arguments.message)["token"])
                                  .then((value) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title: Text('Thank You, $value'),
                                          content: const Text(
                                            'Your information has been updated',
                                          ),
                                          actions: <Widget>[
                                        ElevatedButton(
                                            style: ButtonStyle(

                                                //?
                                                ),
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');

                                              //will hit different endpoint if business owner
                                            },
                                            child: const Text('OK'))
                                      ]),
                                );
                              });
                            }
                          }),
                    ),
                  )
                ],
              ),
            ])));
  }
}
