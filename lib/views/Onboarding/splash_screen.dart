import 'dart:async';

import 'package:attend_sense/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:attend_sense/utils/images.dart';
import 'package:attend_sense/views/Onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../../helpers/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool isTimerInitialized = false;

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (isTimerInitialized) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final  displaySize = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: displaySize.width * 0.5,
                  child: Image.asset(logo),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SpinKitThreeBounce(color:AppColors.primaryColor, size: 40),
            ],
          ),
          Positioned(
              bottom: 0.0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'AAUA e-Attendance',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'v1.0',
                      style: const TextStyle(fontSize: 11.0),
                    ),
                  )
                ],
              ))
        ],
      )),
    );
  }

  void startApp() async {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) async {
      isTimerInitialized = true;
      _timer.cancel();
     Routes(context: context).navigateReplace(WelcomeScreen());
    });
  }
}
