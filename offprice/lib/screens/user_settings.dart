import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:provider/provider.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-settings';

  @override
  State<UserSettingsScreen> createState() => _AddPromotionScreenState();
}

class _AddPromotionScreenState extends State<UserSettingsScreen> {
  final double _width = 0.9;
  final double _height = 0.9;

  @override
  void initState() {
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchShops()
        .then((statusCode) {
      if (statusCode == 401) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      }
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchBlockedShops()
        .then((statusCode) {
      if (statusCode == 401) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shops = Provider.of<ProductsProvider>(context).shops;
    return Scaffold(
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
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.password),
                        label: const Text(
                          'Change password',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      ExpansionTile(
                        title: const Text(
                          'Manage blocked shops',
                          style: TextStyle(fontSize: 25),
                        ),
                        children: [
                          ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: shops.length,
                            itemBuilder: (context, index) {
                              final shop = shops[index];
                              return CheckboxListTile(
                                  title: Text(shop.name),
                                  activeColor: AppColors.colorBackground[900],
                                  value: Provider.of<ProductsProvider>(context,
                                          listen: false)
                                      .isBlockedShop(shop),
                                  onChanged: (value) {
                                    Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .changeShopBlockStatus(
                                            shop, value ?? false);
                                  });
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () async {
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                          Future.delayed(Duration.zero, () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginScreen.routeName, (route) => false);
                            Provider.of<AuthProvider>(context, listen: false)
                                .logout();
                          });
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 25),
                        ),
                      )
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
