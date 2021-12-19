import 'package:offprice/models/shop.dart';

/// model dla listy innych promocji produktu
class _OtherPromotions {
  final String name;
  final String id;
  final String url;

  _OtherPromotions({this.name = '', required this.id, this.url = ''});

  factory _OtherPromotions.fromJson(Map<String, dynamic> json) {
    return _OtherPromotions(
      name: json['name'] ?? '',
      id: json['_id'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

/// model dla danych historycznych produktu
class Snapshot {
  final String id;
  final List<String> coupons;
  final List<_OtherPromotions> otherPromotions;
  final double price;
  final DateTime updatedAt;

  Snapshot(
      {required this.id,
      required this.coupons,
      required this.otherPromotions,
      required this.price,
      required this.updatedAt});

  // model z jsona
  factory Snapshot.fromJson(Map<String, dynamic> json) {
    return Snapshot(
      id: json['_id'],
      coupons: ((json['coupons']) as List<dynamic>).cast<String>(),
      otherPromotions: (json['otherPromotions'] as List<dynamic>)
          .map((promotion) => _OtherPromotions.fromJson(promotion))
          .toList(),
      price: json['price'].toDouble(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

/// model dla folderu produktów
class FoldersModel {
  final String name;
  final String id;
  final List<ProductModel> products;

  FoldersModel({required this.id, required this.name, required this.products});

  // json to model
  factory FoldersModel.fromJson(Map<String, dynamic> json) {
    return FoldersModel(
      id: json['_id'],
      name: json['name'],
      products: (json['products'] as List<dynamic>)
          .map((product) => ProductModel.fromJsonShop(product))
          .toList(),
    );
  }
}

/// model produktu
class ProductModel {
  final String id;
  final String url;
  final String name;
  final double price;
  final String shop;
  final List<String> categories;
  final List<String> coupons;
  final List<_OtherPromotions> otherPromotions;
  final List<Snapshot> snapshots;

  ProductModel(
      {required this.id,
      required this.url,
      required this.name,
      required this.price,
      required this.shop,
      required this.categories,
      required this.coupons,
      required this.otherPromotions,
      required this.snapshots});

  /// tworzenie modelu z jsona z listą sklepów jako listą ID
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      url: json['url'],
      name: json['name'],
      price: json['price'].toDouble(),
      shop: json['shop'],
      categories: ((json['categories']) as List<dynamic>).cast<String>(),
      coupons: ((json['coupons']) as List<dynamic>).cast<String>(),
      otherPromotions: (json['otherPromotions'] as List<dynamic>)
          .map((promotion) => _OtherPromotions.fromJson(promotion))
          .toList(),
      snapshots: (json['snapshots'] as List<dynamic>)
          .map((snapshot) => Snapshot.fromJson(snapshot))
          .toList(),
    );
  }

  /// tworzenie modelu z jsona z listą sklepów jako listą obiektów
  factory ProductModel.fromJsonShop(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      url: json['url'],
      name: json['name'],
      price: json['price'].toDouble(),
      shop: ShopModel.fromJson(json['shop']).name,
      categories: ((json['categories']) as List<dynamic>).cast<String>(),
      coupons: ((json['coupons']) as List<dynamic>).cast<String>(),
      otherPromotions: (json['otherPromotions'] as List<dynamic>)
          .map((promotion) => _OtherPromotions.fromJson(promotion))
          .toList(),
      snapshots: (json['snapshots'] as List<dynamic>)
          .map((snapshot) => Snapshot.fromJson(snapshot))
          .toList(),
    );
  }
}
