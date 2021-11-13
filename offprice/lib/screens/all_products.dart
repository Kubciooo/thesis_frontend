import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/single_product_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AllProductsScreen> {
  String _name = '';
  int _priceMin = 0;
  int _priceMax = 0;
  bool _favouritesOnly = false;

  final double _width = 0.9;
  final double _height = 0.9;

  void _changeName(String value) {
    setState(() {
      _name = value;
      Provider.of<ProductsProvider>(context, listen: false).refreshProducts(
        name: _name,
        min: _priceMin,
        max: _priceMax,
        favouritesOnly: _favouritesOnly,
      );
    });
  }

  void _useScrapper() {
    // Provider.of<ProductsProvider>(context, listen: false).refreshProducts(
    //   name: _name,
    //   min: _priceMin,
    //   max: _priceMax,
    //   favouritesOnly: _favouritesOnly,
    // );

    Navigator.of(context).restorablePush(_dialogBuilder,
        arguments:
            ScrapperArguments(min: _priceMin, max: _priceMax, name: _name)
                .toMap());
  }

  void _changePriceMin(String value) {
    setState(() {
      if (value != '') {
        _priceMin = int.parse(value);
      } else {
        _priceMin = 0;
      }
      Provider.of<ProductsProvider>(context, listen: false).refreshProducts(
        name: _name,
        min: _priceMin,
        max: _priceMax,
        favouritesOnly: _favouritesOnly,
      );
    });
  }

  void _changeFavouritesOnly(bool value) {
    setState(() {
      _favouritesOnly = value;
      Provider.of<ProductsProvider>(context, listen: false).refreshProducts(
        name: _name,
        min: _priceMin,
        max: _priceMax,
        favouritesOnly: _favouritesOnly,
      );
    });
  }

  void _changePriceMax(String value) {
    setState(() {
      if (value != '') {
        _priceMax = int.parse(value);
      } else {
        _priceMax = 0;
      }
      _priceMax = int.parse(value);
      Provider.of<ProductsProvider>(context, listen: false).refreshProducts(
        name: _name,
        min: _priceMin,
        max: _priceMax,
        favouritesOnly: _favouritesOnly,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            top: 0,
            left: -50,
            right: -50,
            child: SvgPicture.asset(
              'public/images/coinsBackground2.svg',
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              semanticsLabel: 'Background',
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * _width,
              height: MediaQuery.of(context).size.height * _height,
              child: GlassmorphismCard(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'All products',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Show favourites',
                                  style: Theme.of(context).textTheme.headline2),
                              CupertinoSwitch(
                                value: _favouritesOnly,
                                onChanged: _changeFavouritesOnly,
                              ),
                            ],
                          ),
                        ),
                        if (!_favouritesOnly) ...[
                          CupertinoButton(
                              child: Text("Use scraper",
                                  style: Theme.of(context).textTheme.headline2),
                              onPressed: _useScrapper),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            onSubmitted: _changeName,
                            onChanged: (value) => setState(() {
                              _name = value;
                            }),
                          ),
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Price min',
                            ),
                            onSubmitted: _changePriceMin,
                            onChanged: (value) => setState(() {
                              _priceMin = int.parse(value);
                            }),
                          ),
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Price max',
                            ),
                            onSubmitted: _changePriceMax,
                            onChanged: (value) => setState(() {
                              _priceMax = int.parse(value);
                            }),
                          ),
                        ],
                      ]),
                      ProductsList(
                          favouritesOnly: _favouritesOnly,
                          onProductSelected: (product) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProductScreen(product: product),
                                ));
                          },
                          name: _name,
                          priceMin: _priceMin,
                          priceMax: _priceMax == 0 ? 999999 : _priceMax),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  final args = ScrapperArguments.fromMap(arguments as Map<String, dynamic>);
  return CupertinoDialogRoute<void>(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder(
          future: Provider.of<ProductsProvider>(context, listen: false)
              .getProductsFromScrapper(
                  min: args.min, max: args.max, name: args.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Error: ${snapshot.error}',
              ));
            }
            return CupertinoAlertDialog(
              title: const Text(
                  'Products scrapped! Now you can refresh your search'),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    }),
              ],
            );
          });
    },
  );
}

class ScrapperArguments {
  final int min;
  final int max;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
      'name': name,
    };
  }

  factory ScrapperArguments.fromMap(Map<String, dynamic> map) {
    return ScrapperArguments(
      min: map['min'] as int,
      max: map['max'] as int,
      name: map['name'] as String,
    );
  }

  ScrapperArguments({required this.min, required this.max, required this.name});
}
