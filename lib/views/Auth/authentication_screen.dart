import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../models/theme.dart';
import '../../utils/images.dart';
import '../../provider/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    ThemeMode currentThemeMode =
        Provider.of<ThemeModel>(context, listen: false).themeMode;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        // color: Colors.white,
        // padding: EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 50),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: deviceSize.height - deviceSize.height * .7,
              width: deviceSize.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 80,
                      child: Image.asset(
                        white_logo,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: SizedBox(
                      child: Text('Welcome to Attend Sense',
                          style: TextStyle(fontSize: 42, fontFamily: 'K2D')),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                        'Sign up or login to take your\nattendance,class session, and manage your lectures'),
                  )
                ],
              ),
            ),
            Center(child: Text('Step 1/4')),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: StepProgressIndicator(
                roundedEdges: Radius.circular(10),
                totalSteps: 4,
                currentStep: 1,
                size: 10,
                selectedColor: currentThemeMode == ThemeMode.light
                    ? lightTheme.primaryColor
                    : darkTheme.primaryColor,
                unselectedColor: Colors.grey.withOpacity(.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text('Hello User,',
                        style: TextStyle(fontSize: 42, fontFamily: 'K2D')),
                  ),
                  SizedBox(
                      child: Text('How would you like to join us?',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'K2D',
                              letterSpacing: 1)))
                ],
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: deviceSize.width,
                  height: deviceSize.height * .07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 3,
                        color: currentThemeMode == ThemeMode.light
                            ? lightTheme.primaryColor
                            : darkTheme.primaryColor,
                      )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/google_logo.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Sign up with Google',
                        style: TextStyle(
                            fontFamily: 'K2D',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(child: Text('or')),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Full name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'K2D',
                        letterSpacing: 1)),
                TextFormField(),
                SizedBox(
                  height: 30,
                ),
                Text('Email address ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'K2D',
                        letterSpacing: 1)),
                TextFormField()
              ],
            )),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: deviceSize.width / 2.5,
                height: deviceSize.height * .07,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.5),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontFamily: 'K2D'),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
