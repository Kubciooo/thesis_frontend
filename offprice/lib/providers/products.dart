import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/auth.dart';

class ProductsProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  bool shouldFetch = true;
  final List<ProductModel> _products = [];
  final List<ProductModel> _favourites = [];
  get token => _token;

  void update(AuthProvider auth) {
    _token = auth.token;
  }

  void clearProducts() {
    _products.clear();
    shouldFetch = true;
    notifyListeners();
  }

  Future<List<ProductModel>> refreshProducts({min, max, name}) async {
    return getProducts(refresh: true, min: min, max: max, name: name);
  }

  Future<List<ProductModel>> getProducts(
      {refresh = false, min = 0, max = 999999, name = ''}) async {
    if (shouldFetch) {
      shouldFetch = false;
      await getLatestProducts(min: min, max: max, name: name);
    }
    if (refresh) {
      clearProducts();
    }

    return _products;
  }

  Future<String> followProduct(productId) async {
    final url = 'http://localhost:3000/api/products/$productId';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favourites.clear();
      await getFavProducts();
      return 'Product followed';
    } else {
      return 'Failed to add product to user';
    }
  }

  Future<String> unfollowProduct(productId) async {
    final url = 'http://localhost:3000/api/products/products/$productId';
    final uri = Uri.parse(url);
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favourites.clear();
      await getFavProducts();
      return 'Product unfollowed';
    } else {
      return 'Failed to unfollow product';
    }
  }

  Future<void> getLatestProducts({min = -1, max = 9000000, name = ''}) async {
    var url =
        ('http://localhost:3000/api/products?price[gte]=${min.toString()}&price[lte]=${max.toString()}&name=$name');

    var uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }
      for (var i = 0; i < responseData['data']['products'].length; i++) {
        // print(responseData['data']['products'][i]);
        _products.add(
            ProductModel.fromJsonShop(responseData['data']['products'][i]));
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  bool isFollowed(String productId) {
    for (var i = 0; i < _favourites.length; i++) {
      if (_favourites[i].id == productId) {
        return true;
      }
    }
    return false;
  }

  Future<void> getFavProducts() async {
    var url = Uri.parse('http://localhost:3000/api/users/products');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      for (var i = 0; i < responseData['data']['products'].length; i++) {
        // print(responseData['data']['products'][i]);
        _favourites
            .add(ProductModel.fromJson(responseData['data']['products'][i]));
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
