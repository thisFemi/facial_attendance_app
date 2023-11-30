import 'package:attend_sense/models/user_model.dart';
import 'package:attend_sense/views/CourseList/course_attendance_list_screen.dart';
import 'package:attend_sense/widgets/attendance_card.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/colors.dart';
import '../../widgets/course_card.dart';
import '../../widgets/custom_appBar.dart';
import 'students_attendance_list.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({required this.semester, required this.session});

  Session session;

  Semester semester;

  bool isLecturer = APIs.userInfo.userType == UserType.staff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          centerTitle: true,
          context: context,
          showArrowBack: true,
          actions: [
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     margin: EdgeInsets.all(15),
            //     padding: EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         color: AppColors.black,
            //         borderRadius: BorderRadius.circular(5)),
            //     child: Text(
            //       'Add',
            //       style: const TextStyle(
            //           fontWeight: FontWeight.bold, color: AppColors.lightWhite),
            //     ),
            //   ),
            // ),
          ],
          title: "Courses"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Registred Courses : ${semester.courses.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: semester.courses.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final course = semester.courses[index];
                    return CourseCard(
                        progress: course.calculateAttendancePercentage(),
                        showPecentage: true,
                        onTap: () {
                          if (!isLecturer) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CourseAttendanceScreen(
                                          attendances: course.attendanceList,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AttendanceList(
                                          course: course,
                                          semester: semester,
                                          session: session,
                                        )));
                          }
                        },
                        title: course.courseId);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
