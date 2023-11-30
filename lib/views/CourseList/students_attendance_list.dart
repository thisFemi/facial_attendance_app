import 'package:flutter/material.dart';

import '../../models/attendance_models.dart';
import '../../utils/colors.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/custom_appBar.dart';

class StudentAttendanceList extends StatelessWidget {
  StudentAttendanceList(
      {required this.course, required this.semester, required this.session});
  Session session;
  Course course;
  Semester semester;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title: "Attendance",
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Export',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.lightWhite),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Course Attendance: ${course.attendanceList.length}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: course.attendanceList.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final attendance = course.attendanceList[index];
                    return AttendanceCard(
                      attendance: attendance,
                      semester: semester,
                      session: session,
                      course: course,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
