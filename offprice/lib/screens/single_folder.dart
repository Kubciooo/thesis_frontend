import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:offprice/widgets/product_card.dart';
import 'package:offprice/widgets/settings_button.dart';
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(
                              'Chosen folder',
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
                              folder.name,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                        SettingsButton(
                          title: 'Product Settings',
                          actions: [
                            if (!Provider.of<FoldersProvider>(context,
                                    listen: false)
                                .isFavourite(folder))
                              TextButton(
                                child: const Text('Mark as favourite'),
                                onPressed: () async {
                                  int statusCode =
                                      await Provider.of<FoldersProvider>(
                                              context,
                                              listen: false)
                                          .setFavouriteFolder(folder);

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
                              child: const Text('Delete folder'),
                              onPressed: () async {
                                int statusCode =
                                    await Provider.of<FoldersProvider>(context,
                                            listen: false)
                                        .deleteFolder(folder.id);
                                if (statusCode == 201) {
                                  Navigator.of(context).pop();
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Chart(
                    productChart: Provider.of<FoldersProvider>(context)
                        .getFolderChart(folder),
                  )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: folder.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          onTap: (ProductModel product) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(product.name),
                                    content: Text(product.shop),
                                    actions: [
                                      TextButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          int statusCode = await Provider.of<
                                                      FoldersProvider>(context,
                                                  listen: false)
                                              .removeProductFromFolder(
                                                  folder.id, product.id);
                                          if (statusCode == 401) {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/login', (route) => false);
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          product: folder.products[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
