// import 'package:charts_common/common.dart' as chartsCommon;
// import 'package:charts_common/src/data/series.dart' show AccessorFn;
import 'dart:math';

//   tooltip.dart
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:offprice/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> productChart;
  final bool isProductSeries;
  static String pointerValue = '';
  const Chart(
      {Key? key, required this.productChart, this.isProductSeries = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      productChart,
      animate: true,
      primaryMeasureAxis: const charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.white,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.white,
            ),
          ),
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 10)),
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            pointerValue = '${model.selectedDatum[0].datum.price}';
          }
        })
      ],
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport(
            isProductSeries
                ? Provider.of<ProductsProvider>(context, listen: false)
                    .getChartDateFromDateTime(productChart[0]
                        .data[productChart[0].data.length - 1]
                        .date)
                : 'AePs',
            3),
        renderSpec: const charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.MaterialPalette.white,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      rtlSpec:
          const charts.RTLSpec(axisDirection: charts.AxisDirection.reversed),
      behaviors: [
        charts.LinePointHighlighter(
            symbolRenderer: CustomCircleSymbolRenderer()),
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

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    ChartStyle.TextStyle textStyle = ChartStyle.TextStyle();

    textStyle.color = Color.white;
    textStyle.fontSize = 18;
    canvas.drawText(ChartText.TextElement(Chart.pointerValue, style: textStyle),
        (bounds.left).round(), (bounds.top - 28).round());
  }
}
