import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

class FavouriteFolder extends StatelessWidget {
  FavouriteFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<FoldersProvider>(context, listen: false).fetchFolders(),
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
          final folders =
              Provider.of<FoldersProvider>(context, listen: false).folders;

          if (folders.isEmpty) {
            return Center(
              child: Text('No folders',
                  style: Theme.of(context).textTheme.headline1),
            );
          }
          final productCharts =
              Provider.of<FoldersProvider>(context, listen: false)
                  .getFolderChart(folders[0]);
          return Column(
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
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      Provider.of<FoldersProvider>(context, listen: false)
                          .folders[0]
                          .name,
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
        });
  }
}
