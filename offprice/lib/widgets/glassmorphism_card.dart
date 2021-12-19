import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:offprice/constants/colors.dart';

/// klasa komponentu karty
class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double width, height;

  const GlassmorphismCard(
      {Key? key,
      required this.child,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
        width: width,
        height: height,
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
        child: child);
  }
}
