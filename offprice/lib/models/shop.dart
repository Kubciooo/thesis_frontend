/// model sklepu
class ShopModel {
  final String name;
  final String id;
  final String mainUrl;

  ShopModel({required this.name, required this.id, required this.mainUrl});

  /// zwraca obiekt ShopModel z danymi z jsona
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      name: json['name'],
      id: json['_id'],
      mainUrl: json['mainUrl'],
    );
  }
}
