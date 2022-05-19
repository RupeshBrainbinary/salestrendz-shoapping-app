import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class CustomAlertView extends StatelessWidget {
  CustomAlertView({
    @required this.imageWid,
    @required this.labelText,
    @required this.gestureFunc,
    @required this.sidesColor,
    @required this.viewColor,
  });

  final Color viewColor;
  final Color sidesColor;
  final String imageWid;
  final String labelText;
  final Function gestureFunc;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: gestureFunc,
        child: Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(13.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    imageWid,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                labelText,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: sidesColor,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
