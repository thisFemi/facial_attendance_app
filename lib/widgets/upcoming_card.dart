import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../utils/Common.dart';
import '../views/Others/attendance_capture_screen.dart';

const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);

class UpcomingAttendanceCard extends StatefulWidget {
  const UpcomingAttendanceCard({super.key});

  @override
  State<UpcomingAttendanceCard> createState() => _UpcomingAttendanceCardState();
}

class _UpcomingAttendanceCardState extends State<UpcomingAttendanceCard> {
  final TextEditingController _username = TextEditingController();
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AttendanceCapture(
                                        // user: widget.user,
                                        )));
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
            title: const Text("CSC301",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: const Text(
              "Dr Ajayi.O",
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
                      duration: const Duration(hours: 2),
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
