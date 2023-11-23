import 'package:attend_sense/models/theme.dart';
import 'package:attend_sense/views/CourseList/courselist_screen.dart';
import 'package:attend_sense/views/Dashboard/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme.dart';
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
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [HomeScreen(), CourseListScreen(), SettingsScreen()],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 20,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.indigo[800],
            unselectedLabelStyle: currentThemeMode == ThemeMode.light
                ? lightTheme.textTheme.subtitle1
                : darkTheme.textTheme.subtitle1,
            selectedLabelStyle: currentThemeMode == ThemeMode.light
                ? lightTheme.textTheme.subtitle1
                : darkTheme.textTheme.subtitle1,
            showSelectedLabels: true,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.school), label: 'Courses'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]));
  }
}
