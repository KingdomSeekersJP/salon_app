import 'package:creator/common/color.dart';
import 'package:creator/screens/salon_applying_screen.dart';
import 'package:flutter/material.dart';

class KSCreatorApp extends StatelessWidget {
  const KSCreatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SalonApplyingScreen(),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.white38;
                }
                return Colors.blue;
              },
            ),
          ),
        ),
        scaffoldBackgroundColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          textTheme: TextTheme(
            headline1: TextStyle(
              color: primaryColor,
            ),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: primaryColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headline3: TextStyle(
            color: primaryColor,
            fontSize: 16,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
