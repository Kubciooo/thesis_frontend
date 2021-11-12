import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:offprice/models/deal.dart';
import 'package:offprice/providers/auth.dart';

class PromotionsProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  final List<DealModel> _deals = [];
  final List<DealModel> _favDeals = [];
  get token => _token;

  void update(AuthProvider auth) {
    _token = auth.token;
  }

  void clearPromotions() {
    _deals.clear();
    notifyListeners();
  }

  Future<List<DealModel>> refreshPromotions() async {
    return getPromotions(refresh: true);
  }

  Future<List<DealModel>> getPromotions({refresh = false, filter = ''}) async {
    if (_deals.isEmpty) {
      await getLatestPromotions();
    }

    if (refresh) {
      clearPromotions();
    }
    if (filter != '') {
      return _deals
          .where((deal) =>
              deal.product.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    return _deals;
  }

  Future<String> followPromotion(promotionId) async {
    final url = 'http://localhost:3000/api/promotions/products/$promotionId';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favDeals.clear();
      await getFavPromotions();
      return 'Promotion followed';
    } else {
      return 'Failed to add promotion to user';
    }
  }

  Future<String> unfollowPromotion(promotionId) async {
    final url = 'http://localhost:3000/api/promotions/products/$promotionId';
    final uri = Uri.parse(url);
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favDeals.clear();
      await getFavPromotions();
      return 'Promotion unfollowed';
    } else {
      return 'Failed to unfollow promotion';
    }
  }

  // function to reset forgotten password
  Future<void> getLatestPromotions() async {
    var url = Uri.parse('http://localhost:3000/api/promotions/products');
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

  Future<void> getFavPromotions() async {
    var url = Uri.parse('http://localhost:3000/api/users/productPromotions');
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
