import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class MyTextFormFieldLine extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function validator;
  final Function onSaved;
  final IconButton suffixIcon;
  final bool isPassword;
  final bool isEmail;
  final TextEditingController controller;

  MyTextFormFieldLine(
      {this.hintText,
      this.validator,
      this.onSaved,
      this.isPassword = false,
      this.isEmail = false,
      this.labelText,
      this.suffixIcon,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.5,
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: textColor),
          contentPadding: EdgeInsets.all(15.0),
          border: new UnderlineInputBorder(
            borderSide: new BorderSide(color: textColor),
          ),
          labelText: labelText,
          filled: true,
          suffixIcon: this.suffixIcon,
          fillColor: Color(0xFFFCFCFC),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  Theme.of(context).primaryColor,),
          ),
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        controller: controller,
      ),
    );
  }
}
