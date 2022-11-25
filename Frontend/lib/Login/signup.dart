import 'package:flutter/material.dart';

import 'package:test_app/Components/Requests.dart';

class SignUp extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SignUp> {
  bool value = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController suiteController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  void postData() async {}

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
          automaticallyImplyLeading: false,
          title: const Text('Business Automation',
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
                          'Sign Up',
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
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          prefixIcon:
                              Icon(color: Colors.white, Icons.account_circle),
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
                  const Text(
                    'Business Owner',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  LimitedBox(
                    maxWidth: width,
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Colors.black),
                      value: value,
                      onChanged: (bool? value1) {
                        setState(() {
                          value = value1!;
                        });
                      },
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
                            Icons.done_all,
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
                            } else if (value == false)
                            // ignore: avoid_print
                            {
                              Map<String, dynamic> newUser = {
                                'user': {
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "address": {
                                    "suite": suiteController.text,
                                    "street": streetController.text,
                                    "city": cityController.text,
                                    "state": stateController.text,
                                    "zip": zipController.text,
                                  },
                                  "role": "guest"
                                }
                              };
                              Requests()
                                  .createUser(
                                      "http://10.0.2.2:8080/users/user/register",
                                      newUser)
                                  .then((value) {
                                if (value.toString() == "null") {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text(
                                                'User Already Exists'),
                                            content: const Text(
                                              'Email is already being used log in or try another email',
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
                                              Navigator.pop(context, 'Login');
                                              Navigator.of(context)
                                                  .popAndPushNamed('/');
                                            },
                                            child: const Text('Login'),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Try Again');

                                                //will hit different endpoint if business owner
                                              },
                                              child: const Text('Try Again'))
                                        ]),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text('Thank You, $value'),
                                            content: const Text(
                                              'Please Verify Email then proceed to login',
                                            ),
                                            actions: <Widget>[
                                          ElevatedButton(
                                              style: ButtonStyle(

                                                  //?
                                                  ),
                                              onPressed: () {
                                                Navigator.pop(context, 'Login');
                                                Navigator.of(context)
                                                    .popAndPushNamed('/');
                                                //will hit different endpoint if business owner
                                              },
                                              child: const Text('Login'))
                                        ]),
                                  );
                                }
                              });
                            } else {
                              Map<String, dynamic> newUser = {
                                'user': {
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "password": passwordController.text,
                                  "address": {
                                    "suite": suiteController.text,
                                    "street": streetController.text,
                                    "city": cityController.text,
                                    "state": stateController.text,
                                    "zip": zipController.text,
                                  },
                                  "role": "owner"
                                }
                              };
                              Requests()
                                  .createUser(
                                      "http://10.0.2.2:8080/users/owner/register",
                                      newUser)
                                  .then((value) {
                                if (value.toString() == "null") {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text(
                                                'User Already Exists'),
                                            content: const Text(
                                              'Email is already being used log in or try another email',
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
                                            onPressed: () => {
                                              Navigator.pop(context, 'Login'),
                                              Navigator.of(context)
                                                  .popAndPushNamed('/')
                                            },
                                            child: const Text('Login'),
                                          ),
                                          ElevatedButton(
                                              style: ButtonStyle(

                                                  //?
                                                  ),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Try Again');

                                                //will hit different endpoint if business owner
                                              },
                                              child: const Text('Try Again'))
                                        ]),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text('Thank You, $value'),
                                            content: const Text(
                                              'Please Verify Email then proceed to login',
                                            ),
                                            actions: <Widget>[
                                          ElevatedButton(
                                              style: ButtonStyle(

                                                  //?
                                                  ),
                                              onPressed: () {
                                                Navigator.pop(context, 'Login');
                                                Navigator.of(context)
                                                    .popAndPushNamed('/');
                                                //will hit different endpoint if business owner
                                              },
                                              child: const Text('Login'))
                                        ]),
                                  );
                                }
                              });

                              //will hit different endpoint if business owner

                            }
                          }),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have an account?'),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent)),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/');
                      ;
                    },
                  )
                ],
              ),
            ])));
  }
}
