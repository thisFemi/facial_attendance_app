import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    print("status : ${isPresent}");
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          title:
              Text(lectuerName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(DateUtil.formatDateTime(date)),
          trailing: Chip(
              backgroundColor: isPresent ? AppColors.green : AppColors.red,
              label: Text(
                "${isPresent ? "Present" : "Absent"}",
                style: const TextStyle(
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          title: Text(
            student.matricNumber,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black),
          ),
          subtitle: Text(student.studentName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: student.isPresent
              ? Chip(
                  onDeleted: () {
                    onTap();
                  },
                  backgroundColor: AppColors.red,
                  label: const Text(
                    "Remove",
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold),
                  ))
              : const Chip(
                  backgroundColor: AppColors.lightGrey,
                  label: Text("Absent",
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold)))),
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
    bool open = attendance.endTime.isAfter(DateTime.now());
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: ListTile(
          onLongPress: () {
            if (open) {
              showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                        children: [
                          const Align(
                              alignment: Alignment.center,
                              child: Text("Verification Code",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.lightGrey),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(attendance.verificationCode),
                                  IconButton(
                                      onPressed: () {
                                        copyText(attendance.verificationCode);
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.content_copy_rounded))
                                ]),
                          )
                        ],
                      ));
            }
          },
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
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.black),
          ),
          subtitle: Text(DateUtil.getNormalDate(attendance.startTime)),
          trailing: Chip(
              backgroundColor: open ? AppColors.green : AppColors.red,
              label: Text(
                open ? "Open" : "Closed",
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }

  copyText(String text) async {
    await Clipboard.setData(new ClipboardData(text: text));
  }
}
