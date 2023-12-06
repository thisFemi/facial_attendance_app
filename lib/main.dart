import 'package:attend_sense/models/theme.dart';
import 'package:attend_sense/provider/theme.dart';
import 'package:attend_sense/views/Dashboard/dashboard_screen.dart';
import 'package:attend_sense/views/Onboarding/splash_screen.dart';
import 'package:attend_sense/views/Onboarding/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'utils/colors.dart';
import 'views/Settings/error_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      Widget error = Text('......rendering error....: ${errorDetails.summary}');
      // if (child is Scaffold || child is Navigator) {
      //   error = Scaffold(
      //     body: Center(
      //       child: error,
      //     ),
      //   );
      // }
      return ErrorScreen(
        label: "Sorry, Page not found 😔",
      );
    };
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      systemNavigationBarColor: AppColors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
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
            home: const WelcomeScreen(),
          );
        }));
  }
}
