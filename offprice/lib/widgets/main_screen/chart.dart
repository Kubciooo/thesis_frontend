import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> productChart;
  final bool isProductSeries;
  const Chart(
      {Key? key, required this.productChart, this.isProductSeries = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      productChart,
      animate: true,
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.colorBackground[700],
                duration: const Duration(seconds: 1),
                content: Text(
                  '${model.selectedDatum[0].datum.price}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 20,
                      ),
                ),
              ),
            );
          }
        })
      ],
      domainAxis: charts.OrdinalAxisSpec(
        viewport: charts.OrdinalViewport(
            isProductSeries
                ? Provider.of<ProductsProvider>(context)
                    .getChartDateFromDateTime(productChart[0]
                        .data[productChart[0].data.length - 1]
                        .date)
                : 'AePs',
            3),
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
      rtlSpec:
          const charts.RTLSpec(axisDirection: charts.AxisDirection.reversed),
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
        if (isProductSeries)
          charts.InitialSelection(selectedDataConfig: [
            charts.SeriesDatumConfig(
              'Snapshots', // This is the name of the series
              Provider.of<ProductsProvider>(context).getChartDateFromDateTime(
                  productChart[0]
                      .data[productChart[0].data.length - 1]
                      .date), // This is the index of the datum in the series
            ),
          ]),
        charts.SlidingViewport(),

        // charts.PanAndZoomBehavior(),
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
