import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';

  String get token => _token;

  // funtion to store login and password in shared preferences
  Future<void> storeUser(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'login';
    final value = login;
    prefs.setString(key, value);
    const key1 = 'password';
    final value1 = password;
    prefs.setString(key1, value1);
  }

  // function to get login and password from shared preferences
  Future<Map<String, String>> getUserLoginAndPassword() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'login';
    final value = prefs.getString(key);
    const key1 = 'password';
    final value1 = prefs.getString(key1);
    return {'login': value!, 'password': value1!};
  }

  Future<bool> automaticLogin() async {
    var userData = await getUserLoginAndPassword();
    if (userData['login'] == null || userData['password'] == null) {
      return false;
    }

    var login = userData['login'];
    var password = userData['password'];
    bool userLoggedIn = await signIn(login: login!, password: password!);

    return userLoggedIn;
  }

  Future<bool> signIn(
      {required String login,
      required String password,
      bool automatic = false}) async {
    var url = Uri.parse('http://localhost:3000/api/users/login');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['status'] != null) {
        throw HttpException(responseData['status']['meesage']);
      }

      _token = responseData['data']['token'];
      await storeUser(login, password);
      print(token);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  //function to register user via api with url and body
  Future<bool> signUp(String login, String email, String password,
      String retypePassword) async {
    var url = Uri.parse('http://localhost:3000/api/users/signup');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'email': email,
          'retypePassword': retypePassword,
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['data']['token'];
      print(token);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  // function to reset forgotten password
  Future<bool> forgotPassword(String login) async {
    var url = Uri.parse('http://localhost:3000/api/users/forgotPassword');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': login,
        }),
      );

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}