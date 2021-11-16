import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsButton extends StatefulWidget {
  final List<Widget> actions;
  final String title;
  const SettingsButton({Key? key, required this.title, required this.actions})
      : super(key: key);

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(widget.title),
                actions: [
                  ...widget.actions,
                ],
              );
            });
      },
      icon: const Icon(
        Icons.settings,
        color: Colors.white70,
        size: 30,
      ),
    );
  }
}
