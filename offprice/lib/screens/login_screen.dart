import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:offprice/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _login = '';
  String _password = '';
  String _email = '';
  String _retypePassword = '';
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final double _width = 0.9;
  double _height = 0.4;

  void switchLoginAndRegister() {
    setState(() {
      if (_isLogin) {
        _height = 0.6;
        _isLogin = false;
      } else {
        _height = 0.4;
        _isLogin = true;
      }
    });
  }

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

  void _changeEmail(value) {
    setState(() {
      _email = value;
    });
  }

  void _changeRetypePassword(value) {
    setState(() {
      _retypePassword = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switchLoginAndRegister();
        },
        child: const Icon(Icons.arrow_forward),
      ),
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
            child: AnimatedContainer(
              width: MediaQuery.of(context).size.width * _width,
              height: MediaQuery.of(context).size.height * _height,
              duration: const Duration(milliseconds: 300),
              child: GlassmorphismCard(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFieldDark(
                            onEditingCompleted: () {},
                            onChanged: _changeLogin,
                            labelText: 'Login',
                            hintText: 'Enter your login',
                            icon: const Icon(Icons.person),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your login';
                              }
                              return null;
                            },
                          ),
                          TextFieldDark(
                            onEditingCompleted: () {},
                            onChanged: _changePassword,
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            icon: const Icon(Icons.lock),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          if (!_isLogin)
                            TextFieldDark(
                              onEditingCompleted: () {},
                              onChanged: _changeEmail,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: const Icon(Icons.email),
                              validator: (value) {
                                if (value.isEmpty || !isEmail(value)) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          if (!_isLogin)
                            TextFieldDark(
                              onEditingCompleted: () {},
                              onChanged: _changeRetypePassword,
                              labelText: 'Retype password',
                              hintText: 'Enter your password again',
                              icon: const Icon(Icons.lock),
                              obscureText: true,
                              validator: (value) => value != _password
                                  ? 'Passwords do not match'
                                  : null,
                            ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_isLogin) {
                                  bool didSignIn =
                                      await Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .signIn(
                                              login: _login,
                                              password: _password);

                                  if (didSignIn) {
                                    Navigator.of(context).pushNamed('/home');
                                  }
                                } else {
                                  bool didSignUp =
                                      await Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .signUp(
                                              login: _login,
                                              email: _email,
                                              password: _password,
                                              retypePassword: _retypePassword);

                                  if (didSignUp) {}
                                }
                              }
                            },
                            child: Text(_isLogin ? 'Login' : 'Register',
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
