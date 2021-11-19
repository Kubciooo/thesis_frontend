import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:offprice/constants/api.dart';
import 'package:offprice/models/deal.dart';
import 'package:offprice/providers/auth.dart';

class PromotionsProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  final List<DealModel> _deals = [];
  final List<DealModel> _favDeals = [];

  get deals => [..._deals];
  get favDeals => [..._favDeals];
  bool _shouldFetch = true;
  int _likes = 0;
  get likes => _likes;
  get token => _token;

  void update(AuthProvider auth) {
    _token = auth.token;
    _shouldFetch = true;
    _deals.clear();
    _favDeals.clear();
    _shouldFetch = true;
    _likes = 0;
  }

  void clearPromotions() {
    _shouldFetch = true;
    _deals.clear();
  }

  Future<int> refreshPromotions() async {
    return getPromotions(refresh: true);
  }

  Future<int> getPromotions(
      {refresh = false, filter = '', fetchUser = false}) async {
    int statusCode = 401;
    if (refresh) {
      clearPromotions();
    }

    if (_shouldFetch) {
      await getLikes();
      _shouldFetch = false;
      statusCode = await getLatestPromotions();
      if (fetchUser) {
        statusCode = await getUserPromotions();
      }
      notifyListeners();
    }
    if (filter != '') {
      _deals.removeWhere((deal) =>
          !deal.product.name.toLowerCase().contains(filter.toLowerCase()));
    }
    return statusCode;
  }

  Future<int> followPromotion(promotionId) async {
    final url = '$host/api/promotions/products/$promotionId';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favDeals.clear();
      await getUserPromotions();
      // return 'Promotion followed';
    } else {
      print(response.body);
      // return 'Failed to add promotion to user';
    }
    return response.statusCode;
  }

  Future<int> setLikes(int likes) async {
    final url = '$host/api/users/likes';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'likes': likes,
      }),
    );
    if (response.statusCode == 201) {
      _likes = likes;
      notifyListeners();
    } else {
      print(response.body);
    }
    return response.statusCode;
  }

  Future<int> getLikes() async {
    final url = '$host/api/users/likes';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _likes = json.decode(response.body)['data']['likes'];
    } else {
      print(response.body);
    }

    return response.statusCode;
  }

  Future<int> unfollowPromotion(promotionId) async {
    final url = '$host/api/promotions/products/$promotionId';
    final uri = Uri.parse(url);
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favDeals.clear();
      await getUserPromotions();
    } else {
      print(response.body);
    }
    return response.statusCode;
  }

  Future<int> addPromotion(
      {required String product,
      required double startingPrice,
      required String type,
      required String discountType,
      required String coupon,
      required bool userValidation,
      required DateTime expiresAt,
      required int percentage,
      required double cash}) async {
    var url = Uri.parse('$host/api/promotions/products');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'product': product,
          'type': type,
          'startingPrice': startingPrice,
          'discountType': discountType,
          'coupon': coupon,
          'percentage': percentage,
          'cash': cash,
          'expiresAt': expiresAt.toIso8601String(),
        }),
      );
      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }
      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 401;
    }
  }

  Future<int> getLatestPromotions() async {
    var url = Uri.parse('$host/api/promotions/products');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 401) {
        return response.statusCode;
      }

      if (responseData['status'] == 'Error') {
        throw HttpException(responseData['message']);
      }
      for (var i = 0;
          i < responseData['data']['productPromotions'].length;
          i++) {
        // print(responseData['data']['productPromotions'][i]);
        _deals.add(
            DealModel.fromJson(responseData['data']['productPromotions'][i]));
      }

      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  bool isFollowed(String promotionId) {
    for (var i = 0; i < _favDeals.length; i++) {
      if (_favDeals[i].id == promotionId) {
        return true;
      }
    }
    return false;
  }

  Future<int> getUserPromotions() async {
    var url = Uri.parse('$host/api/users/productPromotions');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'Error') {
        throw HttpException(responseData['message']);
      }

      for (var i = 0;
          i < responseData['data']['productPromotions'].length;
          i++) {
        // print(responseData['data']['productPromotions'][i]);
        _favDeals.add(
            DealModel.fromJson(responseData['data']['productPromotions'][i]));
      }

      return response.statusCode;
    } catch (error) {
      print(error);
      return 401;
    }
  }
}
