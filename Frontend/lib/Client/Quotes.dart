import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Components/DrawerNotifier.dart';
import 'package:test_app/Components/Requests.dart';
import 'package:test_app/Login/forgotVerify.dart';

class Quotes extends StatefulWidget {
  final ScreenArguments arguments;
  const Quotes(this.arguments, {super.key});

  @override
  State<Quotes> createState() => _QuotesState(this.arguments);

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }
}

class _QuotesState extends State<Quotes> {
  late final ScreenArguments arguments;
  List<Widget> upcomingDates = [];
  Quotes drawerNotifier({required bool renderUI}) =>
      Provider.of<Quotes>(context, listen: renderUI);
  _QuotesState(this.arguments);
  Future<void> work() async {
    await getClientQuotes(jsonDecode(arguments.message)['id'], context,
            this.arguments.toString())
        .then((value) {
      setState(() {
        upcomingDates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (upcomingDates.isEmpty) {
      getClientQuotes(jsonDecode(arguments.message)['id'], context,
              this.arguments.toString())
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
              child: FlutterExpandableDrawer(
                  upcomingDates, "Quotes", this.arguments)),
        ));
  }

  Future<List<Widget>> getClientQuotes(id, context, arguments) async {
    // jsonDecode(arguments.message)['id'];
    // jsonDecode(arguments.message)['token'];
    TextEditingController counterOfferText = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    double width = MediaQuery.of(context).size.width;
    if (width < 500) {
      width = MediaQuery.of(context).size.width * 0.82;
    } else {
      width = 700;
    }

    final List<String> items = [
      'Weekly',
      'BiWeekly',
      'TriWeekly',
      'Monthly',
      'Initial/Once',
    ];

    List<Widget> boxAppt = [];
    await Requests()
        .getClientQuotes(
            'http://10.0.2.2:8080/calendar/calendar/getclientquote/${id}')
        .then((value) {
      List appts = json.decode(value);

      for (var i = 0; i < appts.length; i++) {
        var element = appts[i];
        print("value:${DateTime.parse(element['date'])}");
        var selectedDate = DateTime.parse(element['date']);
        if (element['state'] == 'Owner Responded') {
          boxAppt.addAll([
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.all(8)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width,
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                        ],
                      ),
                      child: Text(
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: 28,
                              fontFamily: 'open'),
                          textAlign: TextAlign.center,
                          'Date:${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  String? selectedValue;
                                  bool color = false;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Center(
                                        child: SingleChildScrollView(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                          AlertDialog(
                                              content: const Center(
                                                  child: Text('Quote')),
                                              title: const Center(
                                                  child: Text(
                                                      'Here are the options and prices provided\n1. If chosen to accept select which type and accept\n2. Select type and input your counter offer \n3. Decline ')),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              actions: [
                                                Column(
                                                  children: [
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'Weekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['weekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'BiWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['biweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'TriWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['triweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Monthly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['monthly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Initial/Once:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['initial']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.82,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2(
                                                                isExpanded:
                                                                    true,
                                                                onMenuStateChange:
                                                                    (x) {
                                                                  print(color);
                                                                  if (color ==
                                                                      true) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          false;
                                                                    });
                                                                  } else if (color ==
                                                                      false) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          true;
                                                                    });
                                                                  }
                                                                  print(color);
                                                                },
                                                                hint: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .format_list_bulleted,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Select Type',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: items
                                                                    .map((item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item,
                                                                          child:
                                                                              Text(
                                                                            item,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: color ? Colors.black : Colors.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                                value:
                                                                    selectedValue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedValue =
                                                                        value;
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors.blue,
                                                                iconDisabledColor:
                                                                    Colors.grey,
                                                                buttonHeight:
                                                                    50,
                                                                buttonWidth:
                                                                    width * .82,
                                                                buttonPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14,
                                                                        bottom:
                                                                            14),
                                                                buttonDecoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            2.4,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                itemHeight: 30,
                                                                itemPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                dropdownMaxHeight:
                                                                    160,
                                                                dropdownWidth:
                                                                    width * .82,
                                                                dropdownPadding:
                                                                    null,
                                                                dropdownDecoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color(
                                                                      0xFFff2c3333),
                                                                ),
                                                                dropdownElevation:
                                                                    8,
                                                                scrollbarRadius:
                                                                    const Radius
                                                                        .circular(30),
                                                                scrollbarThickness:
                                                                    6,
                                                                scrollbarAlwaysShow:
                                                                    true,
                                                                offset:
                                                                    const Offset(
                                                                        -20, 0),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * .82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width:
                                                                    width * .82,
                                                                child:
                                                                    TextField(
                                                                        controller:
                                                                            counterOfferText,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.monetization_on,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.all(10),
                                                                          labelText:
                                                                              'Counter Offer',
                                                                          labelStyle:
                                                                              TextStyle(color: Colors.white),
                                                                          floatingLabelStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            letterSpacing:
                                                                                2,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.blue, width: 2.5),
                                                                          ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.white, width: 2.5),
                                                                          ),
                                                                        ))),
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.5,
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
                                                                          "Client Declined"
                                                                    };
                                                                    await Requests()
                                                                        .sendClientOffer(
                                                                            'http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}',
                                                                            updateQuote)
                                                                        .then(
                                                                            (value) {
                                                                      if (value ==
                                                                          'Success') {
                                                                        Navigator.of(context).popAndPushNamed(
                                                                            '/quotes',
                                                                            arguments:
                                                                                json.encode({
                                                                              "id": jsonDecode(this.arguments.message)['id'],
                                                                              "token": jsonDecode(this.arguments.message)['token']
                                                                            }));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Decline',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'opjn'),
                                                                  )),
                                                              const SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (selectedValue ==
                                                                        null) {
                                                                      showDialog<
                                                                          String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext context) => AlertDialog(
                                                                            title: const Text('Invalid Appointment Repeat Type'),
                                                                            content: const Text(
                                                                              'Please select a value of which you accept',
                                                                            ),
                                                                            actions: <Widget>[
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), foregroundColor: MaterialStateProperty.all(Colors.black)
                                                                                    //?
                                                                                    ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, 'OK');
                                                                                },
                                                                                child: const Text('OK'),
                                                                              ),
                                                                            ]),
                                                                      );
                                                                    } else {
                                                                      Navigator.of(context).popAndPushNamed(
                                                                          '/initialdates',
                                                                          arguments:
                                                                              json.encode({
                                                                            "id":
                                                                                jsonDecode(this.arguments.message)['id'],
                                                                            "token":
                                                                                jsonDecode(this.arguments.message)['token'],
                                                                            "type":
                                                                                selectedValue
                                                                          }));
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                      'Accept',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'opjn'))),
                                                              const SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var updateQuote =
                                                                        {
                                                                      "offerType":
                                                                          selectedValue,
                                                                      "offerClient":
                                                                          counterOfferText
                                                                              .text,
                                                                      "state":
                                                                          "Client Counter Offered"
                                                                    };
                                                                    await Requests()
                                                                        .sendClientOffer(
                                                                            'http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}',
                                                                            updateQuote)
                                                                        .then(
                                                                            (value) {
                                                                      if (value ==
                                                                          'Success') {
                                                                        Navigator.of(context).popAndPushNamed(
                                                                            '/quotes',
                                                                            arguments:
                                                                                json.encode({
                                                                              "id": jsonDecode(this.arguments.message)['id'],
                                                                              "token": jsonDecode(this.arguments.message)['token']
                                                                            }));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Offer',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'opjn'),
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
                            '${element['state']}',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'opjn'),
                          )))),
            ])
          ]);
        } else if (element['state'] == 'Client Counter Offered') {
          boxAppt.addAll([
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.all(8)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width,
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                        ],
                      ),
                      child: Text(
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: 28,
                              fontFamily: 'open'),
                          textAlign: TextAlign.center,
                          'Date:${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: const Text('Awaiting Offer Response',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'opjn')),
                          onPressed: () {})))
            ])
          ]);
        } else if (element['state'] == 'Owner Counter Offered') {
          boxAppt.addAll([
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.all(8)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width,
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                        ],
                      ),
                      child: Text(
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: 28,
                              fontFamily: 'open'),
                          textAlign: TextAlign.center,
                          'Date:${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  String? selectedValue;
                                  bool color = false;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Center(
                                        child: SingleChildScrollView(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                          AlertDialog(
                                              content: const Center(
                                                  child:
                                                      Text('Original Quote')),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              title: const Center(
                                                  child: Text(
                                                      'Here are the options and prices provided\n1. If chosen to accept select accept\n2.Input your counter offer \n3. Decline ')),
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              actions: [
                                                Column(
                                                  children: [
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'Weekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['weekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'BiWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['biweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'TriWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['triweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Monthly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['monthly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Initial/Once:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['initial']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Center(
                                                      child: Text("Your Offer",
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.82,
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
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Center(
                                                      child: Text("Owner Offer",
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.82,
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
                                                                '${element['quote']['offerOwner']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30))
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.82,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2(
                                                                isExpanded:
                                                                    true,
                                                                onMenuStateChange:
                                                                    (x) {
                                                                  print(color);
                                                                  if (color ==
                                                                      true) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          false;
                                                                    });
                                                                  } else if (color ==
                                                                      false) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          true;
                                                                    });
                                                                  }
                                                                  print(color);
                                                                },
                                                                hint: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .format_list_bulleted,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Select Type',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: items
                                                                    .map((item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item,
                                                                          child:
                                                                              Text(
                                                                            item,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: color ? Colors.black : Colors.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                                value:
                                                                    selectedValue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedValue =
                                                                        value;
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors.blue,
                                                                iconDisabledColor:
                                                                    Colors.grey,
                                                                buttonHeight:
                                                                    50,
                                                                buttonWidth:
                                                                    width * .82,
                                                                buttonPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14,
                                                                        bottom:
                                                                            14),
                                                                buttonDecoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            2.4,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                itemHeight: 30,
                                                                itemPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                dropdownMaxHeight:
                                                                    160,
                                                                dropdownWidth:
                                                                    width * .82,
                                                                dropdownPadding:
                                                                    null,
                                                                dropdownDecoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color(
                                                                      0xFFff2c3333),
                                                                ),
                                                                dropdownElevation:
                                                                    8,
                                                                scrollbarRadius:
                                                                    const Radius
                                                                        .circular(30),
                                                                scrollbarThickness:
                                                                    6,
                                                                scrollbarAlwaysShow:
                                                                    true,
                                                                offset:
                                                                    const Offset(
                                                                        -20, 0),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * .82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width:
                                                                    width * .82,
                                                                child:
                                                                    TextField(
                                                                        controller:
                                                                            counterOfferText,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.monetization_on,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.all(10),
                                                                          labelText:
                                                                              'Counter Offer',
                                                                          labelStyle:
                                                                              TextStyle(color: Colors.white),
                                                                          floatingLabelStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            letterSpacing:
                                                                                2,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.blue, width: 2.5),
                                                                          ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.white, width: 2.5),
                                                                          ),
                                                                        ))),
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.5,
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
                                                                          "Client Declined"
                                                                    };
                                                                    await Requests()
                                                                        .sendClientOffer(
                                                                            'http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}',
                                                                            updateQuote)
                                                                        .then(
                                                                            (value) {
                                                                      if (value ==
                                                                          'Success') {
                                                                        Navigator.of(context).popAndPushNamed(
                                                                            '/quotes',
                                                                            arguments:
                                                                                json.encode({
                                                                              "id": jsonDecode(this.arguments.message)['id'],
                                                                              "token": jsonDecode(this.arguments.message)['token']
                                                                            }));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Decline',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'opjn'),
                                                                  )),
                                                              const SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (selectedValue ==
                                                                        null) {
                                                                      showDialog<
                                                                          String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext context) => AlertDialog(
                                                                            title: const Text('Invalid Appointment Repeat Type'),
                                                                            content: const Text(
                                                                              'Please select a value of which you accept',
                                                                            ),
                                                                            actions: <Widget>[
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), foregroundColor: MaterialStateProperty.all(Colors.black)
                                                                                    //?
                                                                                    ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, 'OK');
                                                                                },
                                                                                child: const Text('OK'),
                                                                              ),
                                                                            ]),
                                                                      );
                                                                    } else {
                                                                      Navigator.of(context).popAndPushNamed(
                                                                          '/initialdates',
                                                                          arguments:
                                                                              json.encode({
                                                                            "id":
                                                                                jsonDecode(this.arguments.message)['id'],
                                                                            "token":
                                                                                jsonDecode(this.arguments.message)['token'],
                                                                            "type":
                                                                                selectedValue
                                                                          }));
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                      'Accept',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'opjn'))),
                                                              const SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var updateQuote =
                                                                        {
                                                                      "offerClient":
                                                                          counterOfferText
                                                                              .text,
                                                                      "state":
                                                                          "Client Counter Offered"
                                                                    };
                                                                    await Requests()
                                                                        .sendClientOffer(
                                                                            'http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}',
                                                                            updateQuote)
                                                                        .then(
                                                                            (value) {
                                                                      if (value ==
                                                                          'Success') {
                                                                        Navigator.of(context).popAndPushNamed(
                                                                            '/quotes',
                                                                            arguments:
                                                                                json.encode({
                                                                              "id": jsonDecode(this.arguments.message)['id'],
                                                                              "token": jsonDecode(this.arguments.message)['token']
                                                                            }));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Offer',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'opjn'),
                                                                  )),
                                                            ]))
                                                  ],
                                                ),
                                              ])
                                        ])));
                                  });
                                });
                          },
                          child: const Text(
                            'Owner Responded',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'opjn'),
                          )))),
            ])
          ]);
        } else if (element['state'] == 'Owner Accepted Offered') {
          boxAppt.addAll([
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.all(8)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width,
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                        ],
                      ),
                      child: Text(
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: 28,
                              fontFamily: 'open'),
                          textAlign: TextAlign.center,
                          'Date:${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: const Text('Setup Initial Appointments',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).popAndPushNamed('/initialdates',
                                arguments: json.encode({
                                  "id":
                                      jsonDecode(this.arguments.message)['id'],
                                  "token": jsonDecode(
                                      this.arguments.message)['token'],
                                  "type": element['quote']['offerType']
                                }));
                          })))
            ])
          ]);
        } else if (element['state'] == 'Owner Declined' ||
            element['state'] == 'Client Declined') {
          boxAppt.addAll([
            const SizedBox(height: 20),
            const Padding(padding: EdgeInsets.all(8)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width,
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Color(0xFFE7F6F2), spreadRadius: 3),
                        ],
                      ),
                      child: Text(
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontSize: 28,
                              fontFamily: 'open'),
                          textAlign: TextAlign.center,
                          'Date:${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'))),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              LimitedBox(
                  maxWidth: width * 1.015,
                  child: Container(
                      width: width * 1.015,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffE7F6F2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(20)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  String? selectedValue;
                                  bool color = false;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Center(
                                        child: SingleChildScrollView(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                          AlertDialog(
                                              content: const Center(
                                                  child:
                                                      Text('Original Quote')),
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              title: const Center(
                                                  child: Text(
                                                      'Here are the options and prices provided\n1. If chosen to accept select accept\n2.Input your counter offer \n3. Decline ')),
                                              actionsPadding:
                                                  const EdgeInsets.all(20),
                                              actions: [
                                                Column(
                                                  children: [
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'Weekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['weekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'BiWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['biweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Text(
                                                                'TriWeekly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['triweekly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.5,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Monthly:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['monthly']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * 0.82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                                'Initial/Once:',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30)),
                                                            const Icon(
                                                                Icons
                                                                    .attach_money,
                                                                size: 30,
                                                                color: Colors
                                                                    .white),
                                                            Text(
                                                                '${element['quote']['initial']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            30))
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.82,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2(
                                                                isExpanded:
                                                                    true,
                                                                onMenuStateChange:
                                                                    (x) {
                                                                  print(color);
                                                                  if (color ==
                                                                      true) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          false;
                                                                    });
                                                                  } else if (color ==
                                                                      false) {
                                                                    setState(
                                                                        () {
                                                                      color =
                                                                          true;
                                                                    });
                                                                  }
                                                                  print(color);
                                                                },
                                                                hint: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .format_list_bulleted,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Select Type',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                items: items
                                                                    .map((item) =>
                                                                        DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              item,
                                                                          child:
                                                                              Text(
                                                                            item,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: color ? Colors.black : Colors.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                                value:
                                                                    selectedValue,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedValue =
                                                                        value;
                                                                  });
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor:
                                                                    Colors.blue,
                                                                iconDisabledColor:
                                                                    Colors.grey,
                                                                buttonHeight:
                                                                    50,
                                                                buttonWidth:
                                                                    width * .82,
                                                                buttonPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14,
                                                                        bottom:
                                                                            14),
                                                                buttonDecoration:
                                                                    const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            2.4,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                itemHeight: 30,
                                                                itemPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14),
                                                                dropdownMaxHeight:
                                                                    160,
                                                                dropdownWidth:
                                                                    width * .82,
                                                                dropdownPadding:
                                                                    null,
                                                                dropdownDecoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14),
                                                                  color: const Color(
                                                                      0xFFff2c3333),
                                                                ),
                                                                dropdownElevation:
                                                                    8,
                                                                scrollbarRadius:
                                                                    const Radius
                                                                        .circular(30),
                                                                scrollbarThickness:
                                                                    6,
                                                                scrollbarAlwaysShow:
                                                                    true,
                                                                offset:
                                                                    const Offset(
                                                                        -20, 0),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                      maxWidth: width * .82,
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width:
                                                                    width * .82,
                                                                child:
                                                                    TextField(
                                                                        controller:
                                                                            counterOfferText,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.monetization_on,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.all(10),
                                                                          labelText:
                                                                              'Counter Offer',
                                                                          labelStyle:
                                                                              TextStyle(color: Colors.white),
                                                                          floatingLabelStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            letterSpacing:
                                                                                2,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.blue, width: 2.5),
                                                                          ),
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.white, width: 2.5),
                                                                          ),
                                                                        ))),
                                                          ]),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    LimitedBox(
                                                        maxWidth: width * 0.5,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (selectedValue ==
                                                                        null) {
                                                                      showDialog<
                                                                          String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext context) => AlertDialog(
                                                                            title: const Text('Invalid Appointment Repeat Type'),
                                                                            content: const Text(
                                                                              'Please select a value of which you accept',
                                                                            ),
                                                                            actions: <Widget>[
                                                                              ElevatedButton(
                                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), foregroundColor: MaterialStateProperty.all(Colors.black)
                                                                                    //?
                                                                                    ),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, 'OK');
                                                                                },
                                                                                child: const Text('OK'),
                                                                              ),
                                                                            ]),
                                                                      );
                                                                    } else {
                                                                      //change intial dates to also render on buiild like estimates
                                                                      Navigator.of(context).popAndPushNamed(
                                                                          '/initialdates',
                                                                          arguments:
                                                                              json.encode({
                                                                            "id":
                                                                                jsonDecode(this.arguments.message)['id'],
                                                                            "token":
                                                                                jsonDecode(this.arguments.message)['token'],
                                                                            "type":
                                                                                selectedValue
                                                                          }));
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                      'Accept',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'opjn'))),
                                                              const SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var updateQuote =
                                                                        {
                                                                      "offerType":
                                                                          selectedValue,
                                                                      "offerClient":
                                                                          counterOfferText
                                                                              .text,
                                                                      "state":
                                                                          "Client Counter Offered"
                                                                    };
                                                                    await Requests()
                                                                        .sendClientOffer(
                                                                            'http://10.0.2.2:8080/calendar/calendar/sendoffer/${element['quote']['id']}',
                                                                            updateQuote)
                                                                        .then(
                                                                            (value) {
                                                                      if (value ==
                                                                          'Success') {
                                                                        Navigator.of(context).popAndPushNamed(
                                                                            '/quotes',
                                                                            arguments:
                                                                                json.encode({
                                                                              "id": jsonDecode(this.arguments.message)['id'],
                                                                              "token": jsonDecode(this.arguments.message)['token']
                                                                            }));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Offer',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'opjn'),
                                                                  )),
                                                            ]))
                                                  ],
                                                ),
                                              ])
                                        ])));
                                  });
                                });
                          },
                          child: const Text(
                            'View Quote',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'opjn'),
                          )))),
            ])
          ]);
        }
      }
    });

    if (boxAppt.isEmpty) {
      return [
        Container(
            margin: const EdgeInsets.all(20), child: const Text('No Quotes'))
      ];
    } else {
      return boxAppt;
    }
  }
}
