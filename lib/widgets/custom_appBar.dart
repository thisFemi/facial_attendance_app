import 'package:flutter/material.dart';

import '../utils/colors.dart';

AppBar CustomAppBar(
    {String? title,
    required BuildContext context,
    bool? centerTitle,
    required bool showArrowBack,
    List<Widget>? actions}) {
  return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      actions: actions,
      title: Text(
        title!,
        style: TextStyle(color: AppColors.black),
      ),
      leading: showArrowBack
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: AppColors.lightGrey, shape: BoxShape.circle),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                  size: 16,
                ),
              ))
          : SizedBox.shrink());
}
