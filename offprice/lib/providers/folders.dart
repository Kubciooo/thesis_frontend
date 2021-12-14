// ignore_for_file: avoid_print

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
  String _token = '';
  bool shouldFetch = true;
  FoldersModel _favouriteFolder =
      FoldersModel(id: '', name: 'Favourite', products: []);
  final List<FoldersModel> _folders = [];
  get token => _token;

  get isFavouriteFolderSet => _favouriteFolder.id != '';

  get favouriteFolder => _favouriteFolder;

  void update(AuthProvider auth) {
    _token = auth.token;
    shouldFetch = true;
    _favouriteFolder = FoldersModel(id: '', name: 'Favourite', products: []);
    _folders.clear();
    notifyListeners();
  }

  bool isFavourite(FoldersModel folder) {
    return folder.id == _favouriteFolder.id;
  }

  List<FoldersModel> get folders {
    return [..._folders];
  }

  void clearFolders() {
    _folders.clear();
    shouldFetch = true;
  }

  List<charts.Series<FolderChartModel, String>> getFolderChart(
      FoldersModel folder) {
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

  Future<int> setFavouriteFolder(FoldersModel folder) async {
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
        _favouriteFolder =
            FoldersModel.fromJson(folderData['data']['favouriteFolder']);
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

        if (responseData['data']['favouriteFolder'] != null) {
          _favouriteFolder =
              FoldersModel.fromJson(responseData['data']['favouriteFolder']);
        }

        notifyListeners();
      }
      return response.statusCode;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<int> createFolder(String name, List<String> products) async {
    var url = ('$host/api/folders');

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
      _folders.add(FoldersModel.fromJson(responseData['data']['folder']));

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> deleteFolder(String id) async {
    var url = ('$host/api/folders/$id');

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
      if (favouriteFolder.id == id) {
        _favouriteFolder =
            FoldersModel(id: '', name: 'Favourite', products: []);
      }

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> removeProductFromFolder(String folderId, String productId) async {
    var url = ('$host/api/folders/$folderId');

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

  Future<int> addProductToFolder(String folderId, ProductModel product) async {
    var url = ('$host/api/folders/$folderId');

    var uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token,
        },
        body: jsonEncode(<String, dynamic>{'productId': product.id}),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'error') {
        throw HttpException(responseData['message']);
      }

      _folders
          .firstWhere((folder) => folder.id == folderId)
          .products
          .add(product);

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<int> fetchFolders() async {
    var url = ('$host/api/folders');

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
      for (var folder in responseData['data']['folders']) {
        _folders.add(FoldersModel.fromJson(folder));
      }

      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }
}
