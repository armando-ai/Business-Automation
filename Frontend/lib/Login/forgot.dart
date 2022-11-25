import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.9;
      print("1");
    } else {
      width = 700;
      print("2");
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Business Automation',
              style: TextStyle(
                color: Color(0xFFE7F6F2),
                fontWeight: FontWeight.w100,
                fontFamily: 'open sans ser',
                fontSize: 27,
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
              color: Color(0xFFffffff),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child:
                    const Icon(Icons.verified_user, color: Color(0xFFffffff))),
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
                padding: const EdgeInsets.all(10),
                child: Form(
                    child: TextFormField(
                  validator: (val) => val!.isEmpty || !val.contains("@")
                      ? "Please enter a valid email"
                      : null,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(color: Colors.white, Icons.mail_lock),
                  ),
                )),
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
                    if (!nameController.text.contains('@') ||
                        !nameController.text.endsWith('.com') ||
                        nameController.text == '' ||
                        nameController.text == null) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Colors.black,
                            iconColor: Colors.black,
                            title: const Text(
                              'Invalid Email',
                            ),
                            content: const Text(
                              'Email is not valid or left blank. Please try again',
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    //?
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ))
                            ]),
                      );
                    } else {
                      Navigator.pushNamed(context, '/forgot/verify',
                          arguments: nameController.text);
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
