// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';
import 'package:test_app/Components/Requests.dart';

/// Example OwnerEvent class.
class OwnerEvent {
  final String name;
  final String time;
  final int id;

  const OwnerEvent(this.name, this.time, this.id);

  @override
  String toString() => "{name:${name},time:${time},id:${id}}";
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var ownerEvents = getOwnerParsedDates();

Future<LinkedHashMap<DateTime, List<OwnerEvent>>> getOwnerParsedDates() async {
  LinkedHashMap<DateTime, List<OwnerEvent>> parsed =
      LinkedHashMap<DateTime, List<OwnerEvent>>();
  await Requests()
      .getOwnerAppts(
          "http://10.0.2.2:8080/calendar/calendar/ownerappointments/")
      .then((value) {
    if (value != null) {
      List dates = jsonDecode(value);

      for (var i = 0; i < dates.length; i++) {
        List<OwnerEvent> events = [];
        List rawEvents = dates[i]['time_slots'];
        DateTime x = DateTime.parse(dates[i]['date']);
        DateTime day = DateTime(x.year, x.month, x.day);

        for (var i = 0; i < rawEvents.length; i++) {
          var timeslot = rawEvents.elementAt(i);
          events.add(
              OwnerEvent(timeslot["name"], timeslot["time"], timeslot["id"]));
        }
        parsed.addAll({day: events});
      }
    }
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

final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
