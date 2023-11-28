import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/date_util.dart';

class LecturerAttendanceCard extends StatelessWidget {
  LecturerAttendanceCard(
      {super.key,
      required this.date,
      required this.isPresent,
      required this.lectuerName});
  String lectuerName;
  bool isPresent;
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          title:
              Text(lectuerName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(DateUtil.formatDateTime(date)),
          trailing: Chip(
              backgroundColor: isPresent ? AppColors.green : AppColors.red,
              label: Text(
                "${isPresent ? "Present" : "Absent"}",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  String matricNumber;
  String name;

  StudentAttendanceCard(
      {super.key, required this.matricNumber, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
        
          title: Text(
            matricNumber,
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 16,
             color: AppColors.black),
          ),
          subtitle: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Chip(
              onDeleted: () {},
              backgroundColor: AppColors.red,
              label: Text(
                "Remove",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold),
              ))),
    );
    
  }
}
