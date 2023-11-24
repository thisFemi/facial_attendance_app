import 'package:attend_sense/models/theme.dart';
import 'package:attend_sense/provider/theme.dart';
import 'package:attend_sense/views/Onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([]);
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.edgeToEdge,
  // );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:AppColors.white,
        systemNavigationBarColor: AppColors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,

    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:AppColors.white,
        systemNavigationBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.light));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            // this approach is been used when creating the or building the instance at the first instance
            create: (context) => ThemeModel(),
          ),
        ],
        child: Consumer<ThemeModel>(builder: (context, themeModel, _) {
          return MaterialApp(
            title: 'AttendSense ',
            themeMode: themeModel.themeMode,
            theme: lightTheme,
          
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }));
  }
}
