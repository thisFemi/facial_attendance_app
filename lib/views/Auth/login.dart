import 'dart:io';

import 'package:attend_sense/views/Auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/routes.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Dashboard/dashboard_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final LoginController _loginController = LoginController();
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  var _isLoading = false;
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    var key = 'email';
    setState(() {
      _isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => DashboardScreen(
                // user: widget.user,
                )),
        (route) => false);

    ;
  }

  void initState() {
    // _username.text = 'staff / business@gmail.com';
    // _username.text = 'admin3@clearance.aaua.edu.ng';
    // _password.text = '123456';

    //authProcess();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.sizeOf(context);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: AppColors.black,
    //     systemNavigationBarColor: AppColors.black,
    //     statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: SafeArea(
              child: SizedBox(
            height: displaySize.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Form(
                  key: _keyForm,
                  child: Stack(
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
                                    Colors.black.withOpacity(.2),
                                    BlendMode.dstATop),
                                image: AssetImage(loginScreenBg),
                              )),
                          child: const Text(''),
                        ),
                      )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                width: displaySize.width * .4,
                                height: displaySize.width * .3,
                                //  color: AppColors.white,
                                child: Center(
                                  child: SizedBox(
                                    width: displaySize.width * .3,
                                    child: Image.asset(logo),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.offwhite,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0))),
                            child: Column(children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              const Center(
                                child: Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: CustomTextFormField(
                                  readOnly: false,
                                  height: 5.0,
                                  controller: _username,
                                  backgroundColor: AppColors.white,
                                  iconColor: AppColors.black,
                                  isIconAvailable: true,
                                  hint: 'Staff Id/Username',
                                  icon: Icons.email_outlined,
                                  textInputType: TextInputType.text,
                                  onSaved: (value) {},
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email can't be empty";
                                    } else if (!(value
                                            .toString()
                                            .contains("@")) ||
                                        !(value.toString().endsWith(".com"))) {
                                      return "invalid email address";
                                    }
                                    return null;
                                  },
                                  obscureText: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: CustomTextFormField(
                                    height: 5.0,
                                    hint: 'Password',
                                    icon: Icons.lock_outlined,
                                    readOnly: false,
                                    textInputType: TextInputType.text,
                                    backgroundColor: AppColors.white,
                                    iconColor: AppColors.black,
                                    isIconAvailable: true,
                                    onSaved: (value) {},
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "passord can't be empty";
                                      } else if (value.length < 7) {
                                        return "password too short";
                                      }
                                      return null;
                                    },
                                    controller: _password,
                                    obscureText: true),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Forgot Password?',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 45,
                                  vertical: 5,
                                ),
                                child: SizedBox(
                                  height: 50.0,
                                  width: displaySize.width * 0.85,
                                  child: TextButton(
                                    onPressed: _submit,
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.black,
                                    ),
                                    child: _isLoading
                                        ? SpinKitThreeBounce(
                                            color: AppColors.offwhite, size: 40)
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontFamily: 'Raleway-SemiBold'),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 40.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => Routes(context: context)
                                        .navigate(RegisterScreen()),
                                    child: const Text(
                                      'No account yet, Register Now',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              )
                            ]),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          )),
        ));
  }
}
