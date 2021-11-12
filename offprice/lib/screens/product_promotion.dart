import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/models/deal.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPromotionScreen extends StatefulWidget {
  final DealModel productPromotion;
  ProductPromotionScreen({Key? key, required this.productPromotion})
      : super(key: key);

  @override
  _ProductPromotionScreenState createState() => _ProductPromotionScreenState();
}

class _ProductPromotionScreenState extends State<ProductPromotionScreen> {
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = Provider.of<PromotionsProvider>(context, listen: false)
        .isFollowed(widget.productPromotion.id);
  }

  void changeFollowStatus() {
    setState(() {
      _isFollowed = !_isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorBackground[800],
        body: Stack(
          children: [
            Positioned(
              top: 30,
              right: 30,
              child: IconButton(
                alignment: Alignment.center,
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                ),
                color: Colors.white,
              ),
            ),
            Center(
                child: Container(
              padding: const EdgeInsets.all(30.0),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // spacing: 30,
                // direction: Axis.vertical,
                children: [
                  Text(
                    widget.productPromotion.product.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 26),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LabeledText(
                      label: 'Promotion type',
                      text: widget.productPromotion.discountType),
                  if (widget.productPromotion.discountType == 'PERCENTAGE')
                    LabeledText(
                        label: 'Discount',
                        text: '${widget.productPromotion.percent.toString()}%'),
                  if (widget.productPromotion.discountType == 'CASH')
                    LabeledText(
                        label: 'Discount',
                        text: '${widget.productPromotion.cash.toString()} PLN'),
                  if (widget.productPromotion.type == 'COUPON')
                    LabeledText(
                        label: 'Coupon Code',
                        text: widget.productPromotion.coupon),
                  LabeledText(
                      label: 'Starting price',
                      text:
                          '${widget.productPromotion.startingPrice.toString()} PLN'),
                  LabeledText(
                      label: 'Final price',
                      text:
                          '${widget.productPromotion.finalPrice.toString()} PLN'),
                  Text(
                    'URL',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () async {
                      await canLaunch(widget.productPromotion.product.url)
                          ? await launch(widget.productPromotion.product.url)
                          : print('error');
                    },
                    child: Text('OPEN IN BROWSER',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontSize: 25,
                            )),
                  ),
                  TextButton(
                    onPressed: () async {
                      final String response = _isFollowed
                          ? await Provider.of<PromotionsProvider>(context,
                                  listen: false)
                              .unfollowPromotion(widget.productPromotion.id)
                          : await Provider.of<PromotionsProvider>(context,
                                  listen: false)
                              .followPromotion(widget.productPromotion.id);

                      Navigator.of(context)
                          .restorablePush(_dialogBuilder, arguments: response);
                      if (!response.contains('Failed')) {
                        changeFollowStatus();
                      }
                    },
                    child: GradientText(
                      _isFollowed ? 'Unfollow' : 'Follow',
                      gradient: AppColors.mainLinearGradient,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }
}

class LabeledText extends StatelessWidget {
  final String label, text;
  const LabeledText({
    required this.label,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          height: 10,
        ),
        SelectableText(
          text,
          showCursor: true,
          toolbarOptions: const ToolbarOptions(
              copy: true, selectAll: true, cut: false, paste: false),
          style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 30),
        ),
        const SizedBox(
          height: 20,
        )
      ],
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
