// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';
import 'package:test_app/Components/Requests.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = getParsedDates();

Future<LinkedHashMap<DateTime, List<Event>>> getParsedDates() async {
  LinkedHashMap<DateTime, List<Event>> parsed =
      LinkedHashMap<DateTime, List<Event>>();
  await Requests()
      .getDateSpans("http://10.0.2.2:8080/calendar/calendar/dayspans",
          kFirstDay, kLastDay)
      .then((value) {
    if (value != null) {
      List dates = jsonDecode(value);
      print(dates);
      for (var i = 0; i < dates.length; i++) {
        List<Event> events = [];
        List rawEvents = dates[i]['time_slots'];
        DateTime x = DateTime.parse(dates[i]['date']);
        DateTime day = DateTime(x.year, x.month, x.day);
        for (var i = 0; i < rawEvents.length; i++) {
          events.add(new Event(rawEvents[i]));
        }
        parsed.addAll({day: events});
      }
    }
    // print(parsed);
    // parsed.addAll({
    // kFirstDay: [
    //   Event('Today\'s Event 1'),
    //   Event('Today\'s Event 2'),
    // ],
    //   kLastDay: [
    //     Event('Today\'s Event 1'),
    //     Event('Today\'s Event 2'),
    //   ],
    // });
  });

  return parsed;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);

final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
