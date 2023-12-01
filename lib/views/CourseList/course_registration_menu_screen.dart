import 'package:attend_sense/views/CourseList/add_or_delete_screen.dart';
import 'package:attend_sense/views/CourseList/course_registration.dart';
import 'package:attend_sense/views/Others/coming_soon_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Common.dart';
import '../../utils/colors.dart';
import '../../widgets/course_reg_cards.dart';

class CourseRegistrationMenu extends StatelessWidget {
  const CourseRegistrationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.deviceSize(context).width,
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      color: AppColors.white,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Title(
                color: AppColors.black,
                child: const Text(
                  'Registration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.2,
                    childAspectRatio: 0.9),
                itemCount: 4,
                itemBuilder: (ctx, index) {
                  final List<IconData> icons = [
                    Icons.app_registration_rounded,
                    Icons.edit_document,
                    Icons.contact_support_rounded,
                    CupertinoIcons.chat_bubble_2,
                  ];
                  final List<String> titles = [
                    'Register Courses',
                    'Add/Remove Course',
                    'Help',
                    'Message',
                  ];
                  final List<String> descs = [
                    'Register your courses',
                    'Add or Remove courses',
                    'Lodge a Complaint',
                    'Need Help? Contact Admin'
                  ];
                  final List<Color> bGcolors = [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                    Colors.orange.shade100,
                    Colors.green.shade100,
                  ];
                  final List<Color> colors = [
                    Colors.blue,
                    Colors.purple,
                    Colors.orange,
                    Colors.green,
                  ];
                  final List<Function> functions = [
                    () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CourseRegScreen()));
                    },
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddOrDeleteListScreen()));
                    },
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ComingSoon(
                                    label: "Complaints",
                                  )));
                    },
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ComingSoon(
                                    label: "Chat",
                                  )));
                    }
                  ];
                  return CourseRegCard(
                      iconData: icons[index],
                      title: titles[index],
                      bgColor: bGcolors[index],
                      color: colors[index],
                      desc: descs[index],
                      onTap: functions[index]);
                }))
      ]),
    );
  }
}
