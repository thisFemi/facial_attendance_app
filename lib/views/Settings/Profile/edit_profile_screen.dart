import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../../api/apis.dart';
import '../../../models/user_model.dart';
import '../../../utils/Common.dart';
import '../../../utils/colors.dart';
import '../../../utils/dialogs.dart';
import '../../../widgets/custom_appBar.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  User userInfo;
  EditProfileScreen({required this.userInfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _keyForm = GlobalKey<FormState>();

  String? _image;
  String initialCountry = 'NG';
  PhoneNumber? number;
  @override
  void initState() {
    super.initState();
    initValues();
  }

  void initValues() {
    if (widget.userInfo.phoneNumber == "" ||
        widget.userInfo.phoneNumber == null) {
      number = PhoneNumber(isoCode: 'NG');
    } else {
      number = parsePhoneNumber(APIs.userInfo.phoneNumber);
    }
  }

  _updateProfileClk() async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
      if (widget.userInfo.userType==UserType.student && APIs.userInfo.userInfo!.imgUrl=="") {
         Dialogs.showSnackbar(context, 'You need to upload your image');
      return;
    }
    Dialogs.showProgressBar(context);
    _keyForm.currentState!.save();
    await APIs.updateUserInfo().then((value) {}).catchError((onError) {
      Navigator.pop(context);
      Dialogs.showSnackbar(context, onError);
    });

    Navigator.pop(context);
    Dialogs.showSnackbar(context, 'Profile Updated Successfully');

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppBar(
              centerTitle: true,
              context: context,
              showArrowBack: true,
              actions: [
                GestureDetector(
                  onTap: () => _updateProfileClk(),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                )
              ],
              title: "Attendance"),
          body: SingleChildScrollView(
              child: Container(
                  // height: Screen.deviceSize(context).height,
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  _image != null
                                      ? InkWell(
                                          onTap: () {
                                            widget.userInfo.userType ==
                                                    UserType.student||APIs.userInfo.userInfo!.imgUrl  ==""
                                                ? _showBtnSht()
                                                : null;
                                          },
                                          borderRadius: BorderRadius.circular(
                                              Screen.deviceSize(context)
                                                      .height *
                                                  .04),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Screen.deviceSize(context)
                                                        .height *
                                                    .1),
                                            child: Image.file(
                                              File(_image!),
                                              height: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              width: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              fit: BoxFit.fill,
                                            ),
                                          ))
                                      : InkWell(
                                          onTap: () {
                                            _showBtnSht();
                                          },
                                          borderRadius: BorderRadius.circular(
                                              Screen.deviceSize(context)
                                                      .height *
                                                  .04),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Screen.deviceSize(context)
                                                        .height *
                                                    .04),
                                            child: CachedNetworkImage(
                                              height: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              width: Screen.deviceSize(context)
                                                      .height *
                                                  .12,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  APIs.userInfo.userInfo != null
                                                      ? APIs.userInfo.userInfo!
                                                          .imgUrl
                                                      : "",
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const CircleAvatar(
                                                child:
                                                    Icon(CupertinoIcons.person),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width:
                                          25.0, // Adjust the width as needed for the camera circle
                                      height:
                                          25.0, // Adjust the height as needed for the camera circle
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: AppColors.black,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: Form(
                              key: _keyForm,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const Text('Full Name'),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    initialValue: widget.userInfo.name,
                                    onChanged: (newValue) =>
                                        APIs.userInfo.name = newValue ?? '',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        hintText: 'your name',
                                        hintStyle: const TextStyle(
                                            color: AppColors.grey),
                                        labelStyle: const TextStyle(
                                            color: AppColors.grey,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        // focusColor: Colors.grey[300],
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        prefixIcon: const Icon(Icons.person)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "name can't be empty";
                                      } else if (value.length < 3) {
                                        return "name too short";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Email Address'),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    initialValue: widget.userInfo.email,
                                    onSaved: (newValue) =>
                                        APIs.userInfo.email ?? '',
                                    enabled: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        hintStyle: const TextStyle(
                                            color: AppColors.grey),
                                        labelStyle: const TextStyle(
                                            color: AppColors.grey,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        disabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        prefixIcon:
                                            const Icon(CupertinoIcons.mail)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "email can't be empty";
                                      } else if (!value.contains('@')) {
                                        return "invalid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  // ignore: prefer_const_constructors
                                  SizedBox(height: 10),
                                  const Text('Phone Number'),
                                  const SizedBox(height: 10),
                                  InternationalPhoneNumberInput(
                                    spaceBetweenSelectorAndTextField: .1,
                                    inputDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintStyle: const TextStyle(
                                          color: AppColors.grey),
                                      labelStyle: const TextStyle(
                                          color: AppColors.grey,
                                          fontFamily: 'Raleway-SemiBold',
                                          fontSize: 15.0),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      disabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.all(10),
                                    ),
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                    },
                                    onInputValidated: (bool value) {
                                      print(value);
                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        const TextStyle(color: Colors.black),
                                    initialValue: number,
                                    formatInput: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    onSaved: (PhoneNumber number) {
                                      APIs.userInfo.phoneNumber =
                                          number.toString();
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  widget.userInfo.userType == UserType.student
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              const Text('Matric Number'),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                    enabled:APIs
                                                        .userInfo
                                                        .userInfo!
                                                        .matricNumber==""?true:false ,
                                                initialValue:
                                                    widget.userInfo
                                                        .userInfo!
                                                        .matricNumber,
                                                onChanged: (newValue) => APIs
                                                        .userInfo
                                                        .userInfo!
                                                        .matricNumber =
                                                    newValue ?? "",
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintText: 'your matric',
                                                    hintStyle: const TextStyle(
                                                        color: AppColors.grey),
                                                    labelStyle: const TextStyle(
                                                        color: AppColors.grey,
                                                        fontFamily:
                                                            'Raleway-SemiBold',
                                                        fontSize: 15.0),
                                                    border: const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    // focusColor: Colors.grey[300],
                                                    contentPadding: const EdgeInsets.all(10),
                                                    prefixIcon: const Icon(Icons.book)),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "matric number can't be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                            ])
                                      : SizedBox.shrink()
                                ],
                              ),
                            ))
                      ])))),
    );
  }

  void _showBtnSht() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: Screen.deviceSize(context).height * 0.03,
                  bottom: Screen.deviceSize(context).height * 0.05),
              children: [
                const Text(
                  'Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Screen.deviceSize(context).height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              Screen.deviceSize(context).width * .3,
                              Screen.deviceSize(context).height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            log('Image Path :${image.path}');
                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(context, File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/add_image.png')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              Screen.deviceSize(context).width * .3,
                              Screen.deviceSize(context).height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            log('Image Path :${image.path}');
                            setState(() {
                              _image = image.path;
                            });
                            APIs.updateProfilePicture(context, File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/camera.png'))
                  ],
                )
              ],
            ));
  }
}
