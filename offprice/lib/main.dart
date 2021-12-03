import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offprice/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/folders.dart';
import 'package:offprice/providers/products.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/screens/add_foder.dart';
import 'package:offprice/screens/add_promotion.dart';
import 'package:offprice/screens/all_deals.dart';
import 'package:offprice/screens/all_folders.dart';
import 'package:offprice/screens/all_products.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/screens/main_screen.dart';
import 'package:offprice/screens/user_settings.dart';
import 'package:provider/provider.dart';
import 'constants/main_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProxyProvider<AuthProvider, PromotionsProvider>(
      create: (context) => PromotionsProvider(),
      update: (context, auth, promotions) => promotions!..update(auth),
    ),
    ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
      create: (context) => ProductsProvider(),
      update: (context, auth, products) => products!..update(auth),
    ),
    ChangeNotifierProxyProvider<AuthProvider, FoldersProvider>(
      create: (context) => FoldersProvider(),
      update: (context, auth, folders) => folders!..update(auth),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder(
      future: auth.automaticLogin(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Splash(),
            theme: AppTheme.darkTheme,
          );
        } else {
          // Loading is done, return the app:
          /**
           * @todo autologin -> login on false / mainPage on true 
           */
          Widget screen = const LoginScreen();
          if (snapshot.data == true) {
            screen = const MainScreen();
          }
          return Consumer<AuthProvider>(
              builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Offprice',
                    theme: AppTheme.darkTheme,
                    home: screen,
                    routes: {
                      '/login': (context) => const LoginScreen(),
                      '/home': (context) => const MainScreen(),
                      '/all-deals': (context) => const AllDealsScreen(),
                      '/add-promotion': (context) => const AddPromotionScreen(),
                      '/add-folder': (context) => const AddFolderScreen(),
                      '/all-products': (context) => AllProductsScreen(),
                      '/all-folders': (context) => const AllFoldersScreen(),
                      '/user-settings': (context) => UserSettingsScreen(),
                    },
                  ));
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground[900],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('public/images/SplashText.svg',
              semanticsLabel: 'OffPrice logo'),
          const SizedBox(height: 30),
          const CupertinoActivityIndicator(animating: true, radius: 20),
        ],
      )),
    );
  }
}
