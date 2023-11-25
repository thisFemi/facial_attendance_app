import 'package:attend_sense/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';

const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);

class UpcomingAttendanceCard extends StatefulWidget {
  const UpcomingAttendanceCard({super.key});

  @override
  State<UpcomingAttendanceCard> createState() => _UpcomingAttendanceCardState();
}

class _UpcomingAttendanceCardState extends State<UpcomingAttendanceCard> {
  late final StreamDuration streamDuration;
  @override
  void initState() {
    streamDuration = StreamDuration(
      config: const StreamDurationConfig(
        countDownConfig: CountDownConfig(duration: defaultDuration),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    streamDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text(
                          "Verify your location",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: AppColors.red,))
                      ],
                    ),
                    Divider(),
                    
                  ],
                );
              });
        },
        child: ListTile(
            title: Text("CSC301",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(
              "Dr Ajayi.O",
              overflow: TextOverflow.ellipsis,
            ),
            trailing: SizedBox(
              child: Column(
                children: [
                  Text(
                    "Expires in:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                    child: SlideCountdownSeparated(
                      duration: const Duration(hours: 2),
                      separatorType: SeparatorType.symbol,
                      separatorStyle: TextStyle(
                        color: AppColors.black,
                      ),
                      countUp: false,
                      slideDirection: SlideDirection.up,
                      //   digitsNumber: [],
                      durationTitle: DurationTitle.en(),
                      replacement: Icon(Icons.vaccines),
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
