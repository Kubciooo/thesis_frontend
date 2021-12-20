import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/screens/add_promotion_next.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';

/// Widok wybierania produktu do stworzenia promocji
class AddPromotionScreen extends StatefulWidget {
  const AddPromotionScreen({Key? key}) : super(key: key);
  static const String routeName = '/add-promotion';

  @override
  State<AddPromotionScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AddPromotionScreen> {
  int _priceMin = 0;
  int _priceMax = 99999999;
  String _name = '';

  final StreamController<String> _nameController = StreamController<String>();
  final StreamController<int> _priceMinController = StreamController<int>();
  final StreamController<int> _priceMaxController = StreamController<int>();
  final StreamController<bool> _favouritesOnlyController =
      StreamController<bool>();

  final double _width = 0.9;
  final double _height = 0.9;
  final _formKey = GlobalKey<FormState>();

  void _changeName(String value) {
    _name = value;
  }

  void _changePriceMin(String value) {
    if (value != '') {
      _priceMin = int.parse(value);
    } else {
      _priceMin = 0;
    }
  }

  void _changePriceMax(String value) {
    if (value != '') {
      _priceMax = int.parse(value);
    } else {
      _priceMax = 9999999;
    }
  }

  void _restart() {
    if (_formKey.currentState!.validate()) {
      _priceMaxController.add(_priceMax);
      _nameController.add(_name);
    }
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
              'public/images/fireBackground.svg',
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
                        'Choose product',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            autocorrect: false,
                            key: const Key('name'),
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            onChanged: _changeName,
                            onEditingComplete: () {
                              if (_formKey.currentState!.validate()) {
                                _nameController.add(_name);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            autocorrect: false,
                            key: const Key('priceMin'),
                            initialValue: _priceMin.toString(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Price min',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (int.parse(value) < 0) {
                                return 'Please enter a positive number';
                              }
                              return null;
                            },
                            onChanged: _changePriceMin,
                            onEditingComplete: () {
                              if (_formKey.currentState!.validate()) {
                                _priceMinController.add(_priceMin);
                              }
                            },
                          ),
                          TextFormField(
                            autocorrect: false,
                            key: const Key('priceMax'),
                            initialValue: _priceMax.toString(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Price max',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (int.parse(value) < 0) {
                                return 'Please enter a positive number';
                              }
                              if (int.parse(value) < _priceMin) {
                                return 'Please enter a number greater than $_priceMin';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              if (_formKey.currentState!.validate()) {
                                _priceMaxController.add(_priceMax);
                              }
                            },
                            onChanged: _changePriceMax,
                          ),
                        ]),
                      ),
                      ProductsList(
                          key: const Key('productsList'),
                          onProductSelected: (product) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddPromotionNext(product: product),
                              ),
                            );
                          },
                          name: _nameController.stream,
                          priceMin: _priceMinController.stream,
                          priceMax: _priceMaxController.stream,
                          favouritesOnly: _favouritesOnlyController.stream),
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
