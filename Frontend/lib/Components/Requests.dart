import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';

class Requests {
  Future<String> makePostRequest(
      String url, Map<String, dynamic> requestBody) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json'
    };
    Response response = await post(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  Future<String> createUser(String url, Map<String, dynamic> newUser) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // 'Authorization': 'Bearer' + 'token'
    };
    Response response =
        await post(requestLink, headers: headers, body: json.encode(newUser));

    if (response.statusCode != 201) {
      return "null";
    } else {
      var x = jsonDecode(response.body);
      return x['user']['name'];
    }
  }

  Future<Map<String, dynamic>> login(
      String url, Map<String, dynamic> user) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
    };
    Response response =
        await post(requestLink, headers: headers, body: json.encode(user));
    if (response.statusCode == 401) {
      print(response.body);
      return {
        "response": {"user": "bad user"}
      };
    }
    if (response.statusCode != 201) {
      print(response.body);
      return {
        "response": {"user": "emailauth"}
      };
    } else {
      var x = jsonDecode(response.body);

      String token = x['access_token'].toString();
      String email = user['username'].toString();

      var entry = await userLogin(
          "http://10.0.2.2:8080/users/user/usertype/${email}", token);
      return {"response": json.decode(entry), "token": token};
    }
  }

  Future<String> userLogin(String url, String token) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(requestLink, headers: headers);

    return response.body;
  }

  Future<String> addOwnerPref(
      String url, Map<String, dynamic> preferences, String token) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    Response response = await patch(requestLink,
        headers: headers,
        body:
            json.encode({"estimatePreferences": preferences.values.toList()}));

    print(response.body);
    return response.body;
  }

  Future<String> addOwnerExcluded(
      String url, List preferences, String token) async {
    print(json.encode({"excluded_Days": preferences}));

    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    Response response = await patch(requestLink,
        headers: headers, body: json.encode({"excluded_Days": preferences}));

    print(response.body);
    return response.body;
  }

  Future<String> getDateSpans(String url, DateTime from, DateTime to) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    print({"from": from, "to": to});
    Response response = await post(requestLink,
        headers: headers,
        body: json.encode({"from": from.toString(), "to": to.toString()}));

    print(response.body.toString());
    return response.body.toString();
  }

  Future<String> createEstimate(
      String url, Map<String, dynamic> estimateDay, token) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    // print({"from": from, "to": to});
    Response response = await post(requestLink,
        headers: headers, body: json.encode(estimateDay));

    //print(response.body.toString());
    return response.body;
  }

  Future<String> getClientAppts(String url) async {
    final requestLink = Uri.parse(url);

    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );
    print(response.body);
    return response.body.toString();
  }

  Future<String> getOwnerAppts(String url) async {
    final requestLink = Uri.parse(url);

    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    return response.body.toString();
  }

  Future<String> getPendingEstimates(String url) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );
    print(response.body);
    return response.body.toString();
  }

  Future<String> makeClientQuote(
      String url, Map<String, dynamic> quote, String param2) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    // print("preflight")
    // ;
    Response response =
        await post(requestLink, headers: headers, body: json.encode(quote));

    // print(response.body);
    return response.body.toString();
  }

  Future<String> getClientQuotes(String url) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    print(url);
    Response response = await get(
      requestLink,
      headers: headers,
    );

    print(response.body);
    return response.body.toString();
  }

  Future<String> sendClientOffer(
      String url, Map<String, String?> updateQuote) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };
    print(url);
    Response response = await post(requestLink,
        headers: headers, body: json.encode(updateQuote));

    print("after" + response.body);
    return response.body.toString();
  }

  sendOwnerAcceptOffer(String url, Map<String, String> updateQuote) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await post(requestLink,
        headers: headers, body: json.encode(updateQuote));

    print("after" + response.body);
    return response.body.toString();
  }

  createAppointmentSlots(
      String url, Map<String, dynamic> estimateDay, jsonDecode) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await post(requestLink,
        headers: headers, body: json.encode(estimateDay));

    return response.body.toString();
  }

  cancelAppointment(String url) async {
    print(url);
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    print(response.body);
    return response.body.toString();
  }

  getOwnerPref() async {
    final requestLink =
        Uri.parse("http://10.0.2.2:8080/calendar/calendar/ownerPref");
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    print(response.body);
    return response.body.toString();
  }

  getExcluded() async {
    final requestLink =
        Uri.parse("http://10.0.2.2:8080/calendar/calendar/excluded");
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    print("body" + response.body);
    return response.body.toString();
  }

  getClients() async {
    final requestLink =
        Uri.parse("http://10.0.2.2:8080/calendar/calendar/allClients");
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    print("body" + response.body);
    return response.body.toString();
  }

  getClientInfo(url) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );

    print("body" + response.body);
    return response.body.toString();
  }

  updateUser(String url, Map<String, dynamic> newUser, token) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response =
        await patch(requestLink, headers: headers, body: {"user": newUser});
  }

  terminateService(url) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer ' + token
    };

    Response response = await get(
      requestLink,
      headers: headers,
    );
  }
}
