import 'package:flutter/material.dart';
import 'package:test_app/Client/ClientUpdate.dart';
import 'package:test_app/Client/Quotes.dart';
import 'package:test_app/Estimates/Estimates.dart';
import 'package:test_app/Estimates/guestAppointments.dart';
import 'package:test_app/Login/forgotVerify.dart';
import 'package:test_app/Login/resetPass.dart';
import 'package:test_app/Login/signup.dart';
import 'package:test_app/Owner/Clients.dart';
import 'package:test_app/Owner/Daily.dart';
import 'package:test_app/Owner/OwnerSettings.dart';
import 'package:test_app/Owner/clientInfo.dart';
import 'package:test_app/Preferences/OwnerPrefUpdate.dart';
import 'package:test_app/tableCalendar/initialDate.dart';
import 'package:test_app/tableCalendar/ownerAppointments.dart';

import 'Client/ClientSettings.dart';
import 'Login/forgot.dart';
import 'Login/forgotVerify.dart';
import 'Login/forgotVerify.dart';
import 'Login/signin.dart';
import 'Owner/PendingEstimates.dart';
import 'Preferences/OwnerPref.dart';
import 'tableCalendar/estimateCalendar.dart';

void main() => runApp(const MyApp());
const String _title = 'Business Automation';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
            headline1: TextStyle(color: Colors.white, letterSpacing: 1),
            headline2: TextStyle(color: Colors.white, letterSpacing: 1),
            headline3: TextStyle(color: Colors.white, letterSpacing: 1),
            headline4: TextStyle(color: Colors.white, letterSpacing: 1),
            headline5: TextStyle(color: Colors.white, letterSpacing: 1),
            headline6: TextStyle(color: Colors.white, letterSpacing: 1),
            subtitle1: TextStyle(color: Colors.white, letterSpacing: 1),
            subtitle2: TextStyle(color: Colors.white, letterSpacing: 1),
            bodyText1: TextStyle(color: Colors.white, letterSpacing: 1),
            bodyText2: TextStyle(color: Colors.white, letterSpacing: 1),
            button: TextStyle(color: Colors.white, letterSpacing: 1),
            caption: TextStyle(color: Colors.white, letterSpacing: 1),
            overline: TextStyle(color: Colors.white, letterSpacing: 1),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black))),
          timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.black,
              dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.white
                      : Colors.black),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.black
                      : Colors.white),
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Color(0xFF395B64)
                      : Color(0xFF395B64)),
              hourMinuteTextColor:
                  MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.white : Colors.white),
              dialHandColor: Colors.white.withOpacity(0.8),
              dialBackgroundColor: Color(0xFF395B64),
              dialTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.black : Colors.white),
              entryModeIconColor: Colors.white),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
          )),
          dialogBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(backgroundColor: Color(0xFF395B64), titleTextStyle: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w100, fontFamily: 'open'), centerTitle: true),
          fontFamily: 'open',
          hintColor: Colors.white,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color(0xFFff2c3333),
          // ignore: deprecated_member_use

          buttonColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
            floatingLabelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
            prefixIconColor: Colors.white,
            iconColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow)),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => SignIn(),
        "/signup": (context) => SignUp(),
        "/excluded_days": (context) => Estimates(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/forgot": (context) => const Forgot(),
        ForgotVerify.route: (context) => ForgotVerify(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        ResetPass.route: (context) => ResetPass(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        // ignore: equal_keys_in_map
        OwnerPref.route: (context) => OwnerPref(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/estimatecalendar": (context) => EstimateCalendar(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/guestappointments": (context) => guestAppointment(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/ownerdaily": (context) => Daily(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/ownerestimates": (context) => PendingEstimates(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/quotes": (context) => Quotes(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/initialdates": (context) => InitialDate(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/ownerappts": (context) => OwnerAppointments(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/ownersettings": (context) => OwnerSettings(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/ownerprefupdate": (context) => OwnerPrefUpdate(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/clients": (context) => Clients(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/clientInfo": (context) => ClientInfo(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
        "/clientsettings": (context) => ClientSettings(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())), 
        "/clientupdate": (context) => ClientUpdate(ScreenArguments(
            ModalRoute.of(context)!.settings.arguments.toString())),
      },
    );
  }
}
