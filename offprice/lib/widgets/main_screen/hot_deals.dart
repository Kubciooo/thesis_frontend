import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offprice/providers/promotions.dart';
import 'package:offprice/widgets/gradient_text.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/widgets/promotions_list.dart';
import 'package:offprice/widgets/settings_button.dart';
import 'package:offprice/widgets/text_field_dark.dart';
import 'package:provider/provider.dart';

class HotDeals extends StatelessWidget {
  HotDeals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  GradientText(
                    'HOT',
                    gradient: AppColors.mainLinearGradient,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    'DEALS',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              SettingsButton(title: 'Deal settings', actions: [
                // textFormField that shouldn't be null and should be an integer value that is greater than 0
                TextFieldDark(
                  onChanged: (value) {},
                  hintText: 'Enter a number',
                  initialValue:
                      Provider.of<PromotionsProvider>(context).likes.toString(),
                  icon: const Icon(Icons.drive_file_rename_outline_outlined),
                  labelText: '',
                  onEditingCompleted: (value) async {
                    if (value.isNotEmpty && int.parse(value) > 0) {
                      final statusCode = await Provider.of<PromotionsProvider>(
                              context,
                              listen: false)
                          .setLikes((int.parse(value)));
                      if (statusCode == 201) {
                        Navigator.of(context).pop();
                      } else if (statusCode == 401) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something went wrong'),
                          ),
                        );
                      }
                      ;
                    }
                  },
                  isNumeric: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                ),
              ]),
            ]),
        const PromotionsList(isHot: true),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all-deals');
          },
          child: Text(
            'Show more',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
