import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/products.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  final Stream<String> name;
  final Stream<int> priceMin;
  final Stream<int> priceMax;
  final Stream<bool> favouritesOnly;

  final Function onProductSelected;
  const ProductsList({
    required this.name,
    required this.priceMax,
    required this.priceMin,
    required this.favouritesOnly,
    required this.onProductSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  String name = '';
  int priceMin = 0;
  int priceMax = 9999999999;
  bool favouritesOnly = false;
  @override
  void initState() {
    super.initState();

    widget.favouritesOnly.listen((bool event) async {
      favouritesOnly = event;
      int statusCode =
          await Provider.of<ProductsProvider>(context, listen: false)
              .refreshProducts(
                  min: priceMin,
                  max: priceMax,
                  favouritesOnly: favouritesOnly,
                  name: name);
      if (statusCode == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });

    widget.name.listen((String event) async {
      name = event;
      int statusCode =
          await Provider.of<ProductsProvider>(context, listen: false)
              .refreshProducts(
                  min: priceMin,
                  max: priceMax,
                  favouritesOnly: favouritesOnly,
                  name: name);
      if (statusCode == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });

    widget.priceMin.listen((int event) async {
      priceMin = event;
      int statusCode =
          await Provider.of<ProductsProvider>(context, listen: false)
              .refreshProducts(
                  min: priceMin,
                  max: priceMax,
                  favouritesOnly: favouritesOnly,
                  name: name);
      if (statusCode == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });

    widget.priceMax.listen((int event) async {
      priceMax = event;
      int statusCode =
          await Provider.of<ProductsProvider>(context, listen: false)
              .refreshProducts(
                  min: priceMin,
                  max: priceMax,
                  favouritesOnly: favouritesOnly,
                  name: name);
      if (statusCode == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .getProducts(
                  name: name,
                  min: priceMin,
                  favouritesOnly: favouritesOnly,
                  max: priceMax),
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

            List<ProductModel> products = favouritesOnly
                ? Provider.of<ProductsProvider>(context).favourites
                : Provider.of<ProductsProvider>(context).products;
            return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<ProductsProvider>(context, listen: false)
                    .refreshProducts(
                        min: priceMin,
                        max: priceMax,
                        favouritesOnly: favouritesOnly,
                        name: name);
              },
              child: ListView.builder(
                // shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: const Key("Product list tile"),
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
