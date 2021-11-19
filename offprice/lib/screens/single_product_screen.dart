import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:offprice/widgets/settings_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleProductScreen extends StatefulWidget {
  final ProductModel product;

  const SingleProductScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<SingleProductScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<SingleProductScreen> {
  late bool _isFollowed;
  @override
  void initState() {
    super.initState();
    _isFollowed = Provider.of<ProductsProvider>(context, listen: false)
        .isFollowed(widget.product.id);
  }

  void changeFollowStatus() {
    setState(() {
      _isFollowed = !_isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productCharts = Provider.of<ProductsProvider>(context, listen: false)
        .getProductChart(widget.product);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -100,
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
            child: GlassmorphismCard(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientText(
                                  'Product',
                                  gradient: AppColors.mainLinearGradient,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  widget.product.name,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 25,
                                      ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(widget.product.shop,
                                    style:
                                        Theme.of(context).textTheme.headline3),
                                OutlinedButton(
                                  onPressed: () async {
                                    await canLaunch(widget.product.url)
                                        ? await launch(widget.product.url)
                                        : print('error');
                                  },
                                  child: Text('Open in browser',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                ),
                              ],
                            ),
                          ),
                          SettingsButton(
                            title: 'Product settings',
                            actions: [
                              if (!Provider.of<ProductsProvider>(context)
                                  .isFavorite(widget.product))
                                TextButton(
                                  child: const Text('Mark as favourite'),
                                  onPressed: () async {
                                    await Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .setFavouriteProduct(widget.product);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              TextButton(
                                child: const Text('Delete product'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
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
                              )),
                    TextButton(
                      onPressed: () async {
                        final String response = _isFollowed
                            ? await Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .unfollowProduct(widget.product.id)
                            : await Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .followProduct(widget.product.id);

                        Navigator.of(context).restorablePush(_dialogBuilder,
                            arguments: response);
                        if (!response.contains('Failed')) {
                          changeFollowStatus();
                        }
                      },
                      child: Text(
                        _isFollowed ? 'Unfollow' : 'Follow',
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  return CupertinoDialogRoute<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(arguments.toString()),
        actions: <Widget>[
          CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}
