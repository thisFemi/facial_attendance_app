import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/widgets/custom_appBar.dart';
import 'package:attend_sense/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';

class UpcomingAttendanceScreen extends StatefulWidget {
  const UpcomingAttendanceScreen({Key? key});

  @override
  State<UpcomingAttendanceScreen> createState() =>
      _UpcomingAttendanceScreenState();
}

class _UpcomingAttendanceScreenState extends State<UpcomingAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        showArrowBack: true,
        title: "Attendance",
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: StreamBuilder(
        stream: APIs.fetchAcademicData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(child: const Text('Academic records not found!')),
              ),
            );
          }

          final studentData = UserData.fromJson(snapshot.data!.data()!['academicRecords']);
          APIs.academicRecords = studentData;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: studentData.sessions.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, sessionIndex) {
              final session = studentData.sessions[sessionIndex];

              return ListView.builder(
                itemCount: session.semesters.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (ctx, semesterIndex) {
                  final semester = session.semesters[semesterIndex];

                  return ListView.builder(
                    itemCount: semester.courses.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, courseIndex) {
                      final course = semester.courses[courseIndex];

                      // Filter attendances where endTime has not expired
                      final upcomingAttendances = course.attendanceList
                          .where((attendance) =>
                              attendance.endTime.isAfter(DateTime.now()))
                          .toList();

                      return ListView.builder(
                        itemCount: upcomingAttendances.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (ctx, attendanceIndex) {
                          final upcomingAttendance =
                              upcomingAttendances[attendanceIndex];

                          return UpcomingAttendanceCard(
                            attendance: upcomingAttendance,
                            course: course,
                            semester: semester,
                            session: session,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
