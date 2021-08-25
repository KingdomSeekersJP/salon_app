import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/common/color.dart';
import 'package:creator/firebase/database.dart';
import 'package:creator/screens/home_screen.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/screens/reason_for_creating_the_salon_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool userLoggedIn = false;

class KSCreatorApp extends StatelessWidget {
  const KSCreatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildThemeData(),
      routes: {
        '/salon_applying_screen': (context) =>
            ReasonsForCreatingTheSalonScreen(),
        '/home': (context) => HomeScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          // final user = snapshot.data as dynamic;

          if (snapshot.hasData) {
            return _buildHomePage();
          } else {
            return LoginScreen();
          }

          // if (snapshot.hasData &&
          //     FirebaseFirestore.instance
          //             .collection(DbHandler.usersColletion)
          //             .doc(user.email) !=
          //         null) {
          //   return _buildHomePage();
          // }
          // return LoginScreen();
        },
      ),
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
          )
          .apply(
            fontFamily: 'NotoSansJP',
            fontSizeDelta: 2,
          );
  Widget _buildHomePage() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(DbHandler.usersColletion)
          .doc(FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        //TODO(hiroki): 強制アンラップのハンドリング
        if (snapshot.data!.exists &&
            snapshot.data?.get(FieldPath(['role'])) == 1) {
          return HomeScreen();
        } else if (snapshot.data?.get(FieldPath(['role'])) == 0) {
          return ReasonsForCreatingTheSalonScreen();
        }
        return LoginScreen();
      },
    );
  }
}
