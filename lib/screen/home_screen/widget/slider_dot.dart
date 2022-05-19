import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/utils/dummy_data/category.dart';

import '../../../app_url_name_companyid.dart';

class SliderDot extends StatefulWidget {
  const SliderDot({
    Key key,
    @required int current,
  })  : _current = current,
        super(key: key);

  final int _current;

  @override
  SliderDotState createState() => SliderDotState();
}

class SliderDotState extends State<SliderDot> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: discountImageList.map((url) {
        int index = discountImageList.indexOf(url);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // borderRadius: BorderRadius.circular(4),
            // shape: BoxShape.rectangle,
            color: widget._current == index ? appName == "MILLBORN-Jaipur" ? mainColor : Color(0xFF0055FF) : textColor,
          ),
        );
      }).toList(),
    );
  }
}
