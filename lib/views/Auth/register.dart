import 'package:attend_sense/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../api/apis.dart';
import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../Dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool termsAndConditionCheck = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm_password = TextEditingController();

  TextEditingController _usertType = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedType = '';

  // final RegisterController _registerController = RegisterController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm_password.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occured'),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  var _isLoading = false;
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await APIs.register(_name.text, _email.text, _password.text,
              selectedType == "Student" ? UserType.student : UserType.staff)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
            (route) => false);
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Dialogs.showSnackbar(context, error.toString());
    }
   
  }

  bool passwordConfirmed() {
    if (_password.text.trim() == _confirm_password.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.offwhite,
      body: SafeArea(
          child: SizedBox(
              height: displaySize.height,
              width: displaySize.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back))),
                      const Center(
                        child: Text(
                          'Registration',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _name,
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      isIconAvailable: true,
                                      hint: 'Name',
                                      icon: Icons.person,
                                      textInputType: TextInputType.emailAddress,
                                      validation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "name can't be empty";
                                        }

                                        return null;
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _email,
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      isIconAvailable: true,
                                      hint: 'Email Address',
                                      icon: Icons.email_outlined,
                                      textInputType: TextInputType.emailAddress,
                                      validation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Email can't be empty";
                                        } else if (!(value
                                                .toString()
                                                .contains("@")) ||
                                            !(value
                                                .toString()
                                                .endsWith(".com"))) {
                                          return "invalid email address";
                                        }
                                        return null;
                                      },
                                      obscureText: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: GestureDetector(
                                    onTap: () => _showUsertTypes(),
                                    child: AbsorbPointer(
                                      child: CustomTextFormField(
                                          onSaved: (value) {},
                                          readOnly: false,
                                          height: 5.0,
                                          controller: _usertType,
                                          backgroundColor: AppColors.white,
                                          iconColor: AppColors.black,
                                          isIconAvailable: true,
                                          hint: 'User Type',
                                          icon: Icons
                                              .supervised_user_circle_rounded,
                                          textInputType:
                                              TextInputType.emailAddress,
                                          validation: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "name can't be empty";
                                            }

                                            return null;
                                          },
                                          obscureText: false),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _password,
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      isIconAvailable: true,
                                      hint: 'Password',
                                      icon: Icons.lock_open,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "passord can't be empty";
                                        } else if (value.length < 7) {
                                          return "password too short";
                                        }
                                        return null;
                                      },
                                      obscureText: true),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      onSaved: (value) {},
                                      readOnly: false,
                                      height: 5.0,
                                      controller: _confirm_password,
                                      backgroundColor: AppColors.white,
                                      iconColor: AppColors.black,
                                      isIconAvailable: true,
                                      hint: 'Confirm Password',
                                      icon: Icons.lock_open,
                                      textInputType: TextInputType.text,
                                      validation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "password can't be empty";
                                        } else if (value != _password.text) {
                                          return "passwords not mathed";
                                        }
                                        return null;
                                      },
                                      obscureText: true),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Checkbox(
                                          checkColor: AppColors.black,
                                          fillColor: MaterialStateProperty.all(
                                              AppColors.grey),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          value: termsAndConditionCheck,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              termsAndConditionCheck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: SizedBox(
                                          width: displaySize.width * 0.65,
                                          child: const Text(
                                            'By signing up I have agreed to the Terms & Conditions and Privacy Policy',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 45.0, vertical: 20.0),
                                //   child: CustomButton(
                                //       buttonText: 'SignUp',
                                //       textColor: AppColors.white,
                                //       backgroundColor: AppColors.black,
                                //       isBorder: false,
                                //       borderColor: AppColors.black,
                                //       onclickFunction: () {
                                //         FocusScope.of(context).unfocus();
                                //         if (termsAndConditionCheck == true) {
                                //           _signUp();
                                //         }
                                //       }),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 45,
                                    vertical: 5,
                                  ),
                                  child: SizedBox(
                                    height: 50.0,
                                    width: displaySize.width * 0.85,
                                    child: TextButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (termsAndConditionCheck == true) {
                                          _isLoading ? null : _signUp();
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColors.black,
                                      ),
                                      child: _isLoading
                                          ? SpinKitThreeBounce(
                                              color: AppColors.offwhite,
                                              size: 40)
                                          : Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontFamily:
                                                      'Raleway-SemiBold'),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  void _showUsertTypes() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Select Type',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Student',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          selectedType = 'Student';
                          _usertType.text = selectedType;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          selectedType = 'Lecturer';
                          _usertType.text = selectedType;
                        });
                        Navigator.pop(context);
                      },
                      leading: const Icon(Icons.supervisor_account_rounded),
                      title: const Text(
                        'Lecturer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  getShadow() {
    return <BoxShadow>[
      const BoxShadow(
        color: Colors.black12,
        spreadRadius: -2,
        blurRadius: 5,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ];
  }
}
