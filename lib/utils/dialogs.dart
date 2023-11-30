import 'package:attend_sense/utils/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';


class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (_) => SimpleDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: [
          Padding(padding: EdgeInsets.symmetric(vertical:20), child:
          Column(
            children:[
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 10,),
              Text('Loading')
            ]
            ))]));
  }

  static void showSuccessDialog(
    BuildContext context,
    String title,
    String content,
    String textButton,
    VoidCallback? onOkClick,
  ) async {
    showAdaptiveDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             Padding(padding: EdgeInsets.all(15), child: Icon(
              CupertinoIcons.checkmark_seal_fill,
              size: 48,
              color: AppColors.black,
            ),),

              
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                ),
              ),
              // Wrap the button with Expanded to make it expand to the whole width
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      height: 50.0,
                      width: Screen.deviceSize(context).width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          if (onOkClick != null) {
                            onOkClick();
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.black,
                        ),
                        child: Text(textButton,
                            style: TextStyle(
                                color: AppColors.offwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
