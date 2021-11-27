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
                                    int statusCode = await Provider.of<
                                                ProductsProvider>(context,
                                            listen: false)
                                        .setFavouriteProduct(widget.product);
                                    if (statusCode == 401) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/login', (route) => false);
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
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
                    ExpansionTile(
                      title: Text('Coupons',
                          style: Theme.of(context).textTheme.headline3),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: widget.product.coupons.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(widget.product.coupons[index],
                                  style: Theme.of(context).textTheme.headline3),
                            );
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                        title: Text("Other promotions",
                            style: Theme.of(context).textTheme.headline3),
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: widget.product.otherPromotions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  onTap: () async {
                                    await canLaunch(widget
                                            .product.otherPromotions[index].url)
                                        ? await launch(widget
                                            .product.otherPromotions[index].url)
                                        : print('error');
                                  },
                                  dense: true,
                                  title: Text(
                                    widget.product.otherPromotions[index].name,
                                  ),
                                  subtitle: Text(
                                    widget.product.otherPromotions[index].url,
                                  ));
                            },
                          ),
                        ]),
                    TextButton(
                      onPressed: () async {
                        final int response = _isFollowed
                            ? await Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .unfollowProduct(widget.product.id)
                            : await Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .followProduct(widget.product.id);

                        String text = _isFollowed ? 'Unfollowed' : 'Followed';

                        if (response != 200) {
                          text = 'Error';
                        }

                        Navigator.of(context)
                            .restorablePush(_dialogBuilder, arguments: text);
                        if (response == 200 || response == 201) {
                          changeFollowStatus();
                        } else if (response == 401) {
                          //redirect to login
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
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
