import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/common/color.dart';
import 'package:creator/firebase/database.dart';
import 'package:creator/models/user_model.dart';
import 'package:creator/screens/home_screen.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/screens/registration_success_screen.dart';
import 'package:creator/screens/salon_application_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool userLoggedIn = false;

class KSCreatorApp extends StatelessWidget {
  const KSCreatorApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData(context),
      routes: {
        //Login画面
        '/login': (context) => LoginScreen(),
        // Home画面
        '/home': (context) => HomeScreen(),
        // サロン開設申請画面
        '/salon_application_screen': (context) => SalonApplicationScreen(),
        // サロン申請Thanks画面
        '/registration_success': (context) => RegistrationSuccessScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return _buildHomePage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    var defaultThemeData = Theme.of(context);

    return defaultThemeData.copyWith(
      primaryColor: primaryColor,
      textTheme: _buildTextTheme(defaultThemeData),
      inputDecorationTheme: defaultThemeData.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(primaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      dividerColor: Color.fromRGBO(193, 193, 193, 1),
      appBarTheme: defaultThemeData.appBarTheme.copyWith(
        shadowColor: Colors.transparent,
        color: Colors.white,
        foregroundColor: Colors.black,
        textTheme: defaultThemeData.textTheme.apply(
          displayColor: Colors.black,
        ),
      ),
      tabBarTheme: defaultThemeData.tabBarTheme.copyWith(
        labelColor: primaryColor,
        unselectedLabelColor: primaryColor,
      ),
    );
  }

  TextTheme _buildTextTheme(ThemeData defaultThemeData) =>
      defaultThemeData.textTheme
          .copyWith(
            headline1: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            headline3: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            button: TextStyle(
              fontSize: 18,
            ),
            headline5: TextStyle(
              color: primaryColor,
              fontSize: 10,
            ),
            headline6: TextStyle(
              color: primaryColor,
              fontSize: 8,
            ),
          )
          .apply(
            fontFamily: 'NotoSansJP',
            fontSizeDelta: 2,
          );
  Widget _buildHomePage() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DbHandler.usersColletion)
          .doc(FirebaseAuth.instance.currentUser.email)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        // roleが1の時はHomeScreen()、roleが0の時はSalonApplicationScreen()
        if (snapshot.data.exists &&
            snapshot.data.get(FieldPath(['role'])) == 1) {
          return HomeScreen();
        } else if (snapshot.data.get(FieldPath(['role'])) == 0) {
          return SalonApplicationScreen();
        }
        return LoginScreen();
      },
    );
  }
}
