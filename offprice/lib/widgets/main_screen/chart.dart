import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:offprice/models/product_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Chart extends StatelessWidget {
  final List<charts.Series<ProductChartModel, String>> productChart;
  const Chart({Key? key, required this.productChart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      productChart,
      animate: true,
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection)
            print((model.selectedDatum[0].datum as ProductChartModel).date);
        })
      ],
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport('AePS', 3),
        renderSpec: const charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),
      ],
      defaultRenderer: charts.BarRendererConfig(
          fillPattern: charts.FillPatternType.solid,
          // By default, bar renderer will draw rounded bars with a constant
          // radius of 100.
          // To not have any rounded corners, use [NoCornerStrategy]
          // To change the radius of the bars, use [ConstCornerStrategy]
          cornerStrategy: const charts.ConstCornerStrategy(10)),
    );
  }
}
