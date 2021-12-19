/// model produktu do wyświetlenia diagramu
class ProductChartModel {
  final DateTime date;
  final double price;

  ProductChartModel({required this.date, required this.price});
}

/// model folderu do wyświetlenia diagramu
class FolderChartModel {
  final String shop;
  final double price;
  final String name;

  FolderChartModel(
      {required this.shop, required this.price, required this.name});
}
