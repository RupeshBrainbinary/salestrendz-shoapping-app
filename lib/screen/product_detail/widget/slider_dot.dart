import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class SliderDotProductDetail extends StatelessWidget {
  const SliderDotProductDetail({
    Key key,
    @required int current,
    this.selectedProduct,
  })  : _current = current,
        super(key: key);

  final int _current;
  final OrderedProduct selectedProduct;

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (selectedProduct?.productImages ?? []).map((url) {
        int index = (selectedProduct?.productImages ?? []).indexOf(url);
        return Container(
          width: 12.0,
          height: 3.0,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
            color:
                _current == index ? themeColor.getColor() : Color(0xFFEEEEF3),
          ),
        );
      }).toList(),
    );
  }
}
