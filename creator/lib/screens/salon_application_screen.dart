import 'package:cloud_functions/cloud_functions.dart';
import 'package:creator/common/decoration.dart';
import 'package:creator/common/email.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/widgets/custom_button.dart';
import 'package:creator/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SalonApplicationScreen extends StatefulWidget {
  const SalonApplicationScreen({Key? key}) : super(key: key);

  @override
  _SalonApplicationScreenState createState() => _SalonApplicationScreenState();
}

class _SalonApplicationScreenState extends State<SalonApplicationScreen> {
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('genericEmail');

  final FirebaseAuth auth = FirebaseAuth.instance;

  String emailAddress = 'kondo.matr02@gmail.com';

  bool _noFieldsEmpty = false;
  bool _submitInProgress = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final reasonController = TextEditingController();

  void _updateScreenState() {
    setState(
      () {
        if (FirebaseAuth.instance.currentUser == null) {
          //Firebaseでメールアドレスを取得していない場合
          _noFieldsEmpty = (firstNameController.text.isNotEmpty &&
              lastNameController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              reasonController.text.isNotEmpty);
        } else {
          //Firebaseでメールアドレスを取得できる場合は、Textでメールアドレスを記載
          _noFieldsEmpty = (firstNameController.text.isNotEmpty &&
              lastNameController.text.isNotEmpty &&
              reasonController.text.isNotEmpty);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final screenWidth = mq.width;
    final screenHeight = mq.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '開設申請',
          style: Theme.of(context).textTheme.headline3,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: _buildDrawer(context),
      body: _buildMainBody(context, screenWidth, screenHeight),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('ログアウト'),
            onTap: () async {
              // final user = FirebaseAuth.instance.currentUser;
              // if (user != null) {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                print('ログアウトボタンを押した');
                await FirebaseAuth.instance.signOut();
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildMainBody(
      BuildContext context, double screenWidth, double screenHeight) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        _submitInProgress ? LinearProgressIndicator() : Container(),
        SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Center(
                child: ListView(
                  children: [
                    _buildFormDescription(),
                    _buildApplicationForms(screenWidth),
                    _buildSubmitButton(screenWidth, screenHeight),
                    SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormDescription() {
    return Column(
      children: [
        Text(
          'オンラインサロン\n作成申請',
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        Text(
          'サロンを開設するために、\n必要事項のご入力をお願い致します',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 32)
      ],
    );
  }

  Widget _buildApplicationForms(double screenWidth) {
    return Column(
      children: [
        _buildMailAddressIfFirebaseIsLoggedIn(screenWidth),
        SizedBox(height: 16),
        _buildTextFieldWithBorderline(
          firstNameController,
          TextInputType.name,
          'First Name',
          screenWidth,
        ),
        SizedBox(height: 16),
        _buildTextFieldWithBorderline(
          lastNameController,
          TextInputType.name,
          'Last Name',
          screenWidth,
        ),
        SizedBox(height: 16),
        _buildReasonTextField(),
      ],
    );
  }

  Widget _buildReasonTextField() {
    return Container(
      width: double.infinity,
      height: 300,
      child: TextField(
        controller: reasonController,
        onChanged: (_) => _updateScreenState(),
        style: Theme.of(context).textTheme.bodyText1,
        decoration: buildInputDecoration('申請理由', context),
        maxLength: 300,
        maxLines: 10,
      ),
    );
  }

  Widget _buildTextFieldWithBorderline(
    TextEditingController controller,
    TextInputType keyboardType,
    String label,
    double width,
  ) {
    return Container(
      width: width,
      height: 64,
      child: TextField(
        onChanged: (_) => _updateScreenState(),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          hintText: label,
        ),
      ),
    );
  }

  Widget _buildMailAddressIfFirebaseIsLoggedIn(double screenWidth) {
    if (FirebaseAuth.instance.currentUser == null) {
      //Firebaseでメールアドレスを取得していない場合
      return _buildTextFieldWithBorderline(
        emailController,
        TextInputType.emailAddress,
        'Email Address',
        screenWidth,
      );
    } else {
      //Firebaseでメールアドレスを取得できる場合は、Textでメールアドレスを記載
      return Container(
        width: screenWidth,
        height: 64,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
          ),
          child: Text(
            FirebaseAuth.instance.currentUser?.email ?? "",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }

  Widget _buildSubmitButton(double screenWidth, double screenHeight) {
    return CustomButton(
      text: '申請',
      width: screenWidth * 0.4,
      height: screenHeight * 0.10,
      function: _noFieldsEmpty
          ? () {
              showCustomDialog(
                content: '内容にお間違えがなければ、\n送信ボタンを押してください\n確認メールを送信します',
                leftFunction:
                    _noFieldsEmpty ? () async => await _submitForm() : null,
                leftButtonText: '送信',
                rightFunction: () => Navigator.pop(context),
                rightButtonText: '取り消し',
                context: context,
              );
            }
          : null,
    );
  }

  sendEmail() {
    return callable.call({
      'text': 'Sending email with Flutter and SendGrid is fun!',
      'subject': 'Email from Flutter'
    }).then((res) => print(res.data));
  }

  Future _submitForm() async {
    //登録メールを送っているときには、ロードビューを表示させる
    setState(() {
      _submitInProgress = true;
    });

    await sendSalonRegstrationThanksMail(
      text: reasonController.text,
      fullName: "${lastNameController.text} ${firstNameController.text}",
      // email: emailController.text
    );

    // await sendEmail();

    //登録メールの送信が完了したらロードビューを閉じる
    setState(() {
      _submitInProgress = false;
    });

    Navigator.of(context).pushReplacementNamed('/registration_success');
  }
}
