import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test_app/Login/forgotVerify.dart';

class ResetPass extends StatelessWidget {
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  final ScreenArguments arguments;

  static const String route = '/forgot/verify/reset';

  ResetPass(this.arguments, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.9;
    } else {
      width = 800;
    }
    // ignore: avoid_print

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
              color: Color(0xFF395B64),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.key, color: Color(0xFF395B64))),
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
                    'Reset Password',
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
                  child: const Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    'Updating password for ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
                padding: const EdgeInsets.all(10),
                child: TextField(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .98,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: verifyPasswordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(color: Colors.white, Icons.key),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                    //fetch api to validate email
                    if (passwordController.text == '' ||
                        verifyPasswordController.text == '' ||
                        passwordController.text !=
                            verifyPasswordController.text) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                                'Invalid Entry for one or more fields'),
                            content: const Text(
                              'Password fields do not match or left blank. Please try again',
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'))
                            ]),
                      );
                    } else if (passwordController.text ==
                        verifyPasswordController.text) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text('Hooray! Password is valid'),
                            content: const Text(
                              'Now Sign in with new password will be redirected upon Clicking OK',
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    Navigator.of(context).popAndPushNamed('/');
                                  },
                                  child: const Text('OK'))
                            ]),
                      );
                    }
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
