import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Components/DrawerNotifier.dart';
import 'package:test_app/Components/OwnerMenu.dart';
import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/forgotVerify.dart';

class PendingEstimates extends StatefulWidget {
  final ScreenArguments arguments;
  const PendingEstimates(this.arguments, {super.key});

  @override
  State<PendingEstimates> createState() =>
      _PendingEstimatesState(this.arguments);
}

class _PendingEstimatesState extends State<PendingEstimates> {
  late final ScreenArguments arguments;
  List<Widget> upcomingDates = [];
  var pending = true;
  var declined = false;
  var completed = false;
  _PendingEstimatesState(this.arguments);

  Future<void> work() async {
    getPendingEstimates(jsonDecode(arguments.message)['id'], context,
            arguments.message.toString())
        .then((value) {
      setState(() {
        upcomingDates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingDates.isEmpty) {
      getPendingEstimates(jsonDecode(arguments.message)['id'], context,
              arguments.message.toString())
          .then((value) {
        setState(() {
          upcomingDates = value;
        });
      });
    }
    return ChangeNotifierProvider(
        create: ((context) => DrawerNotifier()),
        child: Scaffold(
          body: RefreshIndicator(
              onRefresh: work,
              child: OwnerMenu(upcomingDates, "Quotes", this.arguments)),
        ));
  }

  Future<List<Widget>> getPendingEstimates(
      jsonDecode, BuildContext context, String arguments) async {
    TextEditingController counterOfferText = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.82;
    } else {
      width = 700;
    }

    //get users with guest role then display name and option based off return
    List<Widget> boxAppt = [];
    await Requests()
        .getPendingEstimates(
            'http://10.0.2.2:8080/calendar/calendar/ownerEstimates/')
        .then((value) {
      if (value != '[]') {
        List pendingEstimates = json.decode(value);

        for (var i = 0; i < pendingEstimates.length; i++) {
          var element = pendingEstimates[i];

          if (element['state'] == "Completed" ||
              element['state'] == "Client Declined" ||
              element['state'] == "Owner Declined") {
            print(element['state']);
          } else {
            boxAppt.addAll([
              SizedBox(height: 30),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LimitedBox(
                        maxWidth: width,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xffE7F6F2),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFFE7F6F2), spreadRadius: 3),
                              ],
                            ),
                            child: Text(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 28,
                                    fontFamily: 'open'),
                                textAlign: TextAlign.center,
                                '${element['name']} \n Location: ${element['location']} '))),
                  ]),
            ]);
          }
          if (element['state'] == 'needs quote') {
            boxAppt.add(
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            TextEditingController monthlyController =
                                TextEditingController();
                            TextEditingController biWeeklyController =
                                TextEditingController();
                            TextEditingController triWeeklyController =
                                TextEditingController();
                            TextEditingController initialController =
                                TextEditingController();
                            TextEditingController weeklyController =
                                TextEditingController();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                      child: SingleChildScrollView(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                        AlertDialog(
                                          content: Stack(
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text('Quote'),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                          controller:
                                                              weeklyController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            labelText: 'Weekly',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          2.5),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.5),
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                          controller:
                                                              biWeeklyController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            labelText:
                                                                'BiWeekly',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          2.5),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.5),
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                          controller:
                                                              triWeeklyController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            labelText:
                                                                'TriWeekly',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          2.5),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.5),
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                          controller:
                                                              monthlyController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            labelText:
                                                                'Monthly',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          2.5),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.5),
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                          controller:
                                                              initialController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .monetization_on,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            labelText:
                                                                'Initial Cost',
                                                            labelStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              letterSpacing: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .blue,
                                                                      width:
                                                                          2.5),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.5),
                                                            ),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ElevatedButton(
                                                        child: Text("Submit"),
                                                        onPressed: () {
                                                          Map<String, dynamic>
                                                              quote = {
                                                            "weekly":
                                                                weeklyController
                                                                    .text,
                                                            "biweekly":
                                                                biWeeklyController
                                                                    .text,
                                                            "triweekly":
                                                                triWeeklyController
                                                                    .text,
                                                            "monthly":
                                                                monthlyController
                                                                    .text,
                                                            "initial":
                                                                initialController
                                                                    .text,
                                                            "state":
                                                                "Owner Responded",
                                                            "clientId": element[
                                                                    'clientId']
                                                                .toString()
                                                          };

                                                          Requests()
                                                              .makeClientQuote(
                                                                  "http://10.0.2.2:8080/calendar/calendar/makequote",
                                                                  quote,
                                                                  json
                                                                      .decode(arguments)[
                                                                          'token']
                                                                      .toString())
                                                              .then((value) => Navigator
                                                                      .of(
                                                                          context)
                                                                  .popAndPushNamed(
                                                                      '/ownerestimates',
                                                                      arguments:
                                                                          json.encode({
                                                                        "id": json
                                                                            .decode(arguments)['id'],
                                                                        "token":
                                                                            json.decode(arguments)['token']
                                                                      })));
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ])));
                                });
                          },
                          child: Text(
                            'Needs Quote',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'opjn'),
                          )))),
            ]));
          } else if (element['state'] == "Owner Responded" ||
              element['state'] == "Owner Counter Offered" ||
              element['state'] == "Owner Accepted Offered") {
            var state = "Awaiting Client Response";

            boxAppt.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LimitedBox(
                      maxWidth: width * 1.015,
                      child: Container(
                          width: width * 1.015,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xffE7F6F2),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(20)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              onPressed: () {},
                              child: Text(
                                '${state}',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'opjn'),
                              )))),
                ]));
          } else if (element['state'] == 'Client Counter Offered') {
            boxAppt.addAll([
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LimitedBox(
                        maxWidth: width * 1.015,
                        child: Container(
                            width: width * 1.015,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xffE7F6F2),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(20)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String? selectedValue;
                                        bool color = false;
                                        bool show = false;
                                        if (element['quote']['offerClient'] !=
                                            null) {
                                          show = true;
                                        }
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return Center(
                                              child: SingleChildScrollView(
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                AlertDialog(
                                                    content: Center(
                                                        child: Text(
                                                            'Original Quote')),
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    title: Center(
                                                        child: Text(
                                                            'Here are the options and prices provided\n1. If chosen to accept select accept\n2.Input your counter offer \n3. Decline ')),
                                                    actionsPadding:
                                                        EdgeInsets.all(20),
                                                    actions: [
                                                      Column(
                                                        children: [
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.5,
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                verticalDirection:
                                                                    VerticalDirection
                                                                        .up,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                      'Weekly:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['weekly']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.5,
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                verticalDirection:
                                                                    VerticalDirection
                                                                        .up,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                      'BiWeekly:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['biweekly']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.5,
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                verticalDirection:
                                                                    VerticalDirection
                                                                        .up,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                      'TriWeekly:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['triweekly']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.5,
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      'Monthly:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['monthly']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.82,
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      'Initial/Once:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['initial']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Center(
                                                            child: Text(
                                                                "Client Offer",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * 0.82,
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      '${element['quote']['offerType']}:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30)),
                                                                  Icon(
                                                                      Icons
                                                                          .attach_money,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .white),
                                                                  Text(
                                                                      '${element['quote']['offerClient']}',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30))
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                            maxWidth:
                                                                width * .82,
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          width *
                                                                              .82,
                                                                      child: TextField(
                                                                          controller: counterOfferText,
                                                                          style: TextStyle(color: Colors.white),
                                                                          decoration: InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(
                                                                              Icons.monetization_on,
                                                                              color: Colors.white,
                                                                            ),
                                                                            contentPadding:
                                                                                EdgeInsets.all(10),
                                                                            labelText:
                                                                                'Counter Offer',
                                                                            labelStyle:
                                                                                TextStyle(color: Colors.white),
                                                                            floatingLabelStyle:
                                                                                TextStyle(
                                                                              fontSize: 20,
                                                                              letterSpacing: 2,
                                                                              color: Colors.white,
                                                                            ),
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.blue, width: 2.5),
                                                                            ),
                                                                            enabledBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.white, width: 2.5),
                                                                            ),
                                                                          ))),
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                          ),
                                                          LimitedBox(
                                                              maxWidth:
                                                                  width * 0.5,
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var updateQuote =
                                                                              {
                                                                            "state":
                                                                                "Owner Declined"
                                                                          };
                                                                          await Requests()
                                                                              .sendClientOffer('http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}', updateQuote)
                                                                              .then((value) {
                                                                            if (value ==
                                                                                'Success') {
                                                                              Navigator.of(context).popAndPushNamed('/quotes',
                                                                                  arguments: json.encode({
                                                                                    "id": jsonDecode(this.arguments.message)['id'],
                                                                                    "token": jsonDecode(this.arguments.message)['token']
                                                                                  }));
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Decline',
                                                                          style:
                                                                              TextStyle(fontFamily: 'opjn'),
                                                                        )),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var updateQuote =
                                                                              {
                                                                            "state":
                                                                                "Owner Accepted Offered"
                                                                          };
                                                                          await Requests()
                                                                              .sendOwnerAcceptOffer('http://10.0.2.2:8080/calendar/calendar/owneracceptoffer/${element['quote']['id']}', updateQuote)
                                                                              .then((value) {
                                                                            if (value ==
                                                                                'Success') {
                                                                              Navigator.of(context).popAndPushNamed('/ownerestimates',
                                                                                  arguments: json.encode({
                                                                                    "id": json.decode(arguments)['id'],
                                                                                    "token": json.decode(arguments)['token']
                                                                                  }));
                                                                            }
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            'Accept',
                                                                            style:
                                                                                TextStyle(fontFamily: 'opjn'))),
                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var updateQuote =
                                                                              {
                                                                            "offerOwner":
                                                                                counterOfferText.text,
                                                                            "state":
                                                                                "Owner Counter Offered"
                                                                          };
                                                                          await Requests()
                                                                              .sendClientOffer('http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}', updateQuote)
                                                                              .then((value) {
                                                                            if (value ==
                                                                                'Success') {
                                                                              Navigator.of(context).popAndPushNamed('/ownerestimates',
                                                                                  arguments: json.encode({
                                                                                    "id": json.decode(arguments)['id'],
                                                                                    "token": json.decode(arguments)['token']
                                                                                  }));
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Offer',
                                                                          style:
                                                                              TextStyle(fontFamily: 'opjn'),
                                                                        )),
                                                                  ]))
                                                        ],
                                                      ),
                                                    ])
                                              ])));
                                        });
                                      });
                                },
                                child: Text(
                                  'Counter Offer Reccieved',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'opjn'),
                                )))),
                  ])
            ]);
          }
        }
      }
    });
    if (boxAppt.isEmpty) {
      return [
        Container(
            margin: EdgeInsets.all(20), child: Text('No Pending Estimates'))
      ];
    }
    boxAppt.add(SizedBox(height: 30));
    return boxAppt;
  }
}
