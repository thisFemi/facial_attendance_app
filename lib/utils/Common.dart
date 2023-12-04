import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Screen {
  static Size deviceSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }
}

 PhoneNumber parsePhoneNumber(String phoneNumberString) {
    // Remove unnecessary characters and split the string to extract values
    phoneNumberString =
        phoneNumberString.replaceAll('PhoneNumber(', '').replaceAll(')', '');
    List<String> parts = phoneNumberString.split(', ');

    String phoneNumber = parts[0].split(': ')[1];
    String dialCode = parts[1].split(': ')[1];
    String isoCode = parts[2].split(': ')[1];

    return PhoneNumber(
      phoneNumber: phoneNumber,
      dialCode: dialCode,
      isoCode: isoCode,
    );
  }