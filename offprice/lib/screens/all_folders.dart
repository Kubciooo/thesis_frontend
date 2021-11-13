import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/screens/single_folder.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:provider/provider.dart';

class AllFoldersScreen extends StatefulWidget {
  const AllFoldersScreen({Key? key}) : super(key: key);

  @override
  State<AllFoldersScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<AllFoldersScreen> {
  final double _width = 0.9;
  final double _height = 0.9;

  @override
  Widget build(BuildContext context) {
    final foldersProvider = Provider.of<FoldersProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-folder');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.colorBackground[900],
        focusColor: AppColors.colorBackground[900],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width * _width,
              height: MediaQuery.of(context).size.height * _height,
              child: GlassmorphismCard(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'All folders',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await foldersProvider.fetchFolders();
                          },
                          child: ListView.builder(
                            itemCount: foldersProvider.folders.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  title: Text(
                                      foldersProvider.folders[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                            color: Colors.white,
                                          )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SingleFolder(
                                                folder: foldersProvider
                                                    .folders[index])));
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
