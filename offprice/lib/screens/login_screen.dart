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
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _login = '';
  String _forgotPasswordLogin = '';
  String _resetPassword = '';
  String _retypeResetPassword = '';
  String _resetToken = '';
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
                width: MediaQuery.of(context).size.width * _width,
                height: MediaQuery.of(context).size.height * _height,
                child: Container(
                    padding: const EdgeInsets.all(40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFieldDark(
                            initialValue: _login,
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
                            initialValue: _password,
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
                          if (!_isLogin) ...[
                            TextFieldDark(
                              initialValue: _email,
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
                            TextFieldDark(
                              initialValue: _retypePassword,
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
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  child: Text(
                                    _isLogin
                                        ? 'Not a member yet?\nRegister now!'
                                        : 'Already have and account?\nLogin',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    switchLoginAndRegister();
                                  }),
                              TextButton(
                                key: const Key('loginButton'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_isLogin) {
                                      bool didSignIn =
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .signIn(
                                                  login: _login,
                                                  password: _password);

                                      if (didSignIn) {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  key: const Key('loginError'),
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'Wrong login or password'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Ok',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    )
                                                  ],
                                                ));
                                      }
                                    } else {
                                      bool didSignUp =
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .signUp(
                                                  login: _login,
                                                  email: _email,
                                                  password: _password,
                                                  retypePassword:
                                                      _retypePassword);

                                      if (didSignUp) {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'There was an error during register!\nTry again!'),
                                                  actions: [
                                                    TextButton(
                                                      key: const Key(
                                                          'ErrorRegister'),
                                                      child: Text('Ok',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    )
                                                  ],
                                                ));
                                      }
                                    }
                                  }
                                },
                                child: Text(_isLogin ? 'Login' : 'Register',
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                          if (_isLogin)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          key: const Key('forgotPassword'),
                                          title: const Text('Forgot Password'),
                                          content: Card(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            child: Column(
                                              children: [
                                                TextFieldDark(
                                                  onEditingCompleted: () {},
                                                  onChanged: (value) {
                                                    _forgotPasswordLogin =
                                                        value;
                                                  },
                                                  labelText: 'Login',
                                                  hintText: 'Enter your login',
                                                  icon:
                                                      const Icon(Icons.person),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your login';
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
                                                _forgotPasswordLogin = ''
                                              },
                                            ),
                                            TextButton(
                                                child: Text('Ok',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                                onPressed: () async {
                                                  int statusCode = await Provider
                                                          .of<AuthProvider>(
                                                              context,
                                                              listen: false)
                                                      .forgotPassword(
                                                          _forgotPasswordLogin);
                                                  _forgotPasswordLogin = '';

                                                  if (statusCode == 200) {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        key: const Key(
                                                            'forgotPasswordSuccess'),
                                                        title: const Text(
                                                            'Success'),
                                                        content: const Text(
                                                            'Check your email'),
                                                        actions: [
                                                          TextButton(
                                                            child: Text('Ok',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline3),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        key: const Key(
                                                            'forgotPasswordError'),
                                                        title:
                                                            const Text('Error'),
                                                        content: const Text(
                                                            'There was an error during sending password token!\nTry again!'),
                                                        actions: [
                                                          TextButton(
                                                            key: const Key(
                                                                'ErrorForgotPassword'),
                                                            child: Text('Ok',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline3),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                })
                                          ],
                                        ),
                                      );
                                    }),
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          key: const Key('resetPassword'),
                                          title: const Text('Reset Password'),
                                          content: Card(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            child: Column(
                                              children: [
                                                TextFieldDark(
                                                  onEditingCompleted: () {},
                                                  onChanged: (value) {
                                                    _resetToken = value;
                                                  },
                                                  labelText: 'Token',
                                                  hintText: 'Enter your token',
                                                  icon:
                                                      const Icon(Icons.person),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your token';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFieldDark(
                                                  onEditingCompleted: () {},
                                                  onChanged: (value) {
                                                    _resetPassword = value;
                                                  },
                                                  labelText: 'Password',
                                                  hintText:
                                                      'Enter new password',
                                                  icon: const Icon(
                                                      Icons.password),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your password';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFieldDark(
                                                  onEditingCompleted: () {},
                                                  onChanged: (value) {
                                                    _retypeResetPassword =
                                                        value;
                                                  },
                                                  labelText: 'Retype Password',
                                                  hintText:
                                                      'Retype your password',
                                                  icon: const Icon(
                                                      Icons.password),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter your password';
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
                                                _resetPassword = '',
                                                _resetToken = '',
                                                _retypeResetPassword = '',
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Ok',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3),
                                              onPressed: () async {
                                                int statusCode = await Provider
                                                        .of<AuthProvider>(
                                                            context,
                                                            listen: false)
                                                    .resetPassword(
                                                        token: _resetToken,
                                                        password:
                                                            _resetPassword,
                                                        retypePassword:
                                                            _retypeResetPassword);
                                                _resetPassword = '';
                                                _resetToken = '';
                                                _retypeResetPassword = '';

                                                if (statusCode == 200) {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CupertinoAlertDialog(
                                                      key: const Key(
                                                          'resetPasswordSuccess'),
                                                      title:
                                                          const Text('Success'),
                                                      content: const Text(
                                                          'Password has been reset'),
                                                      actions: [
                                                        TextButton(
                                                          child: Text('Ok',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline3),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CupertinoAlertDialog(
                                                      key: const Key(
                                                          'resetPasswordFailed'),
                                                      title:
                                                          const Text('Failed'),
                                                      content: const Text(
                                                          'Failed to reset password'),
                                                      actions: [
                                                        TextButton(
                                                          child: Text('Ok',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline3),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
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
                                    child: const Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )),
                              ],
                            ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
