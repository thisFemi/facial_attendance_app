import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/attendance_card.dart';
import '../../widgets/custom_appBar.dart';

class StudentAttendanceList extends StatelessWidget {
  const StudentAttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        context: context,
        showArrowBack: true,
        title: "Attendance",
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Export',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.lightWhite),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Student Present : 22",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 22,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return StudentAttendanceCard(
                    matricNumber:"170404110",
                    name:"Ogunmepon Sherifu"
                    );
                  }),
            ),
          ],
        ),
      ),
     
    );
  }
}
