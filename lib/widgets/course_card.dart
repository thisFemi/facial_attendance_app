import 'package:attend_sense/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseCard extends StatelessWidget {
   CourseCard(
      {required this.progress,
      required this.showPecentage,
      required this.onTap,
      required this.title});

  final Function onTap;
  final String title;
  final double progress;
  bool showPecentage = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    showPecentage
                        ? Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200],
                            ),
                            child: Text(
                              '${progress * 100}%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                        : SizedBox.shrink()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                LinearPercentIndicator(
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  //width: 140.0,
                  barRadius: Radius.circular(10),
                  lineHeight: 10.0,
                  percent: progress,
                  animation: true,

                  backgroundColor: Colors.grey[200],
                  progressColor: AppColors.black,
                ),
                SizedBox(
                  height: 4,
                )
              ],
            ),
          ),
        ));
  }
}
