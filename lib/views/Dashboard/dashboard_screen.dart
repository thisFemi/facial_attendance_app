import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:attend_sense/models/theme.dart';
import 'package:attend_sense/views/CourseList/academicslist_screen.dart';
import 'package:attend_sense/views/Dashboard/home.dart';
import 'package:attend_sense/views/Others/upcoming_attendane_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme.dart';
import '../../utils/colors.dart';
import '../CourseList/course_registration_menu_screen.dart';
import '../Settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex = 0;
  late final _pageController = PageController();
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);
  final TextStyle selectedLabelStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);
  @override
  Widget build(BuildContext context) {
    ThemeMode currentThemeMode =
        Provider.of<ThemeModel>(context, listen: false).themeMode;
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
             HomeScreen(),
            AcademicsScreen(),
            const CourseRegistrationMenu(),
            const SettingScreen(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          CupertinoIcons.person_crop_circle_badge_checkmark,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const UpcomingAttendanceScreen(
                      // user: widget.user,
                      )));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        backgroundColor: Colors.black,
        height: 70,
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 24,
            color: isActive ? Colors.green : Colors.white,
          );
        },
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,

        notchSmoothness: NotchSmoothness.softEdge,

        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        }, //other params

        //other params
      ),
    );
  }



  final iconList = <IconData>[
    CupertinoIcons.home,
    Icons.receipt_long_outlined,
    Icons.list_alt_rounded,
    Icons.account_circle_rounded
  ];
}
