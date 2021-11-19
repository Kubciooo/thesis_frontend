import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/screens/add_promotion_next.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';

class AddPromotionScreen extends StatefulWidget {
  const AddPromotionScreen({Key? key}) : super(key: key);

  @override
  State<AddPromotionScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AddPromotionScreen> {
  String _name = '';
  int _priceMin = 0;
  int _priceMax = 0;

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

  void _changePriceMax(String value) {
    if (value != '') {
      _priceMax = int.parse(value);
    } else {
      _priceMax = 9999999;
    }
    _priceMaxController.add(_priceMax);
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
                      Column(children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Name',
                          ),
                          onSubmitted: _changeName,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Price min',
                          ),
                          onSubmitted: _changePriceMin,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Price max',
                          ),
                          onSubmitted: _changePriceMax,
                        ),
                      ]),
                      ProductsList(
                          onProductSelected: (product) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddPromotionNext(product: product),
                                ));
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
