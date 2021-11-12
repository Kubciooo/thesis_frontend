import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

class AddPromotionScreen extends StatefulWidget {
  const AddPromotionScreen({Key? key}) : super(key: key);

  @override
  State<AddPromotionScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AddPromotionScreen> {
  String _name = '';
  int _priceMin = 0;
  int _priceMax = 0;

  final _formKey = GlobalKey<FormState>();

  final double _width = 0.9;
  final double _height = 0.9;

  void _changeName(String value) {
    setState(() {
      _name = value;
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
    });
  }

  void _changePriceMin(String value) {
    setState(() {
      _priceMin = int.parse(value);
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
    });
  }

  void _changePriceMax(String value) {
    setState(() {
      _priceMax = int.parse(value);
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
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
