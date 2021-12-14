import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/all_products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

class FavouriteProduct extends StatelessWidget {
  const FavouriteProduct({Key? key}) : super(key: key);

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
                Provider.of<AuthProvider>(context, listen: false).logout();
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false);
                });
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
                      child: productCharts.first.data.isNotEmpty
                          ? Chart(
                              isProductSeries: true,
                              productChart: productCharts,
                            )
                          : Center(
                              child: Text(
                                'No snapshots found...',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AllProductsScreen.routeName);
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
