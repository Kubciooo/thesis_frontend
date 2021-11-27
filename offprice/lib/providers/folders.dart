import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:offprice/constants/api.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/models/product_chart.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/utils/add_endlines_to_string.dart';

class FoldersProvider with ChangeNotifier {
  // create a function to login user via api with url and body
  String _token = '';
  bool shouldFetch = true;
  UserProductsModel _favouriteFolder =
      UserProductsModel(id: '', name: 'Favourite', products: []);
  final List<UserProductsModel> _folders = [];
  get token => _token;

  get isFavouriteFolderSet => _favouriteFolder.id != '';

  get favouriteFolder => _favouriteFolder;

  void update(AuthProvider auth) {
    _token = auth.token;
    shouldFetch = true;
    _favouriteFolder =
        UserProductsModel(id: '', name: 'Favourite', products: []);
    _folders.clear();
    notifyListeners();
  }

  bool isFavourite(UserProductsModel folder) {
    return folder.id == _favouriteFolder.id;
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
      return FolderChartModel(
          price: product.price, shop: product.shop, name: product.name);
    }).toList();
    return [
      charts.Series<FolderChartModel, String>(
        id: 'Promotions',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.white38),
        patternColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (FolderChartModel folder, _) =>
            '${addEndlinesToString(folder.name, 10)}\n${folder.shop}',
        measureFn: (FolderChartModel folder, _) => folder.price,
        data: folderChart,
      )
    ];
  }

  Future<int> setFavouriteFolder(UserProductsModel folder) async {
    final url = '$host/api/users/favourites/folder';

    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{
          'folderId': folder.id,
        }),
      );
      if (response.statusCode == 201) {
        final folderData = json.decode(response.body);
        _favouriteFolder = UserProductsModel.fromJson(
            folderData['data']['favouriteUserProducts']);
        notifyListeners();
      } else {
        throw HttpException(json.decode(response.body)['message']);
      }
      return response.statusCode;
    } catch (err) {
      return 500;
    }
  }

  Future<int> fetchFavouriteFolder() async {
    final url = '$host/api/users/favourites/folder';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data']['favouriteUserProducts'] != null) {
          _favouriteFolder = UserProductsModel.fromJson(
              responseData['data']['favouriteUserProducts']);
        }

        notifyListeners();
      } else {
        print(json.decode(response.body)['message']);
      }
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> createFolder(String name, List<String> products) async {
    var url = ('$host/api/userProducts');

    var uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{'name': name, 'products': products}),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      _folders.add(
          UserProductsModel.fromJson(responseData['data']['userProducts']));

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> deleteFolder(String id) async {
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
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> removeProductFromFolder(String folderId, String productId) async {
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
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> addProductToFolder(String folderId, String productId) async {
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
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> fetchFolders() async {
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

      if (response.statusCode != 200) return response.statusCode;
      clearFolders();
      for (var folder in responseData['data']['userProducts']) {
        _folders.add(UserProductsModel.fromJson(folder));
      }

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }
}
