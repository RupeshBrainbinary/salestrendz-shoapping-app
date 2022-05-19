import 'package:flutter/material.dart';

class Nav {
  static route(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => screen,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 280),
      ),
    );
  }

  static routeReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static routeRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen,), (route) => false);
  }
}
