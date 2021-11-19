import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/app.dart';
import 'package:creator/common/color.dart';
import 'package:creator/firebase/database.dart';
import 'package:creator/firebase/sign_in.dart';
import 'package:creator/models/user_model.dart';
import 'package:creator/models/user_profile_model.dart';
import 'package:creator/models/user_setting_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loginInProgress = false;

  // ログインボタン
  Widget _buildLoginButtons(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoginButton(
            context,
            'assets/signin_button/google_logo.png',
            'Googleでログイン',
            () {
              _tryLoginWith(
                context,
                signInWithGoogle(),
              );
            },
          ),
          SizedBox(
            height: 16,
          ),
          _buildLoginButton(
            context,
            'assets/signin_button/apple_logo.png',
            'Appleでログイン',
            () {
              _tryLoginWith(
                context,
                signInWithApple(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String asset,
    String text,
    Function() method,
  ) {
    final mq = MediaQuery.of(context).size;
    final screenWidth = mq.width;
    final screenHeight = mq.height;

    return Center(
      child: Container(
        width: screenWidth < 600 ? screenWidth * 0.8 : screenWidth * 0.5,
        height: screenHeight * 0.06,
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style.copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
          onPressed: method,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoginMethodLogo(asset),
              SizedBox(
                width: 16,
              ),
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginMethodLogo(String asset) {
    final iconsSize = MediaQuery.of(context).size.width * 0.08;
    return Container(
      width: iconsSize,
      height: iconsSize,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Image.asset(asset),
      ),
    );
  }

  void _navigateBasedOnRole() {
    DbHandler dbHandler = DbHandler();
    final User user = FirebaseAuth.instance.currentUser;

    dbHandler.getUserDoc(user.email).then((snapshot) {
      //roleが1の時はHomeScreen()、roleが0の時はSalonApplicationScreen()
      if (snapshot.get(FieldPath(['role'])) == 0) {
        Navigator.of(context).pushReplacementNamed('/salon_application_screen');
      }
      if (snapshot.get(FieldPath(['role'])) == 1) {
        dbHandler.listSalonsByOwner(user.email).then(
          (snapshot) {
            if (snapshot.docs.isNotEmpty) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              Navigator.of(context)
                  .pushReplacementNamed('/salon_appliation_screen');
            }
          },
        );
      }
      print(snapshot);
    });
  }

  Future<void> _addToDatabase() async {
    DbHandler dbHandler = DbHandler();
    final User user = FirebaseAuth.instance.currentUser;
    if (FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .snapshots() !=
        null) {
      return;
    }

    // データが無いとエラー可能性
    if (user.email != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      dbHandler
          .addUser(UserModel(
            email: user.email,
            profile: UserProfileModel(name: user.displayName, aboutMeText: ''),
            role: RoleType.member,
            settings: UserSettings(pushNotifications: true),
            created: DateTime.now().toUtc(),
          ))
          .onError((error, stackTrace) => _buildLoginFailedDialog());
    }
  }

  Future _buildLoginFailedDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text('ログインに失敗しました\nもう一度お試しください'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('戻る'),
            ),
          ],
        );
      },
    );
  }

  void _tryLoginWith(BuildContext context, method) async {
    final User user = FirebaseAuth.instance.currentUser;
    setState(() {
      _loginInProgress = true;
    });
    try {
      await method.whenComplete(
        () async {
          await _addToDatabase();
          setState(
            () {
              userLoggedIn = true;
            },
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    setState(() {
      _loginInProgress = false;
    });
    _navigateBasedOnRole();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: _loginInProgress
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Text(
                      'KS App',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  _buildLoginButtons(context),
                ],
              ),
            ),
    );
  }
}
