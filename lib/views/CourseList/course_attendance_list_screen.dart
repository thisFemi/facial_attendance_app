import 'package:attend_sense/widgets/attendance_card.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/course_card.dart';
import '../../widgets/custom_appBar.dart';

class CourseAttendanceScreen extends StatelessWidget {
  CourseAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          centerTitle: true,
          context: context,
          showArrowBack: true,
          title: "Attendance"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Course Attendance : ${attendance.length}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: attendance.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return LecturerAttendanceCard(
                      date: attendance[index].date,
                      isPresent: attendance[index].isPresent,
                      lectuerName: attendance[index].lectuerName,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  final attendance = [
    LecturerAttendanceCard(
      date: DateTime.now(),
      isPresent: false,
      lectuerName: "Dr. Ogunmepon",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 7, 17, 30),
      isPresent: true,
      lectuerName: "Dr. Ajayi",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 8, 17, 30),
      isPresent: false,
      lectuerName: "Dr. Aranuwa",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 1, 15, 30),
      isPresent: false,
      lectuerName: "Dr. Mrs Ogbeide",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 2, 17, 30),
      isPresent: true,
      lectuerName: "Dr. Ajayi",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 10, 17, 30),
      isPresent: false,
      lectuerName: "Dr. Mrs Aliyu",
    ),
    LecturerAttendanceCard(
      date: DateTime(2023, 9, 8, 17, 30),
      isPresent: false,
      lectuerName: "Mr Ojo",
    ),
  ];
}
