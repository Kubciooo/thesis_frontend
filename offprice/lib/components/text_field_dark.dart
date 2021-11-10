import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/constants/colors.dart';

class TextFieldDark extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final Function onChanged;
  final String labelText;
  final bool obscureText;

  const TextFieldDark(
      {Key? key,
      required this.onChanged,
      required this.labelText,
      required this.hintText,
      required this.icon,
      this.obscureText = false})
      : super(key: key);

  @override
  _TextFieldDarkState createState() => _TextFieldDarkState();
}

class _TextFieldDarkState extends State<TextFieldDark> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => widget.onChanged(value),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        icon: widget.icon,
        fillColor: AppColors.colorSecondary[900],
      ),
      obscureText: widget.obscureText,
    );
  }
}
