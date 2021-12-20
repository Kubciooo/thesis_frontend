import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/models/product.dart';
import 'package:offprice/providers/auth.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/screens/login_screen.dart';
import 'package:offprice/widgets/glassmorphism_card.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

/// Widok dodawania promocji do produktu po wybraniu produktu
class AddPromotionNext extends StatefulWidget {
  final ProductModel product;
  const AddPromotionNext({Key? key, required this.product}) : super(key: key);

  @override
  State<AddPromotionNext> createState() => _AddPromotionNextState();
}

class _AddPromotionNextState extends State<AddPromotionNext> {
  String _type = 'coupon';
  String _discountType = 'percentage';
  String _coupon = '';
  DateTime _expiresAt = DateTime.now().add(const Duration(minutes: 1));
  int _percentage = 1;
  double _cash = 0;
  bool _userValidation = true;

  final _formKey = GlobalKey<FormState>();

  final double _width = 0.9;
  final double _height = 0.9;

  void _changeExpiresAt(DateTime date) {
    _expiresAt = date;
  }

  void _changeUserValidation(value) {
    setState(() {
      _userValidation = value;
    });
  }

  void _changeCoupon(value) {
    _coupon = value;
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
    _percentage = int.parse(value);
  }

  void _changeCash(value) {
    _cash = double.parse(value);
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
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            showDialog(
                context: context,
                builder: (context) {
                  return FutureBuilder(
                      future: Provider.of<PromotionsProvider>(context,
                              listen: false)
                          .addPromotion(
                              userValidation: _userValidation,
                              startingPrice: widget.product.price,
                              product: widget.product.id,
                              type: _type,
                              discountType: _discountType,
                              expiresAt: _expiresAt,
                              coupon: _coupon,
                              percentage: _percentage,
                              cash: _cash),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error during promotion adding'),
                          );
                        } else {
                          if ((snapshot.data as int) == 401) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.routeName,
                                  ModalRoute.withName('/'));
                              Provider.of<AuthProvider>(context, listen: false)
                                  .logout();
                            });
                          } else if ((snapshot.data as int) == 201) {
                            return AlertDialog(
                              title: const Text('Promotion was added'),
                              content: const Text('Promotion was added'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            title: const Text('Promotion was not added'),
                            content: const Text('Invalid coupon!'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                      });
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
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 3,
                          style: Theme.of(context).textTheme.headline3,
                          underline: const SizedBox(),
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
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 3,
                          style: Theme.of(context).textTheme.headline3,
                          underline: const SizedBox(),
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
                            onEditingCompleted: () {},
                            onChanged: _changeCoupon,
                            labelText: 'Coupon',
                            hintText: 'Enter the coupon',
                            initialValue: _coupon,
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
                            initialValue: _percentage.toString(),
                            onEditingCompleted: () {},
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
                            onEditingCompleted: () {},
                            isNumeric: true,
                            initialValue: _cash.toString(),
                            onChanged: _changeCash,
                            labelText: 'Cash',
                            hintText: Provider.of<PromotionsProvider>(context,
                                    listen: false)
                                .likes
                                .toString(),
                            icon: const Icon(Icons.attach_money_outlined),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Cash field cannot be empty!';
                              }
                              if (double.parse(value) < 0) {
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
                                  cancelStyle:
                                      const TextStyle(color: Colors.white),
                                  itemStyle:
                                      const TextStyle(color: Colors.white),
                                  doneStyle:
                                      const TextStyle(color: Colors.white),
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
