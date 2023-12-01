import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';

import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/custom_appBar.dart';

class AttendanceList extends StatelessWidget {
  AttendanceList(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Course Attendance: ${course.attendanceList.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: course.attendanceList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
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

class StudentAttendanceList extends StatefulWidget {
  StudentAttendanceList(
      {required this.attendance,
      required this.course,
      required this.semester,
      required this.session});
  Session session;
  Course course;
  Semester semester;
  Attendance attendance;

  @override
  State<StudentAttendanceList> createState() => _StudentAttendanceListState();
}

class _StudentAttendanceListState extends State<StudentAttendanceList> {
  bool _isLoading = false;
  List<StudentData> students = [];
  @override
  void initState() {
    students = widget.attendance.students!;
    super.initState();
  }

  Future<void> removeStudent(StudentData student) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await APIs.removeStudent(
              student,
              widget.session.sessionYear,
              widget.semester.semesterNumber,
              widget.course.courseId,
              APIs.userInfo.id)
          .then((value) {
        students
            .removeWhere((stud) => stud.matricNumber == student.matricNumber);
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Dialogs.showSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title: "Records",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Students: ${widget.attendance.students == null ? 0 : students.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            !(widget.attendance.students == null ||
                    widget.attendance.students!.length == 0)
                ? Expanded(
                    child: ListView.builder(
                        itemCount: students.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          final student = students[index];
                          return StudentAttendanceCard(
                            attendance: widget.attendance,
                            course: widget.course,
                            semester: widget.semester,
                            session: widget.session,
                            student: student,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Remove Student"),
                                        content: Text(
                                            'Are you sure you want to remove ${student.studentName} from attendance?'),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 40,
                                            ),
                                            child: SizedBox(
                                              height: 35.0,
                                              // width: Screen.deviceSize(context).width * 0.85,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.white,
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontFamily:
                                                          'Raleway-SemiBold'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 40,
                                            ),
                                            child: SizedBox(
                                              height: 35.0,
                                              // width: Screen.deviceSize(context).width * 0.85,
                                              child: TextButton(
                                                onPressed: () async {
                                                  await removeStudent(student);
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.red,
                                                ),
                                                child: !_isLoading
                                                    ? const SpinKitThreeBounce(
                                                        color:
                                                            AppColors.offwhite,
                                                        size: 30)
                                                    : const Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.white,
                                                            fontFamily:
                                                                'Raleway-SemiBold'),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                          );
                        }),
                  )
                : const Center(
                    child: Text('No record found!'),
                  ),
          ],
        ),
      ),
    );
  }
}
