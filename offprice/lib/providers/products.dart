// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:offprice/constants/api.dart';
// import color package

import 'package:offprice/models/product.dart';
import 'package:offprice/models/product_chart.dart';
import 'package:offprice/models/shop.dart';
import 'package:offprice/providers/auth.dart';

class ProductsProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  bool shouldFetch = true;
  ProductModel _favouriteProduct = ProductModel(
    categories: [],
    id: '',
    name: '',
    price: 0,
    coupons: [],
    otherPromotions: [],
    shop: '',
    snapshots: [],
    url: '',
  );
  final List<ProductModel> _products = [];
  final List<ProductModel> _favourites = [];
  final List<ShopModel> _shops = [];
  final List<ShopModel> _blockedShops = [];
  get token => _token;

  get isFavouriteProductSet => _favouriteProduct.id != '';
  get favouriteProduct => _favouriteProduct;

  bool isFavorite(ProductModel product) {
    return favouriteProduct.id == product.id;
  }

  bool isBlockedShop(ShopModel shop) {
    return _blockedShops.where((element) => element.id == shop.id).isNotEmpty;
  }

  void update(AuthProvider auth) {
    _token = auth.token;
    shouldFetch = true;
    _favouriteProduct = ProductModel(
      categories: [],
      id: '',
      name: '',
      price: 0,
      coupons: [],
      otherPromotions: [],
      shop: '',
      snapshots: [],
      url: '',
    );
    _products.clear();
    _favourites.clear();
    notifyListeners();
  }

  List<ProductModel> get products {
    return [..._products];
  }

  List<ProductModel> get favourites {
    return [..._favourites];
  }

  List<ShopModel> get shops {
    return [..._shops];
  }

  void clearProducts() {
    _products.clear();
    shouldFetch = true;
  }

  Future<int> setFavouriteProduct(ProductModel product) async {
    final url = '$host/api/users/favourites/product';

    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'productId': product.id,
        }),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _favouriteProduct =
            ProductModel.fromJsonShop(responseData['data']['favouriteProduct']);
        notifyListeners();
      }

      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> fetchBlockedShops() async {
    final url = '$host/api/users/blockedShops';

    final uri = Uri.parse(url);
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _blockedShops.clear();
        for (var shop in responseData['data']['blockedShops']) {
          _blockedShops.add(ShopModel.fromJson(shop));
        }
        notifyListeners();
      }
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> changeShopBlockStatus(ShopModel shop, bool blocked) async {
    final url = '$host/api/users/blockedShops';

    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'shopId': shop.id,
          'blocked': blocked,
        }),
      );
      if (response.statusCode == 201) {
        if (blocked) {
          _blockedShops.add(shop);
        } else {
          _blockedShops.removeWhere((element) => element.id == shop.id);
        }
        notifyListeners();
      }

      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> fetchShops() async {
    final url = '$host/api/shops';

    final uri = Uri.parse(url);
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> shops = responseData['data']['shops'];
        _shops.clear();
        for (var shop in shops) {
          _shops.add(ShopModel.fromJson(shop));
        }
        notifyListeners();
      }
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> fetchFavouriteProduct() async {
    final url = '$host/api/users/favourites/product';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data']['favouriteProduct'] != null) {
          _favouriteProduct = ProductModel.fromJsonShop(
              responseData['data']['favouriteProduct']);
        }

        notifyListeners();
      }
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  List<charts.Series<ProductChartModel, String>> getProductChart(
      ProductModel product) {
    List<ProductChartModel> productChart = [];

    for (Snapshot snapshot in product.snapshots) {
      productChart.add(
          ProductChartModel(date: snapshot.updatedAt, price: snapshot.price));
    }
    productChart.sort((a, b) => a.date.compareTo(b.date));
    return [
      charts.Series<ProductChartModel, String>(
        id: 'Snapshots',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white38),
        patternColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (ProductChartModel snapshot, _) =>
            getChartDateFromDateTime(snapshot.date),
        measureFn: (ProductChartModel snapshot, _) => snapshot.price,
        data: productChart,
      )
    ];
  }

  String appendZero(int number) {
    return number < 10 ? '0$number' : '$number';
  }

  String getChartDateFromDateTime(DateTime date) {
    return '${date.year}-${appendZero(date.month)}-${appendZero(date.day)}\n${appendZero(date.hour)}:${appendZero(date.minute)}';
  }

  Future<int> refreshProducts({
    min,
    max,
    name,
    favouritesOnly = false,
  }) async {
    return await getProducts(
        refresh: true,
        min: min,
        max: max,
        name: name,
        favouritesOnly: favouritesOnly);
  }

  Future<int> getProducts(
      {refresh = false,
      min = 0,
      max = 999999,
      name = '',
      favouritesOnly = false}) async {
    int statusCode = 401;
    if (refresh) {
      clearProducts();
    }
    if (shouldFetch) {
      shouldFetch = false;
      if (favouritesOnly) {
        statusCode = await getFavourites();
      }
      statusCode = await getLatestProducts(min: min, max: max, name: name);
    }
    notifyListeners();

    return statusCode;
  }

  Future<int> followProduct(productId) async {
    final url = '$host/api/products/$productId';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      _favourites.clear();
      return await getFavourites();
    }
    return response.statusCode;
  }

  Future<int> unfollowProduct(productId) async {
    final url = '$host/api/products/$productId';
    final uri = Uri.parse(url);
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      _favourites.clear();
      await getFavourites();
    }
    return response.statusCode;
  }

  Future<int> getProductsFromScrapper(
      {min = 0, max = 9000000, name = ''}) async {
    var url = ('$host/api/products/scrapper');
    var uri = Uri.parse(url);

    if (shops.isEmpty) {
      await fetchShops();
    }

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'minPrice': '$min',
          'maxPrice': '$max',
          'productName': name,
          "categoryId": "617432a7df9937b6933d193d",
          "shops": shops.map((e) => e.id).toList(),
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        return response.statusCode;
      }
      for (var i = 0; i < responseData['data']['products'].length; i++) {
        _products.add(
            ProductModel.fromJsonShop(responseData['data']['products'][i]));
      }
      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> getLatestProducts({min = 0, max = 9000000, name = ''}) async {
    var url = ('$host/api/products');
    if (min > 0) {
      url += '?price[gte]=$min';
    }
    if (max < 999999 && max > 0) {
      if (min > 0) {
        url += '&';
      } else {
        url += '?';
      }
      url += 'price[lte]=$max';
    }
    if (name != '') {
      if ((min > 0) || (max < 999999 && max > 0)) {
        url += '&';
      } else {
        url += '?';
      }
      url += 'name=$name';
    }

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
      if (response.statusCode != 200) {
        return response.statusCode;
      }
      for (var i = 0; i < responseData['data']['products'].length; i++) {
        _products.add(
            ProductModel.fromJsonShop(responseData['data']['products'][i]));
      }
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
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

  Future<int> getFavourites() async {
    _favourites.clear();
    var url = Uri.parse('$host/api/users/products');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        return response.statusCode;
      }

      for (var i = 0; i < responseData['data']['products'].length; i++) {
        _favourites.add(
            ProductModel.fromJsonShop(responseData['data']['products'][i]));
      }
      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }
}
