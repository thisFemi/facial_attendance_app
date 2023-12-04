import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/attendance_models.dart';
import '../utils/colors.dart';
import '../utils/date_util.dart';
import '../utils/dialogs.dart';
import '../views/CourseList/students_attendance_list.dart';

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
  Attendance attendance;
  Session session;
  Semester semester;
  Course course;
  StudentData student;
  Function onTap;

  StudentAttendanceCard(
      {super.key,
      required this.attendance,
      required this.course,
      required this.semester,
      required this.onTap,
      required this.session,
      required this.student});
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          title: Text(
            student.matricNumber,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black),
          ),
          subtitle: Text(student.studentName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Chip(
              onDeleted: () {
                onTap();
              },
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

class AttendanceCard extends StatelessWidget {
  Attendance attendance;
  Session session;
  Semester semester;
  Course course;

  AttendanceCard(
      {super.key,
      required this.attendance,
      required this.course,
      required this.semester,
      required this.session});

  @override
  Widget build(BuildContext context) {
    bool open = attendance.endTime.isBefore(DateTime.now());
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => StudentAttendanceList(
                          course: course,
                          semester: semester,
                          session: session,
                          attendance: attendance,
                        )));
          },
          title: Text(
            attendance.lecturerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black),
          ),
          subtitle: Text(DateUtil.getNormalDate(attendance.startTime)),
          trailing: Chip(
              backgroundColor: open ? AppColors.green : AppColors.red,
              label: Text(
                open ? "Open" : "Closed",
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }
}
