import 'package:creator/common/decoration.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:creator/widgets/custom_button.dart';
import 'package:creator/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SalonApplicationScreen extends StatefulWidget {
  const SalonApplicationScreen({Key key}) : super(key: key);

  @override
  _SalonApplicationScreenState createState() => _SalonApplicationScreenState();
}

class _SalonApplicationScreenState extends State<SalonApplicationScreen> {
  bool _noFieldsEmpty = false;
  bool _submitInProgress = false;

  // final contentController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final reasonController = TextEditingController();

  void _updateScreenState() {
    setState(
      () {
        _noFieldsEmpty = (
            // contentController.text.isEmpty ||
            firstNameController.text.isNotEmpty &&
                lastNameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                reasonController.text.isNotEmpty);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final screenWidth = mq.width;
    final screenHeight = mq.height;
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "開設申請",
          style: Theme.of(context).textTheme.headline3,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: _buildDrawer(context),
      body: Stack(
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
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text("ログアウト"),
            onTap: () async {
              print("ログアウトボタンを押した");
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(double screenWidth, double screenHeight) {
    return CustomButton(
      text: "申請",
      width: screenWidth * 0.4,
      height: screenHeight * 0.10,
      function: _noFieldsEmpty
          ? () async {
              showCustomDialog(
                content: "内容にお間違えがなければ、\n送信ボタンを押してください\n確認メールを送信します",
                leftFunction: _noFieldsEmpty ? () => _submitForm() : null,
                leftButtonText: "送信",
                rightFunction: () => Navigator.pop(context),
                rightButtonText: "取り消し",
                context: context,
              );
            }
          : null,
    );
  }

  Future _submitForm() async {
    setState(() {
      _submitInProgress = true;
    });

    //TODO: ここで登録メールを送信する。現在、未実装のためゴスペルサロンのコードを入れているが、コメントアウトしている。
    //   await sendSalonRegistrationThanksMail(
    //     text: contentController.text,
    //     fullName: "${lastNameController.text} ${firstNameController.text}",
    //     phoneNumber: phoneNumberController.text,
    //   );

    setState(() {
      _submitInProgress = false;
    });

    Navigator.of(context).pushReplacementNamed('/registration_success');
  }

  // Future _submitForm() async {
  //   setState(() {
  //     _submitInProgress = true;
  //   });

  //   await sendSalonRegistrationThanksMail(
  //     text: contentController.text,
  //     fullName: "${lastNameController.text} ${firstNameController.text}",
  //     phoneNumber: phoneNumberController.text,
  //   );

  //   setState(() {
  //     _submitInProgress = false;
  //   });

  //   Navigator.of(context).pushReplacementNamed('/registration_success');
  // }

  Widget _buildApplicationForms(double screenWidth) {
    return Column(
      children: [
        _buildTextFieldWithBorderline(
          firstNameController,
          TextInputType.name,
          "名前",
          screenWidth,
        ),
        SizedBox(height: 16),
        _buildTextFieldWithBorderline(
          lastNameController,
          TextInputType.name,
          "名字",
          screenWidth,
        ),
        SizedBox(height: 16),
        //TODO(PR_#8):google login時には、最初からメールアドレスをつけておく。
        _buildTextFieldWithBorderline(
          emailController,
          TextInputType.emailAddress,
          "メールアドレス",
          screenWidth,
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 300,
          child: TextField(
            controller: reasonController,
            onChanged: (_) => _updateScreenState(),
            style: Theme.of(context).textTheme.bodyText1,
            decoration: buildInputDecoration("申請理由", context),
            maxLength: 300,
            maxLines: 10,
          ),
        ),
      ],
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

  Widget _buildFormDescription() {
    return Column(
      children: [
        Text(
          "オンラインサロン\n作成申請",
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
        Text(
          "サロンを開設するために、\n必要事項のご入力をお願い致します",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 32)
      ],
    );
  }
}
