import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:offprice/constants/api.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/models/product_chart.dart';
import 'package:offprice/providers/auth.dart';

class FoldersProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  bool shouldFetch = true;
  final List<UserProductsModel> _folders = [];
  get token => _token;

  void update(AuthProvider auth) {
    _token = auth.token;
  }

  List<UserProductsModel> get folders {
    return [..._folders];
  }

  void clearFolders() {
    _folders.clear();
    shouldFetch = true;
  }

  List<charts.Series<FolderChartModel, String>> getFolderChart(
      UserProductsModel folder) {
    List<FolderChartModel> folderChart = folder.products.map((product) {
      return FolderChartModel(price: product.price, shop: product.shop);
    }).toList();
    return [
      charts.Series<FolderChartModel, String>(
        id: 'Promotions',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white38),
        patternColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (FolderChartModel folder, _) => folder.shop,
        measureFn: (FolderChartModel folder, _) => folder.price,
        data: folderChart,
      )
    ];
  }

  Future<void> createFolder(String name, List<ProductModel> products) async {
    var url = ('$host/api/userProducts');

    var uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'products': products.map((product) => product.id).toList()
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      _folders.add(
          UserProductsModel.fromJson(responseData['data']['userProducts']));

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteFolder(String id) async {
    var url = ('$host/api/userProducts/$id');

    var uri = Uri.parse(url);

    try {
      final response = await http.delete(
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

      _folders.removeWhere((folder) => folder.id == id);

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeProductFromFolder(
      String folderId, String productId) async {
    var url = ('$host/api/userProducts/$folderId');

    var uri = Uri.parse(url);

    try {
      final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{'productId': productId}),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      _folders
          .firstWhere((folder) => folder.id == folderId)
          .products
          .removeWhere((product) => product.id == productId);

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProductToFolder(String folderId, String productId) async {
    var url = ('$host/api/userProducts/$folderId');

    var uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{'productId': productId}),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      _folders.firstWhere((folder) => folder.id == folderId).products.add(
          ProductModel.fromJsonShop(
              responseData['data']['userProducts']['products']));

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchFolders() async {
    var url = ('$host/api/userProducts');

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
      clearFolders();
      for (var folder in responseData['data']['userProducts']) {
        _folders.add(UserProductsModel.fromJson(folder));
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
