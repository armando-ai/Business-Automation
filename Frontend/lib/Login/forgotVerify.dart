import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenArguments {
  final String message;

  ScreenArguments(this.message);
}

class ForgotVerify extends StatefulWidget {
  final ScreenArguments arguments;
  static const String route = '/forgot/verify';
  const ForgotVerify(this.arguments, {super.key});
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ForgotVerifyState createState() => _ForgotVerifyState(this.arguments);
}

class _ForgotVerifyState extends State<StatefulWidget> {
  late final ScreenArguments arguments;

  // ignore: use_key_in_widget_constructors, non_constant_identifier_names
  _ForgotVerifyState(this.arguments);

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3), () {

    // });

    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.9;
    } else {
      width = 800;
    }
    // ignore: avoid_print
    var rawMessage = "testing";
    // ignore: unnecessary_null_comparison
    if (arguments.message == null) {
    } else {
      rawMessage = arguments.message;
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Business Automation',
              style: TextStyle(
                color: Color(0xFFE7F6F2),
                fontWeight: FontWeight.w100,
                fontFamily: 'open sans ser',
                fontSize: 30,
              ))),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.mail, color: Color(0xFF395B64))),
            Container(
              width: width * 0.30,
              height: 2,
              color: Color(0xFF395B64),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child:
                    const Icon(Icons.verified_user, color: Color(0xFF395B64))),
            Container(
              width: width * 0.30,
              height: 2,
              color: Color(0xFFffffff),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.key, color: Color(0xFFffffff))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .98,
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Forgot Password',
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
              maxWidth: width * .98,
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    'Awaiting Verification from $rawMessage click verified upon email verification.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  )),
            ),
          ],
        ),
        SizedBox(height: 100),
        Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            size: 100,
            color: Color(0xFF395B64),
          ),
        ),
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: Container(
                width: width * .98,
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    //?
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot/verify/reset',
                        arguments: arguments.message);
                  },
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
