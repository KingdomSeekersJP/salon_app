import 'package:creator/screens/login_screen.dart';
import 'package:flutter/material.dart';

class KSCreatorApp extends StatelessWidget {
  const KSCreatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
