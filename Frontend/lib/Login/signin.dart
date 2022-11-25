import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/signup.dart';
import 'package:test_app/tableCalendar/utils.dart';

// ignore: must_be_immutable
class SignIn extends StatelessWidget {
  SignIn({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 732) {
      width = MediaQuery.of(context).size.width * 0.9;
    } else {
      width = 700;
    }
    print("CHecker");

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Business Automation')),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign In',
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
              maxWidth: width,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                    controller: nameController,
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
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: Icon(color: Colors.white, Icons.key),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: TextButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgot');
                },
                child: const Text(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  'Forgot Password',
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 15),
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
                  child: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    print(nameController.text);
                    print(passwordController.text);
                    Map<String, dynamic> user = {
                      "username": nameController.text,
                      "password": passwordController.text,
                    };
                    Requests()
                        .login("http://10.0.2.2:8080/auth/auth/login", user)
                        .then((value) {
                      if (value['response']['user'] == "bad user") {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: const Text('User has not been created'),
                              content: const Text(
                                'Please verify email  and password or sign up today',
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
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'),
                                ),
                              ]),
                        );
                      } else if (value['response']['user'] ==
                          "Unverified User") {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'User email has not been verified'),
                              content: const Text(
                                'Please verify email with email confirmation',
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
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'),
                                ),
                              ]),
                        );
                      } else if (value['response']['user'] == "newOwner") {
                        Navigator.of(context).popAndPushNamed(
                          '/preferences',
                          arguments: json.encode({
                            "id": value['response']['id'],
                            "token": value['token']
                          }),
                        );
                      } else if (value['response']['user'] == "newGuest") {
                        Navigator.of(context).popAndPushNamed(
                            '/estimatecalendar',
                            arguments: json.encode({
                              "id": value['response']['id'],
                              "token": value['token']
                            }));
                      } else if (value['response']['user'] == "Guest") {
                        Navigator.of(context).popAndPushNamed(
                            '/guestappointments',
                            arguments: json.encode({
                              "id": value['response']['id'],
                              "token": value['token']
                            }));
                      } else if (value['response']['user'] == "Owner") {
                        Navigator.of(context).popAndPushNamed(
                          '/ownerdaily',
                          arguments: json.encode({
                            "id": value['response']['id'],
                            "token": value['token']
                          }),
                        );
                      } else {
                        print(value);
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Don\'t have an account?'),
            TextButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent)),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/signup');
                ;
              },
            )
          ],
        ),
      ]),
    );
  }
}
