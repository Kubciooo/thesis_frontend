import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// klasa wyświetlająca przycisk ustawień
class SettingsButton extends StatefulWidget {
  final List<Widget> actions;
  final String title;
  final double size;
  const SettingsButton(
      {Key? key, required this.title, required this.actions, this.size = 30})
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
      icon: Icon(
        Icons.settings,
        color: Colors.white70,
        size: widget.size,
      ),
    );
  }
}
