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
              "Total Course Attendance : 20",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return LecturerAttendanceCard(
                      date: DateTime.now(),
                      isPresent: false,
                      lectuerName: "Ogunmepon",
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
