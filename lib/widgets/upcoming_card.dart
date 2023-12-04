import 'package:attend_sense/models/attendance_models.dart';
import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../api/apis.dart';
import '../utils/Common.dart';
import '../utils/dialogs.dart';
import '../views/Others/attendance_capture_screen.dart';

const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);

class UpcomingAttendanceCard extends StatefulWidget {
  UpcomingAttendanceCard(
      {super.key,
      required this.session,
      required this.semester,
      required this.course,
      required this.attendance});
  Session session;
  Semester semester;
  Course course;
  Attendance attendance;
  @override
  State<UpcomingAttendanceCard> createState() => _UpcomingAttendanceCardState();
}

class _UpcomingAttendanceCardState extends State<UpcomingAttendanceCard> {
  bool _isLoading = true;
  Future<bool> isUserWithinDistance() async {
    try {
      // Get the user's current location
      Position userLocation = await APIs.determinePosition();

      // Calculate the distance between the user and the attendance location
      double distanceInMeters = await Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        widget.attendance
            .latitude, // Replace with the actual latitude of the attendance
        widget.attendance
            .longitude, // Replace with the actual longitude of the attendance
      );
      print("distance ${distanceInMeters}");
      // Check if the distance is within the specified range (10-20 meters)
      return distanceInMeters <= widget.attendance.range;
    } catch (e) {
      print('Error getting user location: $e');
      return false; // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration timeDifference =
        widget.attendance.endTime.difference(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        const Text(
                          "Verify your location",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.red,
                            ))
                      ],
                    ),
                    const Divider(),
                    const Text("Ask lecturer for attendance code",
                        style: TextStyle(color: AppColors.grey)),
                    const SizedBox(height: 10),
                    const Text('Code',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      //  initialValue: widget.userInfo.name,
                      // onChanged: (newValue) =>
                      //     APIs.userInfo.name = newValue ?? '',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'enter code',
                          hintStyle: const TextStyle(color: AppColors.grey),
                          labelStyle: const TextStyle(
                              color: AppColors.grey,
                              fontFamily: 'Raleway-SemiBold',
                              fontSize: 15.0),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          // focusColor: Colors.grey[300],
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: const Icon(
                            Icons.lock,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "name can't be empty";
                        } else if (value.length < 3) {
                          return "name too short";
                        } else if (value !=
                            widget.attendance.verificationCode) {
                          return "Wrong code";
                        }

                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 40,
                      ),
                      child: SizedBox(
                        height: 50.0,
                        // width: Screen.deviceSize(context).width * 0.85,
                        child: TextButton(
                          onPressed: () async {
                            await isUserWithinDistance().then((result) {
                              Navigator.pop(context);
                              if (result) {
                                if (APIs.userInfo.userInfo!.imgUrl != "") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AttendanceCapture(
                                                attendance: widget.attendance,
                                                course: widget.course,
                                                semester: widget.semester,
                                                session: widget.session,
                                              )));
                                } else {
                                  Dialogs.showSnackbar(context,
                                      "You need to complete your profile registration");
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You are not within the attendance range.'),
                                  ),
                                );
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.black,
                          ),
                          child: !_isLoading
                              ? const SpinKitThreeBounce(
                                  color: AppColors.offwhite, size: 40)
                              : const Text(
                                  'Verify',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontFamily: 'Raleway-SemiBold'),
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: ListTile(
            title: Text(widget.course.courseId,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(
              widget.attendance.lecturerName,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: SizedBox(
              child: Column(
                children: [
                  const Text(
                    "Expires in:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                    child: SlideCountdownSeparated(
                      duration: timeDifference,
                      separatorType: SeparatorType.symbol,
                      separatorStyle: const TextStyle(
                        color: AppColors.black,
                      ),
                      countUp: false,
                      slideDirection: SlideDirection.up,
                      //   digitsNumber: [],
                      durationTitle: DurationTitle.en(),
                      replacement: const Icon(Icons.vaccines),
                      separator: '',
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
