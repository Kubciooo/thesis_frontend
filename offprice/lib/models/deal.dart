import 'package:offprice/models/product.dart';

class DealModel {
  final String id;
  final String type;
  final ProductModel product;
  final double startingPrice;
  final int rating;
  final String discountType;
  final String coupon;
  final double cash;
  final int percent;
  final DateTime startsAt;
  final DateTime expiresAt;

  const DealModel({
    required this.id,
    required this.type,
    required this.startingPrice,
    required this.rating,
    required this.discountType,
    required this.startsAt,
    required this.product,
    required this.expiresAt,
    this.coupon = '',
    this.cash = 0,
    this.percent = 0,
  });

  double get finalPrice {
    if (discountType == 'CASH') {
      return startingPrice - cash;
    } else {
      return startingPrice - (startingPrice * percent / 100);
    }
  }

  // json to model
  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['_id'],
      type: json['type'],
      startingPrice: json['startingPrice'].toDouble(),
      discountType: json['discountType'],
      rating: json['rating'],
      coupon: json['coupon'] ?? '',
      cash: json['cash'] != null ? json['cash'].toDouble() : 0.0,
      percent: json['percentage'] != null ? json['percentage'] : 0,
      startsAt: DateTime.parse(json['startsAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      product: ProductModel.fromJson(json['product']),
    );
  }
}
