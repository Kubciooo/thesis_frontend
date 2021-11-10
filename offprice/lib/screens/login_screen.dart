import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //add login and password input fields
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
      body: Container(
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ],
          )),
    );
  }
}
