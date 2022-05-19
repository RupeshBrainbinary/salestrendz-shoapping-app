import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class NewAddressInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function validator;
  final Function onSaved;
  final IconButton suffixIcon;
  final bool isPassword;
  final bool isEmail;
  final String labelValue;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final Border border;

  NewAddressInput(
      {this.hintText,
      this.validator,
      this.onSaved,
      this.isPassword = false,
      this.isEmail = false,
      this.labelText,
      this.suffixIcon,
      this.labelValue,
      this.keyboardType,
      this.textEditingController,
      this.border});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      initialValue: this.labelValue ?? null,
      decoration: InputDecoration(
          hintText: hintText,
          labelStyle: GoogleFonts.poppins(fontSize: 12, color:Theme.of(context).primaryColor,),
          helperStyle: GoogleFonts.poppins(fontSize: 12,color: Theme.of(context).primaryColor,),
          hintStyle:GoogleFonts.poppins(fontSize: 12,color: Theme.of(context).primaryColor, ),
          labelText: labelText,
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color:  Theme.of(context).primaryColor,),
        ),
      ),

      cursorColor: Theme.of(context).primaryColor,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
    );
  }
}
