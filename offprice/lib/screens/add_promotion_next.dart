import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

class AddPromotionNext extends StatefulWidget {
  final ProductModel product;
  const AddPromotionNext({Key? key, required this.product}) : super(key: key);

  @override
  State<AddPromotionNext> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AddPromotionNext> {
  String _type = 'coupon';
  String _discountType = 'percentage';
  String _coupon = '';
  DateTime _expiresAt = DateTime.now().add(const Duration(minutes: 1));
  int _percentage = 1;
  double _cash = 0;
  bool _userValidation = true;

  final _formKey = GlobalKey<FormState>();

  final double _width = 0.9;
  double _height = 0.9;

  void _changeExpiresAt(DateTime date) {
    setState(() {
      _expiresAt = date;
    });
  }

  void _changeUserValidation(value) {
    setState(() {
      _userValidation = value;
    });
  }

  void _changeCoupon(value) {
    setState(() {
      _coupon = value;
    });
  }

  void _changeType(value) {
    setState(() {
      _type = value;
    });
  }

  void _changeDiscountType(value) {
    setState(() {
      _discountType = value;
    });
  }

  void _changePercentage(value) {
    setState(() {
      _percentage = int.parse(value);
    });
  }

  void _changeCash(value) {
    setState(() {
      _cash = double.parse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.colorBackground[900],
        focusColor: AppColors.colorBackground[900],
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Provider.of<PromotionsProvider>(context, listen: false)
                .addPromotion(
                    userValidation: _userValidation,
                    startingPrice: widget.product.price,
                    product: widget.product.id,
                    type: _type,
                    discountType: _discountType,
                    expiresAt: _expiresAt,
                    coupon: _coupon,
                    percentage: _percentage,
                    cash: _cash)
                .then((value) {
              Navigator.of(context).restorablePush(
                _dialogBuilder,
                arguments: value,
              );
            });
          }
        },
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            top: 0,
            left: -50,
            right: -50,
            child: SvgPicture.asset(
              'public/images/fireBackground.svg',
              alignment: Alignment.bottomLeft,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              semanticsLabel: 'Background',
            ),
          ),
          Center(
            child: GlassmorphismCard(
              width: MediaQuery.of(context).size.width * _width,
              height: MediaQuery.of(context).size.height * _height,
              child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name,
                            style: Theme.of(context).textTheme.headline1),
                        DropdownButton<String>(
                          value: _discountType,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 3,
                          style: Theme.of(context).textTheme.headline3,
                          underline: SizedBox(),
                          onChanged: _changeDiscountType,
                          items: <String>['percentage', 'cash']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          value: _type,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 3,
                          style: Theme.of(context).textTheme.headline3,
                          underline: SizedBox(),
                          onChanged: _changeType,
                          items: <String>['coupon', 'promotion', 'other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        if (_type == 'coupon')
                          TextFieldDark(
                            onChanged: _changeCoupon,
                            labelText: 'Coupon',
                            hintText: 'Enter the coupon',
                            icon: const Icon(Icons.person),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Coupon field cannot be empty!';
                              }
                              return null;
                            },
                          ),
                        if (_type == 'coupon')
                          CheckboxListTile(
                            value: _userValidation,
                            activeColor: AppColors.colorBackground[900],
                            onChanged: _changeUserValidation,
                            title: Text('User Validation',
                                style: Theme.of(context).textTheme.headline3),
                          ),
                        if (_discountType == 'percentage')
                          TextFieldDark(
                            isNumeric: true,
                            onChanged: _changePercentage,
                            labelText: 'Percentage',
                            hintText: 'Enter the percentage',
                            icon: const Icon(Icons.money_outlined),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Percentage field cannot be empty!';
                              }
                              if (int.parse(value) > 100) {
                                return 'Percentage cannot be more than 100!';
                              }
                              if (int.parse(value) < 1) {
                                return 'Percentage cannot be less than 1!';
                              }
                              return null;
                            },
                          ),
                        if (_discountType == 'cash')
                          TextFieldDark(
                            isNumeric: true,
                            onChanged: _changeCash,
                            labelText: 'Cash',
                            hintText: 'Enter the cash',
                            icon: const Icon(Icons.attach_money_outlined),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Cash field cannot be empty!';
                              }
                              if (int.parse(value) < 0) {
                                return 'Cash cannot be less than 0!';
                              }
                              return null;
                            },
                          ),
                        TextButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2030, 12, 31),
                                onConfirm: _changeExpiresAt,
                                currentTime: _expiresAt,
                                locale: LocaleType.pl,
                                theme: DatePickerTheme(
                                  backgroundColor:
                                      AppColors.colorBackground[900]!,
                                  cancelStyle: TextStyle(color: Colors.white),
                                  itemStyle: TextStyle(color: Colors.white),
                                  doneStyle: TextStyle(color: Colors.white),
                                ));
                          },
                          child: Text(_expiresAt.toString()),
                        )
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  return CupertinoDialogRoute<void>(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(arguments.toString()),
        actions: <Widget>[
          CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}