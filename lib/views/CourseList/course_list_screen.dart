import 'package:attend_sense/views/CourseList/course_attendance_list_screen.dart';
import 'package:attend_sense/widgets/attendance_card.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/course_card.dart';
import '../../widgets/custom_appBar.dart';
import 'students_attendance_list.dart';

class CourseScreen extends StatelessWidget {
   CourseScreen({super.key});
  bool isLecturer = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CustomAppBar(
          centerTitle: true,
          context: context,
          showArrowBack: true,
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Add',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.lightWhite),
                ),
              ),
            ),
          ],
          title: "Courses"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Registred Courses : 20",
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
                    return CourseCard(
                        progress: .30,
                        showPecentage: true,
                        onTap: () {
                        
                          if (isLecturer) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CourseAttendanceScreen(
                                        // user: widget.user,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StudentAttendanceList(
                                        // user: widget.user,
                                        )));
                          }
                        },
                        title: "CSC301");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
