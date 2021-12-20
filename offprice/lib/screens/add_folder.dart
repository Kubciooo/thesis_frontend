import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:provider/provider.dart';

/// Widok odpowiedzialny za dodawanie nowego folderu
class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({Key? key}) : super(key: key);
  static const routeName = '/add-folder';

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final _formKey = GlobalKey<FormState>();
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
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax)
          .then((statusCode) => {
                if (statusCode == 401)
                  {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, ModalRoute.withName('/'));
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    })
                  }
              });
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
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax)
          .then((statusCode) => {
                if (statusCode == 401)
                  {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, ModalRoute.withName('/'));
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    })
                  }
              });
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
          .refreshProducts(name: _name, min: _priceMin, max: _priceMax)
          .then((statusCode) => {
                if (statusCode == 401)
                  {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, ModalRoute.withName('/'));
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                    })
                  }
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            int statusCode =
                await Provider.of<FoldersProvider>(context, listen: false)
                    .createFolder(_folderName, _products);

            if (statusCode == 401) {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, ModalRoute.withName('/'));
                Provider.of<AuthProvider>(context, listen: false).logout();
              });
            } else if (statusCode == 201) {
              Navigator.of(context).pop();
            }
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.colorBackground[900],
        focusColor: AppColors.colorBackground[900],
      ),
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
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Folder name',
                              prefixIcon: Icon(Icons.folder),
                            ),
                            onChanged: _changeFolderName,
                          ),
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
                              int statusCode =
                                  await Provider.of<ProductsProvider>(context,
                                          listen: false)
                                      .refreshProducts(
                                name: _name,
                                min: _priceMin,
                                max: _priceMax,
                              );
                              if (statusCode == 401) {
                                Future.delayed(Duration.zero, () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      LoginScreen.routeName,
                                      ModalRoute.withName('/'));
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logout();
                                });
                              }
                            },
                            child: ListView.builder(
                                itemCount: provider.products.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                      activeColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      title:
                                          Text(provider.products[index].name),
                                      value: _products.contains(
                                          provider.products[index].id),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _products.add(
                                                provider.products[index].id);
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
