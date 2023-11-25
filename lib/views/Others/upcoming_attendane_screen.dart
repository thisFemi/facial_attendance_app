import 'package:attend_sense/utils/colors.dart';
import 'package:attend_sense/widgets/custom_appBar.dart';
import 'package:attend_sense/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';

class UpcomingAttendanceScreen extends StatelessWidget {
  const UpcomingAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          context: context,
          showArrowBack: true,
          title: "Attendance",
          centerTitle: true),
          backgroundColor: AppColors.white,
          body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
        
            Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return UpcomingAttendanceCard(
                    );
                  }),
            ),
          ],
        ),
      ),

    );
  
  }
}
