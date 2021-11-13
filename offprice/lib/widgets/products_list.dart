import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/products.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  final String name;
  final int priceMin;
  final int priceMax;
  final bool favouritesOnly;
  final bool useScrapper;

  final Function onProductSelected;
  const ProductsList({
    this.name = '',
    this.priceMax = 999999999,
    this.priceMin = 0,
    this.favouritesOnly = false,
    this.useScrapper = false,
    required this.onProductSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: true)
              .getProducts(
                  name: widget.name,
                  min: widget.priceMin,
                  favouritesOnly: widget.favouritesOnly,
                  max: widget.priceMax),
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

            final List<ProductModel> products =
                snapshot.data as List<ProductModel>;

            return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .refreshProducts(
                        min: widget.priceMin,
                        max: widget.priceMax,
                        favouritesOnly: widget.favouritesOnly,
                        name: widget.name);
              },
              child: ListView.builder(
                // shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () => widget.onProductSelected(products[index]),
                    title: Text(products[index].name,
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(fontSize: 15)),
                    subtitle: Text(
                        '${products[index].price.toStringAsFixed(2)} PLN',
                        style: Theme.of(context).textTheme.subtitle1),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 27,
                    ),
                  );
                },
                itemCount: products.length,
              ),
            );
          }),
    );
  }
}
