import 'package:attend_sense/utils/Common.dart';
import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/views/Auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../utils/dialogs.dart';
import '../Dashboard/dashboard_screen.dart';



class ErrorScreen extends StatelessWidget{
  String label;
  ErrorScreen({required this.label});
  @override
  Widget build(BuildContext context){
    return Container(
      color: AppColors.white,
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/not_connected.png',
          scale: 1,
        ),
        const SizedBox(height: 2,),
        Text(label, style:const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold)),

        const SizedBox(height: 5,),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
                height: 50.0,
                width: Screen.deviceSize(context).width*.8,
                child: TextButton(
                  onPressed:
                       ()async {
                    Dialogs.showProgressBar(context);
                

  if(APIs.auth.currentUser != null){
     Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (Route<dynamic> route) => false,
      );
      } else {

  
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (Route<dynamic> route) => false,
      );
      
      
}
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                         AppColors.black,
                  ),
                  child: const Text('Try again',
                      style: TextStyle(
                          color: AppColors.offwhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                )))
      ],
      ),),
    );
  }
}