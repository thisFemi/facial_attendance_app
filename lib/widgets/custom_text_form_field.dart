import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomTextFormField extends StatefulWidget {
  double height = 5.0;
  String hint;
  IconData icon;
  TextInputType textInputType;
  Color backgroundColor;
  Color iconColor;
  bool isIconAvailable;
  bool readOnly = false;
  var validation, maxLength, onSaved;
  bool obscureText;
  TextEditingController controller;

  CustomTextFormField(
      {Key? key,
      this.maxLength,
      required this.height,
      required this.hint,
      required this.icon,
      required this.readOnly,
      required this.textInputType,
      required this.backgroundColor,
      required this.iconColor,
      required this.isIconAvailable,
      required this.validation,
      required this.onSaved,
      required this.controller,
      required this.obscureText})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState(
      height: height,
      maxLength: maxLength,
      hint: hint,
      icon: icon,
      readOnly: readOnly,
      textInputType: textInputType,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      controller: controller,
      isIconAvailable: isIconAvailable,
      onSaved: onSaved,
      validation: validation,
      obscureText: obscureText);
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  double height = 5.0;
  String hint;
  bool readOnly;
  IconData icon;
  TextInputType textInputType;
  Color backgroundColor;
  Color iconColor;
  bool isIconAvailable;
  var validation, maxLength, onSaved;
  bool obscureText;
  TextEditingController controller;

  _CustomTextFormFieldState(
      {this.maxLength,
      required this.height,
      required this.hint,
      required this.icon,
      required this.readOnly,
      required this.textInputType,
      required this.backgroundColor,
      required this.iconColor,
      required this.isIconAvailable,
      required this.onSaved,
      required this.validation,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          hint,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          maxLength: maxLength,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscureText,
          cursorColor: AppColors.black,
          keyboardType: textInputType,
          onSaved: onSaved,
          validator: validation,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            hintStyle: TextStyle(color: AppColors.grey),
            hintText: hint,
            counterStyle: const TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            labelStyle: TextStyle(
                color: AppColors.grey,
                fontFamily: 'Raleway-SemiBold',
                fontSize: 15.0),
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            prefixIcon: (isIconAvailable == true)
                ? Icon(
                    icon,
                    color: iconColor,
                  )
                : const SizedBox.shrink(),
            disabledBorder: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
