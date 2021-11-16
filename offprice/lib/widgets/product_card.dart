import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:offprice/constants/colors.dart';
import 'package:offprice/models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final Function(ProductModel) onTap;
  const ProductCard({Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.colorBackground[500],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(product.name,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 16,
                )),
        onTap: () => onTap(product),
        subtitle: Text(product.shop,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                )),
        trailing: Text(product.price.toStringAsFixed(2),
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                )),
      ),
    );
  }
}
