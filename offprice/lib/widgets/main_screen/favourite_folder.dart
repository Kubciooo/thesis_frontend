import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

class FavouriteFolder extends StatelessWidget {
  const FavouriteFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoldersProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: provider.fetchFavouriteFolder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              final folder =
                  Provider.of<FoldersProvider>(context).favouriteFolder;

              if (!provider.isFavouriteFolderSet) {
                return Center(
                  child: Text('No favourite folder!',
                      style: Theme.of(context).textTheme.headline1),
                );
              }
              final productCharts = provider.getFolderChart(folder);
              return Expanded(
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
                      productChart: productCharts,
                    )),
                  ],
                ),
              );
            }),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all-folders');
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