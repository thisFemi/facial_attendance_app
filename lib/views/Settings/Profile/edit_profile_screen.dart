import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../utils/dialogs.dart';

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
    Dialogs.showProgressBar(context);
    _keyForm.currentState!.save();
    await APIs.updateUserInfo(context).then((value) {}).catchError((onError) {
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
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(CupertinoIcons.back)),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () => _updateProfileClk(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Save'),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Container(
                  // height: Screen.deviceSize(context).height,
                  padding: EdgeInsets.only(top: 40, bottom: 20),
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
                                                  APIs.userInfo.image ?? "",
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
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
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: color3,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              widget.userInfo.userType.toLowerCase() == 'doctor'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${widget.userInfo.doctorContactInfo!.isVerified ? 'Verified' : 'Unverified'}'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            widget.userInfo.doctorContactInfo!
                                                    .isVerified
                                                ? CupertinoIcons
                                                    .checkmark_alt_circle
                                                : Icons.pending_outlined,
                                            color: widget
                                                    .userInfo
                                                    .doctorContactInfo!
                                                    .isVerified
                                                ? color13
                                                : color1,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 10, right: 10),
                            child: Form(
                              key: _keyForm,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Text('Full Name'),
                                  SizedBox(height: 10),
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
                                        hintStyle: TextStyle(color: color8),
                                        labelStyle: TextStyle(
                                            color: color8,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        // focusColor: Colors.grey[300],
                                        contentPadding: EdgeInsets.all(10),
                                        prefixIcon: Icon(Icons.person)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "name can't be empty";
                                      } else if (value.length < 3) {
                                        return "name too short";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Text('Email Address'),
                                  SizedBox(height: 10),
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
                                        hintStyle: TextStyle(color: color8),
                                        labelStyle: TextStyle(
                                            color: color8,
                                            fontFamily: 'Raleway-SemiBold',
                                            fontSize: 15.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        contentPadding: EdgeInsets.all(10),
                                        prefixIcon: Icon(CupertinoIcons.mail)),
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
                                  Text('Phone Number'),
                                  SizedBox(height: 10),
                                  InternationalPhoneNumberInput(
                                    spaceBetweenSelectorAndTextField: .1,
                                    inputDecoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      hintStyle: TextStyle(color: color8),
                                      labelStyle: TextStyle(
                                          color: color8,
                                          fontFamily: 'Raleway-SemiBold',
                                          fontSize: 15.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                    },
                                    onInputValidated: (bool value) {
                                      print(value);
                                    },
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        TextStyle(color: Colors.black),
                                    initialValue: number,
                                    formatInput: true,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    inputBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    onSaved: (PhoneNumber number) {
                                      APIs.userInfo.phoneNumber =
                                          number.toString();
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  "patient" == widget.userInfo.userType.toLowerCase()
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text('Home Address '),
                                              SizedBox(height: 10),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                initialValue: widget
                                                        .userInfo
                                                        .patientContactInfo!
                                                        .clinicAddress ??
                                                    "",
                                                maxLines: 2,
                                                onSaved: (newValue) => APIs
                                                        .userInfo
                                                        .patientContactInfo!
                                                        .clinicAddress =
                                                    newValue ?? '',
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    hintStyle: TextStyle(
                                                        color: color8),
                                                    labelStyle: TextStyle(
                                                        color: color8,
                                                        fontFamily:
                                                            'Raleway-SemiBold',
                                                        fontSize: 15.0),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    disabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    contentPadding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                                                    prefixIcon: Icon(CupertinoIcons.home)),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "address can't be empty";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ])
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              MultipleSearchSelection<
                                                  Specialization>.creatable(
                                                title: Text(
                                                  'Specialization',
                                                ),

                                                onPickedChange: (data) {
                                                  setState(() {
                                                    userSpecilizations = data;
                                                    APIs
                                                            .userInfo
                                                            .doctorContactInfo!
                                                            .specilizations =
                                                        userSpecilizations;
                                                  });
                                                },
                                                initialPickedItems:
                                                    userSpecilizations,
                                                onItemAdded: (c) {},
                                                showClearSearchFieldButton:
                                                    true,
                                                createOptions: CreateOptions(
                                                  createItem: (text) {
                                                    return Specialization(
                                                        title: text);
                                                  },
                                                  onItemCreated: (c) => print(
                                                      'Specilization ${c.title} created'),
                                                  createItemBuilder: (text) =>
                                                      Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          'Create "$text"'),
                                                    ),
                                                  ),
                                                  pickCreatedItem: false,
                                                ),
                                                items:
                                                    specialization, // List<Country>
                                                fieldToCheck: (c) {
                                                  return c.title;
                                                },
                                                itemBuilder: (country, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 20.0,
                                                          horizontal: 12,
                                                        ),
                                                        child:
                                                            Text(country.title),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                pickedItemBuilder: (country) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text(
                                                        country.title,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                searchFieldInputDecoration:
                                                    InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  hintStyle:
                                                      TextStyle(color: color8),
                                                  hintText:
                                                      'Type here to search',
                                                  labelStyle: TextStyle(
                                                      color: color8,
                                                      fontFamily:
                                                          'Raleway-SemiBold',
                                                      fontSize: 15.0),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                ),
                                                sortShowedItems: true,
                                                sortPickedItems: true,
                                                selectAllButton: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.blue),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Select All',
                                                        // style: kStyleDefault,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                clearAllButton: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.red),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Clear All',
                                                        // style: kStyleDefault,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                caseSensitiveSearch: true,
                                                fuzzySearch: FuzzySearch.none,
                                                itemsVisibility:
                                                    ShowedItemsVisibility
                                                        .onType,
                                                showSelectAllButton: false,
                                                maximumShowItemsHeight:
                                                    Screen.deviceSize(context)
                                                            .height *
                                                        .3,
                                                clearSearchFieldOnSelect: true,
                                                maxSelectedItems: 5,
                                                showItemsButton:
                                                    Icon(Icons.clear),

                                                // This trailing comma makes auto-formatting nicer for build methods.
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Schedules',
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                ////  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'Available Period',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                height: Screen.deviceSize(
                                                                            context)
                                                                        .height *
                                                                    .05,
                                                                width: Screen.deviceSize(
                                                                            context)
                                                                        .width *
                                                                    .3,
                                                                child:
                                                                    DropdownButton2<
                                                                        String>(
                                                                  isExpanded:
                                                                      true,
                                                                  hint:
                                                                      SizedBox(
                                                                    child: Text(
                                                                        'Period',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        )),
                                                                  ),
                                                                  items: periods.map<
                                                                          DropdownMenuItem<
                                                                              String>>(
                                                                      (period) {
                                                                    return DropdownMenuItem<
                                                                            String>(
                                                                        value:
                                                                            period,
                                                                        child: SizedBox(
                                                                            child: Text(period,
                                                                                style: TextStyle(
                                                                                  fontSize: 11,
                                                                                ))));
                                                                  }).toList(),
                                                                  value:
                                                                      selectedPeriod,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      selectedPeriod =
                                                                          value;
                                                                      if (value!
                                                                          .contains(
                                                                              'A Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.aMonth;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Next 2 Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.twoMonths;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Next 6 Month')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.sixMonths;
                                                                      } else if (value
                                                                          .contains(
                                                                              'Always Available')) {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.everyTime;
                                                                      } else {
                                                                        selectedDuration =
                                                                            AvailabilityDuration.notAvailable;
                                                                      }
                                                                    });
                                                                    APIs
                                                                        .userInfo
                                                                        .doctorContactInfo!
                                                                        .selectedDuration = selectedDuration!;
                                                                  },
                                                                  buttonStyleData:
                                                                      ButtonStyleData(
                                                                          // height: deviceSize.height * .04,
                                                                          // padding: EdgeInsets.only(left: 10, right: 10),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                ),
                                                              ),
                                                            ]),
                                                        Spacer(),
                                                        selectedDuration !=
                                                                AvailabilityDuration
                                                                    .notAvailable
                                                            ? Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 10,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        'Daily Time Availability',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        )),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                Screen.deviceSize(context).height * .05,
                                                                            width:
                                                                                Screen.deviceSize(context).width * .26,
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: SizedBox(
                                                                                  child: Text('From',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                      )),
                                                                                ),
                                                                                items: workHours.map<DropdownMenuItem<String>>((period) {
                                                                                  return DropdownMenuItem<String>(
                                                                                      value: period,
                                                                                      child: SizedBox(
                                                                                          child: Text(period,
                                                                                              style: TextStyle(
                                                                                                fontSize: 11,
                                                                                              ))));
                                                                                }).toList(),
                                                                                value: selectedFrom,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedFrom = value;

                                                                                    selectedTo = null;
                                                                                  });
                                                                                  APIs.userInfo.doctorContactInfo!.startTime = selectedFrom!;
                                                                                },
                                                                                buttonStyleData: ButtonStyleData(
                                                                                    // height: deviceSize.height * .04,
                                                                                    // padding: EdgeInsets.only(left: 10, right: 10),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          SizedBox(
                                                                            height:
                                                                                Screen.deviceSize(context).height * .05,
                                                                            width:
                                                                                Screen.deviceSize(context).width * .26,
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: SizedBox(
                                                                                  child: Text('To',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14,
                                                                                      )),
                                                                                ),
                                                                                items: (workHours.indexOf(selectedFrom!) != workHours.length - 1)
                                                                                    ? workHours.where((period) => workHours.indexOf(period) > workHours.indexOf(selectedFrom!)).map<DropdownMenuItem<String>>((period) {
                                                                                        return DropdownMenuItem<String>(
                                                                                          value: period,
                                                                                          child: SizedBox(
                                                                                            child: Text(
                                                                                              period,
                                                                                              style: TextStyle(
                                                                                                fontSize: 12,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }).toList()
                                                                                    : [],
                                                                                value: selectedTo,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedTo = value;
                                                                                  });
                                                                                  APIs.userInfo.doctorContactInfo!.endTime = selectedTo!;
                                                                                },
                                                                                buttonStyleData: ButtonStyleData(
                                                                                    // height: deviceSize.height * .04,
                                                                                    // padding: EdgeInsets.only(left: 10, right: 10),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Theme.of(context).colorScheme.secondary))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]),

                                                                  ],
                                                                ))
                                                            : SizedBox.shrink()
                                                      ])),
                                            SizedBox(height: 10),
                                            Text('Office/Hospital Address '),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              keyboardType: TextInputType.text,
                                              initialValue: widget.userInfo
                                                  .doctorContactInfo!.clinicAddress ??
                                                  "",
                                              maxLines: 2,
                                              onSaved: (newValue) => APIs
                                                  .userInfo
                                                  .doctorContactInfo!
                                                  .clinicAddress = newValue ?? '',
                                              autovalidateMode:
                                              AutovalidateMode.onUserInteraction,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  hintStyle: TextStyle(color: color8),
                                                  labelStyle: TextStyle(
                                                      color: color8,
                                                      fontFamily: 'Raleway-SemiBold',
                                                      fontSize: 15.0),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  disabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  contentPadding: EdgeInsets.only(
                                                      top: 20,
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 20),
                                                  prefixIcon: Icon(CupertinoIcons.home)),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "address can't be empty";
                                                }
                                                return null;
                                              },
                                            ),
                                            ]),
                                  SizedBox(height: 10),

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
                Text(
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
                            shape: CircleBorder(),
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
                            shape: CircleBorder(),
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
