import 'package:flutter/material.dart';

import '../utils/Common.dart';

class CustomButton extends StatefulWidget {
  String buttonText;
  var textColor;
  var backgroundColor;
  bool isBorder;
  var borderColor;
  var onclickFunction;

  CustomButton(
      {Key? key,
      required this.buttonText,
      required this.textColor,
      required this.backgroundColor,
      required this.isBorder,
      required this.borderColor,
      required this.onclickFunction})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState(
      buttonText: buttonText,
      textColor: textColor,
      backgroundColor: backgroundColor,
      isBorder: isBorder,
      borderColor: borderColor,
      onclickFunction: onclickFunction);
}

class _CustomButtonState extends State<CustomButton> {
  String buttonText;
  var textColor;
  var backgroundColor;
  var isBorder;
  var borderColor;
  var onclickFunction;

  _CustomButtonState(
      {required this.buttonText,
      required this.textColor,
      required this.backgroundColor,
      required this.isBorder,
      required this.borderColor,
      required this.onclickFunction});

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.sizeOf(context);
    return SizedBox(
      height: 50.0,
      width: displaySize.width * 0.85,
      child: TextButton(
        onPressed: onclickFunction,
        style: (isBorder == true)
            ? TextButton.styleFrom(
                backgroundColor: backgroundColor,
                side: BorderSide(color: borderColor, width: 1),
              )
            : TextButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontFamily: 'Raleway-SemiBold'),
        ),
      ),
    );
  }
}
