// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:offprice/constants/api.dart';
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

    notifyListeners();
    return userLoggedIn;
  }

  Future<bool> signIn(
      {required String login,
      required String password,
      bool automatic = false}) async {
    var url = Uri.parse('$host/api/users/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body);

      if (responseData['status'] != null) {
        throw HttpException(responseData['message']);
      }

      _token = responseData['data']['token'];
      await storeUser(login, password);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<int> forgotPassword(String login) async {
    var url = Uri.parse('$host/api/users/forgotPassword');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: jsonEncode(<String, String>{
          'login': login,
        }),
      );

      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> resetPassword(
      {required String token,
      required String password,
      required String retypePassword}) async {
    var url = Uri.parse('$host/api/users/resetPassword/$token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'retypePassword': retypePassword,
        }),
      );

      print(response.body);

      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> updatePassword(
      {required String password, required String retypePassword}) async {
    var url = Uri.parse('$host/api/users/updatePassword');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'retypePassword': retypePassword,
        }),
      );

      print(response.body);
      print(response.statusCode);

      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  //function to register user via api with url and body
  Future<bool> signUp(
      {required String login,
      required String email,
      required String password,
      required String retypePassword}) async {
    var url = Uri.parse('$host/api/users/signup');

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
      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }
      _token = responseData['data']['token'];
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> logout() async {
    _token = '';
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('password');
    notifyListeners();
  }
}
