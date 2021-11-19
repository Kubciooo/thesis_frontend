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
  bool _shouldFetch = true;
  int _likes = 0;
  get likes => _likes;
  get token => _token;

  void update(AuthProvider auth) {
    _token = auth.token;
  }

  void clearPromotions() {
    _shouldFetch = true;
    _deals.clear();
  }

  Future<List<DealModel>> refreshPromotions() async {
    return getPromotions(refresh: true);
  }

  Future<List<DealModel>> getPromotions(
      {refresh = false, filter = '', fetchUser = false}) async {
    if (refresh) {
      clearPromotions();
    }

    if (_shouldFetch) {
      await getLikes();
      _shouldFetch = false;
      await getLatestPromotions();
      if (fetchUser) {
        await getUserPromotions();
      }
      notifyListeners();
    }
    if (filter != '') {
      return _deals
          .where((deal) =>
              deal.product.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    return _deals;
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
      print(response.body);
      print(_likes);
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
      // return 'Promotion unfollowed';
    } else {
      print(response.body);
      // return 'Failed to unfollow promotion';
    }
    return response.statusCode;
  }

  Future<String> addPromotion(
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
      return 'Promotion added successfully';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // function to reset forgotten password
  Future<void> getLatestPromotions() async {
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
      notifyListeners();
    } catch (error) {
      print(error);
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

  Future<void> getUserPromotions() async {
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

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
