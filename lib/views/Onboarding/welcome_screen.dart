import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/views/Auth/authentication_screen.dart';
import 'package:attend_sense/views/Auth/register.dart';
import 'package:flutter/material.dart';

import '../../helpers/routes.dart';
import '../../utils/Common.dart';
import '../../utils/images.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/slider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Easy Attendance ',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/slider1.png',
    },
    {
      'title': 'Facial Recognition ',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/slider2.png',
    },
    {
      'title': 'Easy Registration',
      'description':
          'Students and Staff can do all necessary registration from the comfort of their home.',
      'image': 'assets/images/slider3.png',
    }
  ];
  void _onPageChanges(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.sizeOf(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.black,
        body: SizedBox(
            height: displaySize.height,
            width: displaySize.width,
            child: Stack(
              // height: displaySize.height * 0.5,
              alignment: Alignment.center,
              children: [
                Positioned(
                    child: SizedBox(
                  width: displaySize.width,
                  height: displaySize.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                        image: AssetImage(mainScreenBg),
                      ),
                    ),
                    child: const Text(
                      '',
                    ),
                  ),
                )),
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            'Hello',
                            style: TextStyle(
                                color: AppColors.lightGrey, fontSize: 50.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Welcome to AAUA E-Attendance App',
                            style: TextStyle(
                                color: AppColors.lightGrey, fontSize: 18.0),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20.0),
                        //   child: Text(
                        //     'By Okundalaye Abiola (170404032)  ',
                        //     style: TextStyle(color: AppColors.lightGrey, fontSize: 18.0),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )),
                Positioned(
                    bottom: displaySize.height * 0.02,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton(
                              buttonText: 'Login',
                              textColor: AppColors.white,
                              backgroundColor: AppColors.black,
                              isBorder: false,
                              borderColor: AppColors.white,
                              onclickFunction: () {
                                // Routes(context: context)
                                //     .navigate(StudentAuthScreen());
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton( 
                              buttonText: 'Register',
                              textColor: AppColors.black,
                              backgroundColor: AppColors.white,
                              isBorder: true,
                              borderColor: AppColors.black,
                              onclickFunction: () {
                                Routes(context: context)
                                    .navigate(const RegisterScreen());
                              }),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
