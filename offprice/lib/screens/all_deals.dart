import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/screens/add_promotion.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/promotions_list.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'dart:async';

class AllDealsScreen extends StatefulWidget {
  const AllDealsScreen({Key? key}) : super(key: key);
  static const String routeName = '/all-deals';

  @override
  State<AllDealsScreen> createState() => _AllDealsScreenState();
}

class _AllDealsScreenState extends State<AllDealsScreen> {
  @override
  void dispose() {
    _debounce.cancel();
    super.dispose();
  }

  String _searchTerm = '';
  Timer _debounce = Timer(Duration.zero, () {});

  void setSearchTerm(String value) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            top: 0,
            left: -50,
            right: -50,
            child: SvgPicture.asset(
              'public/images/fireBackground.svg',
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              semanticsLabel: 'Background',
            ),
          ),
          Center(
            child: GlassmorphismCard(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All deals',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      'All the deals you can find here',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextFieldDark(
                        initialValue: _searchTerm,
                        onEditingCompleted: (value) {
                          setSearchTerm(value);
                        },
                        onChanged: setSearchTerm,
                        labelText: 'Product name',
                        hintText: 'Search',
                        icon: const Icon(Icons.search),
                        validator: (value) {
                          return null;
                        }),
                    PromotionsList(
                      key: const Key('Promotions'),
                      searchTerm: _searchTerm,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('AddDeal'),
        onPressed: () {
          Navigator.of(context).pushNamed(AddPromotionScreen.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.colorBackground[900],
        focusColor: AppColors.colorBackground[900],
      ),
    );
  }
}
