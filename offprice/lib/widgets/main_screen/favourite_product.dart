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
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: provider.fetchFavouriteProduct(),
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
              int statusCode = snapshot.data as int;
              if (statusCode == 401) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              }
              final favouriteProduct =
                  Provider.of<ProductsProvider>(context).favouriteProduct;

              if (!provider.isFavouriteProductSet) {
                return Center(
                  child: Text('No Favourites',
                      style: Theme.of(context).textTheme.headline1),
                );
              }
              final productCharts = provider.getProductChart(favouriteProduct);
              return Expanded(
                child: Column(
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
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Text(
                            favouriteProduct.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Chart(
                      isProductSeries: true,
                      productChart: productCharts,
                    )),
                  ],
                ),
              );
            }),
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
  }
}
