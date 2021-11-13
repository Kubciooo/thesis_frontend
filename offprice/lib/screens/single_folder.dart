import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

class SingleFolder extends StatelessWidget {
  final UserProductsModel folder;
  SingleFolder({Key? key, required this.folder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          'Chosen folder',
                          gradient: AppColors.mainLinearGradient,
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          folder.name,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Chart(
                    productChart: Provider.of<FoldersProvider>(context)
                        .getFolderChart(folder),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
