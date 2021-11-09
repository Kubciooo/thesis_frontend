import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offprice/components/glassmorphism_card.dart';
import 'package:offprice/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants/main_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: const Splash(),
            theme: AppTheme.darkTheme,
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.darkTheme,
            home: const MyHomePage(title: 'OffPrice'),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          const Center(
            child: GlassmorphismCard(),
          )
        ],
      ),
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

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
