import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/forgotVerify.dart';

// ignore: use_key_in_widget_constructors
class Estimates extends StatefulWidget {
  const Estimates(this.arguments);
  final ScreenArguments arguments;
  createState() => MyWidgetState(this.arguments);
}

class MyWidgetState extends State<Estimates> {
  late DateTime selectedDate;
  late ScrollController _controller;
  late final ScreenArguments arguments;
  var isUpdate = false;
  MyWidgetState(this.arguments);
  @override
  initState() {
    super.initState();
    if (jsonDecode(this.arguments.message)['update'] != null) {
      setState(() {
        isUpdate = true;
      });
      getExcluded();
    }
    selectedDate = DateTime.now();
    _controller = new ScrollController();
  }

  int check = 0;
  List<Container> containerList = [];
  List<String> mapping = [];
  Container createNewContainer(x, String rawIndex) {
    return Container(
      margin: EdgeInsets.only(right: 25, left: 8),
      decoration: BoxDecoration(
          color: Color(0xFF0000000),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Color(0xFF0000), spreadRadius: 3)
          ]),
      height: 100,
      width: 100,
      child: Column(children: [
        SizedBox(height: 15),
        Text(
          '${x}',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              foregroundColor: MaterialStatePropertyAll(Colors.black)),
          onPressed: () {
            setState(() {
              // print(
              //     "index at ${mapping.firstWhere((element) => element == rawIndex)}");
              // print(
              //     "item${containerList.elementAt(mapping.firstWhere((element) => element == rawIndex))}");
              if (containerList.length == 1) {
                containerList = [];
                mapping = [];
              } else {
                containerList.removeAt(mapping
                    .indexWhere((note) => note.compareTo(rawIndex) == 0));

                mapping.removeAt(mapping
                    .indexWhere((note) => note.compareTo(rawIndex) == 0));
              }
              // mapping.removeAt(
              //     mapping.firstWhere((element) => element == rawIndex++));
            });
          },
          child: Text('X'),
        ),
      ]),
    );
  }

  // Add
  void addContainer(x) {
    containerList.add(createNewContainer(x, x));
    mapping.add(x);

    // print(mapping);
  }

  // Pop
  void popContainer() {
    if (containerList.length != 0) {
      containerList.removeLast();
    }
  }

  // _childrenList
  List<Widget> _childrenList() {
    return containerList;
  }

  Widget build(BuildContext context) {
    var theMargin;
    var rawMessage = "testing";
    // ignore: unnecessary_null_comparison
    if (arguments.message == null) {
    } else {
      rawMessage = arguments.message;
    }
    // ignore: unrelated_type_equality_checks

    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      width = MediaQuery.of(context).size.width * 0.8;
      theMargin = EdgeInsets.only(left: 20, right: 23);
      // print("1");
    } else {
      width = MediaQuery.of(context).size.width * 0.45;
      theMargin = EdgeInsets.only(left: width * 0.587, right: width * 0.587);
    }
    print(rawMessage);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isUpdate,
        centerTitle: true,
        title: const Text(
          'Excluded Days',
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16.0), children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width * .93,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Select The days you would like to exclude from automation and scheduling ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
                maxWidth: width,
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Color(0xFF0000000),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF0000), spreadRadius: 3)
                        ]),
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200,
                            fontSize: 30,
                          )),
                    )))
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: Container(
                height: 355,
                decoration: BoxDecoration(
                    color: Color(0xFFf5fafa),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFf5fafa), spreadRadius: 3)
                    ]),
                child: CalendarDatePicker(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2024, 12, 12),
                  initialDate: selectedDate,
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            decoration: BoxDecoration(
                color: (containerList.isNotEmpty)
                    ? Color(0xFF395B64)
                    : Color(0xFFff2c3333),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF0000), spreadRadius: 3)
                ]),
            padding: EdgeInsets.only(top: 5, bottom: 5),
            margin: theMargin,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _childrenList(),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                onHover: (value) {},
                onPressed: () {
                  _controller.animateTo(_controller.offset - 133,
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 1000));
                }),
            SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  addContainer(
                      '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}');
                });
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                onHover: (value) {
                  ;
                },
                onPressed: () {
                  _controller.animateTo(_controller.offset + 133,
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 1000));
                })
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: width,
              child: Container(
                width: width,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    //?
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () async {
                    print(jsonDecode(rawMessage));
                    Requests()
                        .addOwnerExcluded(
                            "http://10.0.2.2:8080/users/owner/update/preferences/excluded/" +
                                jsonDecode(rawMessage)['id'],
                            mapping,
                            jsonDecode(rawMessage)['token'])
                        .then((value) {
                      Navigator.of(context).popAndPushNamed('/ownerdaily',
                          arguments: json.encode({
                            "id": jsonDecode(rawMessage)['id'],
                            "token": jsonDecode(rawMessage)['token']
                          }));
                    });
                  },
                ),
              ),
            )
          ],
        )
      ]),
    );
  }

  void getExcluded() {
    Requests().getExcluded().then((value) {
      List dates = json.decode(value);

      for (var i = 0; i < dates.length; i++) {
        var date = DateTime.parse(dates.elementAt(i));
        print(date);
        setState(() {
          addContainer('${date.month}/${date.day}/${date.year}');
        });
      }
    });
  }
}
