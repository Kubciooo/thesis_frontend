import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/screens/user_settings.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/main_screen/favourite_folder.dart';
import 'package:offprice/widgets/main_screen/favourite_product.dart';
import 'package:offprice/widgets/main_screen/hot_deals.dart';

/// Główny widok aplikacji
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
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
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(UserSettingsScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        )),
                  ]),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _selectedIndex = page;
                    });
                  },
                  children: <Widget>[
                    Center(
                      child: GlassmorphismCard(
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: HotDeals(),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                    Center(
                      child: GlassmorphismCard(
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: FavouriteProduct(),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                    Center(
                      child: GlassmorphismCard(
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: FavouriteFolder(),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: 30,
                width: 120,
                margin: const EdgeInsets.only(top: 20),
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 3; i++)
                      ClipOval(
                        key: Key('Main$i'),
                        child: InkWell(
                          onTap: () => {
                            pageController.animateToPage(i,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                          },
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: i == _selectedIndex
                                    ? const Color.fromRGBO(255, 255, 255, 0.9)
                                    : const Color.fromRGBO(255, 255, 255, 0.4),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 10),
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
