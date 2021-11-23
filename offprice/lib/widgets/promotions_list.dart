import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/models/deal.dart';
import 'package:offprice/screens/product_promotion.dart';
import 'package:provider/provider.dart';

class PromotionsList extends StatefulWidget {
  final bool isHot;
  final String searchTerm;
  const PromotionsList({
    this.isHot = false,
    this.searchTerm = '',
    Key? key,
  }) : super(key: key);

  @override
  State<PromotionsList> createState() => _PromotionsListState();
}

class _PromotionsListState extends State<PromotionsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: Provider.of<PromotionsProvider>(context, listen: false)
              .getPromotions(filter: widget.searchTerm, fetchUser: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<DealModel> data =
                Provider.of<PromotionsProvider>(context).deals;
            return RefreshIndicator(
              onRefresh: () async {
                int statusCode = await Provider.of<PromotionsProvider>(context,
                        listen: false)
                    .refreshPromotions();
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              ProductPromotionScreen(
                                  productPromotion: data[index])));
                    },
                    title: Text(data[index].product.name,
                        style: Theme.of(context).textTheme.headline3),
                    subtitle: Text(data[index].finalPrice.toString(),
                        style: Theme.of(context).textTheme.subtitle1),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Stack(children: [
                            Center(
                              child: SvgPicture.asset(
                                'public/images/fire.svg',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Center(
                              child: Text(
                                data[index].rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          ]),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 27,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          }),
    );
  }
}
