// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../api/apis.dart';
import '../../models/attendance_models.dart';
import '../../utils/Common.dart';
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
  bool _isLoading = false;
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
                        //   style: ButtonStyle(backgroundColor:MaterialStateProperty<Colors.whi> AppColors.white),
                        onPressed: () async {},
                        child: const Text("Range")),
                    DropdownButton<double>(
                      value: selectedRange,
                      hint: const Text("Select range"),
                      items: ranges.map((double item) {
                        return DropdownMenuItem<double>(
                          value: item,
                          child: Text("$item m"),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRange = newValue;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            (startTime != null && endTime != null && selectedRange != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      height: 50.0,
                      width: Screen.deviceSize(context).width * 0.85,
                      child: TextButton(
                        onPressed: () async {
                          await createAttendane().then((value) {
                            if (value != null) {
                              Dialogs.showSuccessDialog(
                                  context,
                                  'Successful',
                                  'Attendance Verification Code is ${value}',
                                  "Continue", () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.black,
                        ),
                        child: _isLoading
                            ? const SpinKitThreeBounce(
                                color: AppColors.offwhite, size: 40)
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Raleway-SemiBold',
                                ),
                              ),
                      ),
                    ),
                  )
                : SizedBox.shrink()
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

  Future<String?> createAttendane() async {
    if (startTime != null && endTime != null && selectedRange != null) {
      try {
        setState(() {
          _isLoading = true;
        });
        String verificationCode = generateVerificationCode();
        Position currentPosition = await APIs.determinePosition();
        double latitude = currentPosition.latitude;
        double longitude = currentPosition.longitude;
        Attendance newAttendance = Attendance(
            attendanceId: APIs.userInfo.id,
            lecturerName: APIs.userInfo.name,
            lecturerId: APIs.userInfo.id,
            startTime: startTime!,
            endTime: endTime!,
            verificationCode: verificationCode,
            range: selectedRange!,
            isPresent: false,
            latitude: latitude,
            longitude: longitude);
        print("got hee");
        await APIs.addAttendanceToAcademicRecords(
            widget.session, widget.semester, widget.course, newAttendance);
        setState(() {
          _isLoading = false;
        });
        return verificationCode;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        Dialogs.showSnackbar(context, error.toString());
      }
    }
    return null;
  }

  String generateVerificationCode() {
    var length = 5 + Random().nextInt(3); // Random length between 5 and 7
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
      ),
    );
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }
}
