import 'package:creator/common/color.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/screens/salon_applying_screen.dart';
import 'package:flutter/material.dart';

// TODO(hiroki):これ必要？
bool userLoggedIn = false;

class KSCreatorApp extends StatelessWidget {
  const KSCreatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //現時点で、一番最初の画面に表示する画面はログインにしておく。
      home: LoginScreen(),
      theme: _buildThemeData(),
      routes: {
        '/salon_applying_screen': (context) => SalonApplyingScreen(),
      },
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
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
    );
  }
}
