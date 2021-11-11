import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offprice/models/deal.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:provider/provider.dart';

class HotDeals extends StatefulWidget {
  HotDeals({Key? key}) : super(key: key);

  @override
  _HotDealsState createState() => _HotDealsState();
}

class _HotDealsState extends State<HotDeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GradientText(
              'HOT',
              gradient: AppColors.mainLinearGradient,
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              'DEALS',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
              future: Provider.of<PromotionsProvider>(context, listen: true)
                  .getPromotions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List<DealModel> data = snapshot.data as List<DealModel>;
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<PromotionsProvider>(context,
                            listen: false)
                        .refreshPromotions();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {},
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
                                    '${index + 1}',
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
        )
      ],
    );
  }
}
