import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offprice/constants/colors.dart';

class TextFieldDark extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final Function onChanged;
  final String labelText;
  final bool obscureText;
  final Function validator;
  final bool isNumeric;

  const TextFieldDark(
      {Key? key,
      required this.onChanged,
      required this.labelText,
      required this.hintText,
      required this.icon,
      required this.validator,
      this.isNumeric = false,
      this.obscureText = false})
      : super(key: key);

  @override
  _TextFieldDarkState createState() => _TextFieldDarkState();
}

class _TextFieldDarkState extends State<TextFieldDark> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (value) => widget.onChanged(value),
      validator: (value) {
        return widget.validator(value);
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        icon: widget.icon,
        fillColor: AppColors.colorSecondary[900],
      ),
      keyboardType:
          widget.isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        if (widget.isNumeric)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      obscureText: widget.obscureText,
    );
  }
}
