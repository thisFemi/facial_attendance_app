import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';

import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/custom_appBar.dart';
import '../Others/pdfPreview.dart';

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
              "Total Attendance: ${course.attendanceList.length}",
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

  List<StudentData> students = [];
  @override
  void initState() {
    students = widget.attendance.students ?? [];
    super.initState();
  }

  Future<void> removeStudent(StudentData student) async {
    try {
      Dialogs.showProgressBar(context);
      if (APIs.userInfo.id == widget.attendance.lecturerId) {
        await APIs.changeStudentAttendance(widget.session, widget.semester,
                widget.course, widget.attendance, student, false)
            .then((value) {
          int index = students
              .indexWhere((stud) => stud.matricNumber == student.matricNumber);
          students[index].isPresent = false;

          Navigator.pop(context);
          setState(() {});
        });
      } else {
        Navigator.pop(context);
        Dialogs.showSnackbar(
            context, "You're not eligible to perform operation");
      }
    } catch (error) {
      Navigator.pop(context);
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
          actions: [
          students.isNotEmpty?  Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: SizedBox(
                height: 35.0,
                // width: Screen.deviceSize(context).width * 0.85,
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PdfPreviewPage(
                                  course: widget.course,
                                  semester: widget.semester,
                                  session: widget.session,
                                  attendance: widget.attendance,
                                )));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.black,
                  ),
                  child: Text(
                    'Export',
                    style: TextStyle(
                        color: AppColors.white, fontFamily: 'Raleway-SemiBold'),
                  ),
                ),
              ),
            ):SizedBox.shrink()
          ]),
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
            !(widget.attendance.students.length == 0)
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
                                  builder: (context) => SimpleDialog(
                                        alignment: Alignment.center,
                                        contentPadding: EdgeInsets.all(10),
                                        title: Text(
                                          "Remove Student?",
                                          textAlign: TextAlign.center,
                                        ),
                                        children: [
                                          Text(
                                            'Are you sure you want to remove ${student.matricNumber} from attendance?. This action is irreversible, Dou you still want to continue? ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  // vertical: 40,
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
                                                          color:
                                                              AppColors.black,
                                                          fontFamily:
                                                              'Raleway-SemiBold'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  // vertical: 40,
                                                ),
                                                child: SizedBox(
                                                  height: 35.0,
                                                  // width: Screen.deviceSize(context).width * 0.85,
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await removeStudent(
                                                          student);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.red,
                                                    ),
                                                    child: const Text(
                                                      'Mark Absent',
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
                                          ),
                                          SizedBox(height: 10),
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
