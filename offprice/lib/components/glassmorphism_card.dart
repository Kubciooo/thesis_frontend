import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:offprice/components/gradient_text.dart';
import 'package:offprice/constants/colors.dart';

class GlassmorphismCard extends StatelessWidget {
  const GlassmorphismCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.75,
      borderRadius: 39,
      blur: 15,
      alignment: Alignment.bottomCenter,
      border: 1.5,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.colorGlassmorphismCard.withOpacity(0.5),
            AppColors.colorGlassmorphismCard.withOpacity(0),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          AppColors.colorGlassmorphismCardBorder.withOpacity(0.5),
          AppColors.colorGlassmorphismCardBorder.withOpacity(0.5),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText('Favourites',
                gradient: AppColors.mainLinearGradient,
                style: Theme.of(context).textTheme.headline2),
            Text('IPHONE 12 PRO', style: Theme.of(context).textTheme.headline1),
          ],
        ),
      ),
    );
  }
}
