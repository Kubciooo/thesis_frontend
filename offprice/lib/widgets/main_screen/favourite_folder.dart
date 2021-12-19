import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/screens/all_folders.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/main_screen/chart.dart';
import 'package:provider/provider.dart';

/// klasa tworząca komponent ulubionego folderu
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
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              int statusCode = snapshot.data as int;
              if (statusCode == 401) {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false);
                  Provider.of<AuthProvider>(context, listen: false).logout();
                });
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
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: productCharts.first.data.isNotEmpty
                            ? Chart(
                                productChart: productCharts,
                              )
                            : Center(
                                child: Text(
                                  'No items found...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                ),
                              )),
                  ],
                ),
              );
            }),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AllFoldersScreen.routeName);
          },
          child: Text(
            'Show more',
            key: const Key('Show more folders'),
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
