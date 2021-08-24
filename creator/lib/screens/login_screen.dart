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
  const LoginScreen({Key? key}) : super(key: key);

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
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
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

  Container _buildLoginMethodLogo(String asset) {
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

  // ログインできていたらHome、　出来ていなかったらsalon_applying_screen

  //TODO: _addToDatabaseでデータベースに登録するが、現時点では実装していない。
  void _navigateBasedOnRole() {
    final _auth = FirebaseAuth.instance.currentUser;
    print('宏輝: $_auth');
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth?.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.get(FieldPath(['role'])) == 0) {
        Navigator.of(context).pushReplacementNamed('/salon_applying_screen');
      } else if (snapshot.get(FieldPath(['role'])) == 1) {
        FirebaseFirestore.instance
            .collection('salons')
            .where('owner', isEqualTo: _auth?.email)
            .get()
            .then((QuerySnapshot snapshot) {
          print(snapshot.docs.isNotEmpty);
          print(snapshot.docs.isEmpty);
          if (snapshot.docs.isNotEmpty) {
            Navigator.of(context)
                .pushReplacementNamed(('/salon_applying_screen'));
          } else {
            Navigator.of(context)
                .pushReplacementNamed(('/salon_applying_screen'));
          }
        });
      }
    });
  }

  Future<void> _addToDatabase() async {
    DbHandler dbHandler = DbHandler();
    final User? user = FirebaseAuth.instance.currentUser;

    // データが無いとエラー可能性
    if (user != null) {
      //TODO(hiroki): 強制アンラップのハンドリング
      if (await dbHandler.getUser(user.email!) != null) {
        return;
      }
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      dbHandler
          .addUser(UserModel(
            //TODO(hiroki): 強制アンラップのハンドリング
            email: user.email!,
            //TODO(hiroki): 強制アンラップのハンドリング
            profile: UserProfileModel(name: user.displayName!, aboutMeText: ''),
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
          content: Text("ログインに失敗しました\nもう一度お試しください"),
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
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _loginInProgress = true;
    });
    try {
      await method.whenComplete(
        () async {
          await _addToDatabase();
          setState(
            () {
              _loginInProgress = false;
              userLoggedIn = true;
            },
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
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
                      "KS App",
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
