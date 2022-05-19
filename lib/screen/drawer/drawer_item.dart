import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class DrawerItem extends StatelessWidget {
  /// name of the menu item
  final String name;
  final Widget icon;
  final Function onTap;
  final Color colorLineSelected;
  final TextStyle baseStyle;
  final TextStyle selectedStyle;
  final bool selected;

  DrawerItem({
    Key key,
    this.name,
    this.icon,
    this.selected = false,
    this.onTap,
    this.colorLineSelected = Colors.blue,
    this.baseStyle,
    this.selectedStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(width: 32, child: icon),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                name,
                style: (this.baseStyle ??
                        GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ))
                    .merge(
                  this.selected
                      ? this.selectedStyle ??
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          )
                      : GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
