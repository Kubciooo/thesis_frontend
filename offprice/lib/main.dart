import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offprice/components/glassmorphism_card.dart';
import 'package:offprice/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/providers/auth.dart';
import 'package:provider/provider.dart';
import 'constants/main_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AuthProvider(), child: const MyApp()));
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
            home: const Splash(),
            theme: AppTheme.darkTheme,
          );
        } else {
          // Loading is done, return the app:
          /**
           * @todo autologin -> login on false / mainPage on true 
           */
          print(snapshot.data);
          return Consumer<AuthProvider>(
              builder: (ctx, auth, _) => MaterialApp(
                    title: 'Flutter Demo',
                    theme: AppTheme.darkTheme,
                    home: const MyHomePage(title: 'OffPrice'),
                  ));
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
  late final auth;
  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
    auth.automaticLogin();
  }

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String _login = '';
  String _password = '';

  void _changeLogin(value) {
    print(_login);
    setState(() {
      _login = value;
    });
  }

  void _changePassword(value) {
    print(_password);
    setState(() {
      _password = value;
    });
  }

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
          Center(
            child: GlassmorphismCard(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _loginController,
                          onChanged: (value) => _changeLogin(value),
                          decoration: const InputDecoration(
                            labelText: 'Login',
                            hintText: 'Enter your login',
                            icon: Icon(Icons.person),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          onChanged: (value) => _changePassword(value),
                          onSubmitted: (_) async {
                            var isLoggedIn = await auth.signIn(
                                login: _login, password: _password);
                            print(isLoggedIn);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                      ],
                    )),
              ),
            ),
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
