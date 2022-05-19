import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/utils/commons/colors.dart';
import 'package:shoppingapp/widgets/commons/string_res.dart';


class ThemeChanger {
  final BuildContext context;

  ThemeChanger(this.context);

  void openFullMaterialColorPicker(themeColor) async {
    openDialog(
      Strings.choosecolor,
      MaterialColorPicker(
        colors: accentColors,
        onColorChange: (color) async {
          var prefs = await SharedPreferences.getInstance();
          prefs.setInt('color', color.value);
          themeColor.setColor(color);
        },
      ),
    );
  }

  void openDialog(String title, Widget content) {
    showDialog(
      context: this.context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text(
                Strings.cancel,
                style: GoogleFonts.poppins(color: textColor),
              ),
              onPressed: Navigator.of(this.context).pop,
            ),
            FlatButton(
              child: Text(Strings.Save, style: GoogleFonts.poppins(color: mainColor)),
              onPressed: () {
                Navigator.of(this.context).pop();
                Phoenix.rebirth(context);
              },
            ),
          ],
        );
      },
    );
  }
}
