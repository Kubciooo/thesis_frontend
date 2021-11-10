import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/components/glassmorphism_card.dart';
import 'package:offprice/components/text_field_dark.dart';
import 'package:offprice/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final auth;
  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
    auth.automaticLogin();
  }

  String _login = '';
  String _password = '';

  void _changeLogin(value) {
    setState(() {
      _login = value;
    });
  }

  void _changePassword(value) {
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
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFieldDark(
                          onChanged: _changeLogin,
                          labelText: 'Login',
                          hintText: 'Enter your login',
                          icon: const Icon(Icons.person),
                        ),
                        TextFieldDark(
                          onChanged: _changePassword,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          icon: const Icon(Icons.lock),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            auth.login(_login, _password);
                          },
                          child: const Text('Login',
                              style: TextStyle(fontSize: 20)),
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
