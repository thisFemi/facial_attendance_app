import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/views/CourseList/academicslist_screen.dart';
import 'package:attend_sense/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';

import '../../models/attendance_models.dart';
import '../../utils/Common.dart';
import 'course_list_screen.dart';

class SemestersScreen extends StatelessWidget {
  SemestersScreen({required this.session});
  Session session;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          centerTitle: true,
          context: context,
          showArrowBack: true,
          title: "Semesters"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListView.builder(
                itemCount: session.semesters.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return SemesterBigCard(
                    semester: session.semesters[index],
                    session: session,
                  );
                })
          ],
        ),
      ),
    );
  }
}

class SemesterBigCard extends StatelessWidget {
  SemesterBigCard({
    super.key,
    required this.semester,
    required this.session,
  });
  Semester semester;
  Session session;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CourseScreen(
                        session: session,
                        semester: semester,
                      )));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 20, right: 20),
          padding: EdgeInsets.all(20),
          height: Screen.deviceSize(context).height / 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.green.shade50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${semester} Semester",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "${session.sessionYear} Session",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
