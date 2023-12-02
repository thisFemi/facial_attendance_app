import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../models/attendance_models.dart';
import '../../utils/colors.dart';
import '../../utils/date_util.dart';
import '../../utils/dialogs.dart';
import '../../widgets/custom_appBar.dart';

class CreateAttendanceListScreen extends StatelessWidget {
  CreateAttendanceListScreen({required this.semester, required this.sessioon});
  Semester semester;
  Session sessioon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title: "${sessioon.sessionYear} (${semester.semesterNumber} semester)",
      ),
      backgroundColor: AppColors.white,
      body: ListView.builder(
          itemCount: semester.courses.length,
          itemBuilder: (ctx, index) {
            final course = semester.courses[index];
            return AttendanceCard(semester, sessioon, course, context);
          }),
    );
  }

  Widget AttendanceCard(
    Semester semester,
    Session sessioon,
    Course course,
    BuildContext context,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CreateAttendanceScreen(
                        semester: semester,
                        session: sessioon,
                        course: course,
                      )));
        },
        child: ListTile(
          title: Text(course.courseId),
          subtitle: Text(course.courseName),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.grey,
          ),
          //onPressed: onDelete,
        ),
      ),
    );
  }
}

class CreateAttendanceScreen extends StatefulWidget {
  CreateAttendanceScreen(
      {super.key,
      required this.course,
      required this.semester,
      required this.session});
  Session session;
  Semester semester;
  Course course;
  @override
  State<CreateAttendanceScreen> createState() => _CreateAttendanceScreenState();
}

class _CreateAttendanceScreenState extends State<CreateAttendanceScreen> {
  List<double> ranges = [10, 20, 50, 100, 500];
  DateTime? startTime;
  DateTime? endTime;
  double? selectedRange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title:
            "${widget.session.sessionYear} (${widget.semester.semesterNumber} semester)",
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Attendance for ${widget.course.courseId}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          startTime = await showDatePicker();
                          endTime = null;
                          setState(() {});
                        },
                        child: const Text("Start Time")),
                    Text(startTime == null
                        ? ""
                        : DateUtil.formatDateTime(startTime!))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await showDatePicker().then((value) {
                            if (value != null) {
                              if (value.isBefore(startTime!)) {
                                Dialogs.showSnackbar(context,
                                    "End Date Can't be before start date");
                              } else {
                                setState(() {
                                  endTime = value;
                                });
                              }
                            }
                          });
                        },
                        child: const Text("End Time")),
                    Text(endTime == null
                        ? ""
                        : DateUtil.formatDateTime(endTime!))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          startTime = await showDatePicker();
                          endTime = null;
                          setState(() {});
                        },
                        child: const Text("Range")),
                    Text(startTime == null
                        ? ""
                        : DateUtil.formatDateTime(startTime!))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showDatePicker() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    return dateTime;
  }
}
