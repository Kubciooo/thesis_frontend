import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/add_promotion_next.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/products_list.dart';
import 'package:provider/provider.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  String _folderName = '';
  final List<String> _products = [];
  String _name = '';
  int _priceMin = 0;
  int _priceMax = 9999999;

  final double _width = 0.9;
  final double _height = 0.9;

  void _changeFolderName(String value) {
    setState(() {
      _folderName = value;
    });
  }

  void _changeName(String value) {
    setState(() {
      _name = value;
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
    });
  }

  void _changePriceMin(String value) {
    setState(() {
      if (value != '') {
        _priceMin = int.parse(value);
      } else {
        _priceMin = 0;
      }
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
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
      Provider.of<ProductsProvider>(context, listen: false)
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
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
                            hintText: 'Folder name',
                            prefixIcon: Icon(Icons.folder),
                          ),
                          onChanged: _changeFolderName,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
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
                      Expanded(
                        child: RefreshIndicator(
                            onRefresh: () async {
                              Provider.of<ProductsProvider>(context,
                                      listen: false)
                                  .refreshProducts(
                                name: _name,
                                min: _priceMin,
                                max: _priceMax,
                              );
                            },
                            child: ListView.builder(
                                itemCount: provider.products.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                      title:
                                          Text(provider.products[index].name),
                                      value: _products.contains(
                                          provider.products[index].id),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _products.add(
                                                provider.products[index].id);
                                            print(_products);
                                            print('xd');
                                          } else {
                                            _products.remove(
                                                provider.products[index].id);
                                          }
                                        });
                                      });
                                })),
                      ),
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
