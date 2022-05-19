import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';

class ShadowButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double borderRadius;

  ShadowButton({@required this.child, @required this.height, this.borderRadius})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);

    return Container(
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: themeColor.getColor().withOpacity(0.5),
            blurRadius: height / 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
