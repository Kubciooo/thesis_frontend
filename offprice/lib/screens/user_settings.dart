import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

/// widok ustawień użytkownika
class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/user-settings';

  @override
  State<UserSettingsScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingsScreen> {
  final double _width = 0.9;
  final double _height = 0.9;
  String _password = '';
  String _retypePassword = '';

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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              key: const Key('resetPassword'),
                              title: const Text('Reset Password'),
                              content: Card(
                                color: Colors.transparent,
                                elevation: 0.0,
                                child: Column(
                                  children: [
                                    TextFieldDark(
                                      onEditingCompleted: () {},
                                      obscureText: true,
                                      onChanged: (value) {
                                        _password = value;
                                      },
                                      labelText: 'Password',
                                      hintText: 'Enter new password',
                                      icon: const Icon(Icons.password),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFieldDark(
                                      obscureText: true,
                                      onEditingCompleted: () {},
                                      onChanged: (value) {
                                        _retypePassword = value;
                                      },
                                      labelText: 'Retype Password',
                                      hintText: 'Retype your password',
                                      icon: const Icon(Icons.password),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value != _password) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('Cancel'),
                                  onPressed: () => {
                                    Navigator.of(context).pop(),
                                    _password = '',
                                    _retypePassword = '',
                                  },
                                ),
                                TextButton(
                                  child: Text('Ok',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  onPressed: () async {
                                    int statusCode =
                                        await Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .updatePassword(
                                                password: _password,
                                                retypePassword:
                                                    _retypePassword);
                                    _password = '';
                                    _retypePassword = '';

                                    if (statusCode == 201) {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          key:
                                              const Key('resetPasswordSuccess'),
                                          title: const Text('Success'),
                                          content: const Text(
                                              'Password has been updated! Now login with your new password'),
                                          actions: [
                                            TextButton(
                                                child: Text('Ok',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                                onPressed: () {
                                                  Future.delayed(Duration.zero,
                                                      () {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            LoginScreen
                                                                .routeName,
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                    Provider.of<AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .logout();
                                                  });
                                                })
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          key: const Key('resetPasswordFailed'),
                                          title: const Text('Failed'),
                                          content: const Text(
                                              'Failed to reset password'),
                                          actions: [
                                            TextButton(
                                              child: Text('Ok',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          );
                        },
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
