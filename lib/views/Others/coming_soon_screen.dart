import 'package:flutter/material.dart';

import '../../utils/colors.dart';


class ComingSoon extends StatelessWidget {
   ComingSoon({Key? key, required this.label}) : super(key: key);
  String label;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(

        title:  Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // titleTextStyle:TextStyle(fontWeight: FontWeight.bold ,color: color3),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
        Image.asset(
          'assets/images/coming_soon.png',
          scale: 1,
        ),
        SizedBox(height: 2,),
        Text("${label} is coming soon", style:TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold)),

        SizedBox(height: 5,),
            Text("We'll let you know when it is ready", style:TextStyle(

                color: Colors.grey[300],
                fontWeight: FontWeight.bold)),
      ])),
    );
  }
}
