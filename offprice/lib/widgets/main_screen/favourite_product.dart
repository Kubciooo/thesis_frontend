import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

class FavouriteProduct extends StatelessWidget {
  FavouriteProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .getFavourites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final favourites =
              Provider.of<ProductsProvider>(context, listen: false).favourites;

          if (favourites.isEmpty) {
            return Center(
              child: Text('No Favourites',
                  style: Theme.of(context).textTheme.headline1),
            );
          }
          final productCharts =
              Provider.of<ProductsProvider>(context, listen: false)
                  .getProductChart(favourites[0]);
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      'FAVOURITE',
                      gradient: AppColors.mainLinearGradient,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      Provider.of<ProductsProvider>(context, listen: false)
                          .favourites[0]
                          .name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Chart(
                productChart: productCharts,
              )),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/all-products');
                },
                child: Text(
                  'Show more',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          );
        });
  }
}
