import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/login_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiratedDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  void disconnect() {
    _token = null;
    notifyListeners();
  }

  String get token {
    if (_expiratedDate != null &&
        _expiratedDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sign$urlSegment?key=AIzaSyAt72cP13Fqg0R-dyFIEOUXopwcjoqpRhM';
/*     try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['ERROR'] != null) {
        print(responseData['ERROR']);
        throw HttpException(responseData['ERROR']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiratedDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    } */
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      print(json.decode(response.body));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        print('Enfin');
        throw LoginException('${responseData['error']['message']}');
      } else {
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiratedDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'Up');
  }

  Future<void> login(String email, String password) async {
    try {
      final a = await _authenticate(email, password, 'InWithPassword');
    } on LoginException catch (e) {
      print('Login Exception');
      throw e;
    } catch (e) {
      print('Login Error');
      throw e;
    }
  }
}
