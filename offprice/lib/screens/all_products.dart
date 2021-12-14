import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/screens/single_product_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/all-products';

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  String _name = '';

  int _priceMin = 0;

  int _priceMax = 999999;

  bool _favouritesOnly = false;

  final StreamController<String> _nameController = StreamController<String>();

  final StreamController<int> _priceMinController = StreamController<int>();

  final StreamController<int> _priceMaxController = StreamController<int>();

  final StreamController<bool> _favouritesOnlyController =
      StreamController<bool>();

  final double _width = 0.9;

  final double _height = 0.9;

  void _changeName(String value) {
    _name = value;
    _nameController.add(_name);
  }

  void _changePriceMin(String value) {
    if (value != '') {
      _priceMin = int.parse(value);
    } else {
      _priceMin = 0;
    }
    _priceMinController.add(_priceMin);
  }

  void _changeFavouritesOnly(bool value) {
    setState(() {
      _favouritesOnly = value;
      _favouritesOnlyController.add(_favouritesOnly);
    });
  }

  void _changePriceMax(String value) {
    _priceMax = int.parse(value);
    _priceMaxController.add(_priceMax);
  }

  @override
  Widget build(BuildContext context) {
    void _useScrapper() {
      Navigator.of(context).restorablePush(_dialogBuilder,
          arguments:
              ScrapperArguments(min: _priceMin, max: _priceMax, name: _name)
                  .toMap());
    }

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
                          TextFieldDark(
                            hintText: 'Name',
                            onChanged: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            initialValue: _name,
                            icon: const Icon(Icons.search),
                            labelText: 'Name',
                            onEditingCompleted: (value) {
                              _changeName(value);
                            },
                          ),
                          TextFieldDark(
                            hintText: 'Price min',
                            onChanged: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a number';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a number';
                              } else {
                                final valueInt = int.parse(value);
                                if (valueInt < 0) {
                                  return 'Please enter a number greater than 0';
                                }
                              }
                              return null;
                            },
                            initialValue: _priceMin.toString(),
                            icon: const Icon(Icons.attach_money),
                            labelText: 'Price min',
                            onEditingCompleted: (value) {
                              _changePriceMin(value);
                            },
                          ),
                          TextFieldDark(
                            hintText: 'Price max',
                            onChanged: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a number';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a number';
                              } else {
                                final valueInt = int.parse(value);
                                if (valueInt < 0) {
                                  return 'Please enter a number greater than 0';
                                }
                              }
                              return null;
                            },
                            initialValue: _priceMax.toString(),
                            icon: const Icon(Icons.attach_money),
                            labelText: 'Price Max',
                            onEditingCompleted: (value) {
                              _changePriceMax(value);
                            },
                          ),
                        ],
                      ]),
                      ProductsList(
                          favouritesOnly: _favouritesOnlyController.stream,
                          onProductSelected: (product) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProductScreen(product: product),
                                ));
                          },
                          name: _nameController.stream,
                          priceMin: _priceMinController.stream,
                          priceMax: _priceMaxController.stream),
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
            int statusCode = snapshot.data as int;

            if (statusCode == 401) {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            }
            return CupertinoAlertDialog(
              title: const Text(
                  'Products scrapped! Now you can refresh your search'),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
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
