import 'package:flutter/material.dart';

class Routes {
  BuildContext context;
  var data;

  Routes({required this.context, this.data});

  navigate(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  navigateWithReturn(Widget screen) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  navigateReplace(Widget screen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  back() {
    Navigator.pop(context);
  }
}
