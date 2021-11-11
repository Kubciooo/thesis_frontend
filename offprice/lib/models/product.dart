import 'dart:convert';

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

class _Snapshot {
  final String id;
  final List<String> coupons;
  final List<_OtherPromotions> otherPromotions;
  final double price;
  final DateTime updatedAt;

  _Snapshot(
      {required this.id,
      required this.coupons,
      required this.otherPromotions,
      required this.price,
      required this.updatedAt});

  //json to model object
  factory _Snapshot.fromJson(Map<String, dynamic> json) {
    return _Snapshot(
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

class ProductModel {
  final String id;
  final String url;
  final String name;
  final List<String> categories;
  final List<String> coupons;
  final List<_OtherPromotions> otherPromotions;
  final List<_Snapshot> snapshots;

  ProductModel(
      {required this.id,
      required this.url,
      required this.name,
      required this.categories,
      required this.coupons,
      required this.otherPromotions,
      required this.snapshots});

  //json to model object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      url: json['url'],
      name: json['name'],
      categories: ((json['categories']) as List<dynamic>).cast<String>(),
      coupons: ((json['coupons']) as List<dynamic>).cast<String>(),
      otherPromotions: (json['otherPromotions'] as List<dynamic>)
          .map((promotion) => _OtherPromotions.fromJson(promotion))
          .toList(),
      snapshots: (json['snapshots'] as List<dynamic>)
          .map((snapshot) => _Snapshot.fromJson(snapshot))
          .toList(),
    );
  }
}
