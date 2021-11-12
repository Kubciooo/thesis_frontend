import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/promotions_list.dart';

class HotDeals extends StatelessWidget {
  HotDeals({Key? key}) : super(key: key);

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
        const PromotionsList(isHot: true),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all-deals');
          },
          child: Text(
            'Show more',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
