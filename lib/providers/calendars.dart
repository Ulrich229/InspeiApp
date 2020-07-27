import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Calendars with ChangeNotifier {
  String url1;
  String url2;

  Future<void> fetchCalendars(String classe) async {
    final url = 'https://inspeiapp.firebaseio.com/Calendar.json';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']);
      } else {
        print(responseData);
        if (classe == 'CP1') {
          url1 = responseData['-MCiYTKFDyQvVkni8Wkq']['C1'];
          url2 = responseData['-MCiYTKFDyQvVkni8Wkq']['C2'];
          print(url1);
          print(url2);
        } else {
          url1 = responseData['-MCiYY1B71rNkJZEx2cg']['C1'];
          url2 = responseData['-MCiYY1B71rNkJZEx2cg']['C2'];
          print(url1);
          print(url2);
        }
      }
    } catch (e) {
      throw e;
    }

    notifyListeners();
  }
}
