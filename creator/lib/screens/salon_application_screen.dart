import 'package:creator/common/decoration.dart';
import 'package:creator/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SalonApplicationScreen extends StatefulWidget {
  const SalonApplicationScreen({Key key}) : super(key: key);

  @override
  _SalonApplicationScreenState createState() => _SalonApplicationScreenState();
}

class _SalonApplicationScreenState extends State<SalonApplicationScreen> {
  bool isFormsFilled = false;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  void _updateContext() {
    var _isFilled = fullnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        reasonController.text.isNotEmpty;
    setState(() {
      isFormsFilled = _isFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Center(
            child: ListView(
              children: [
                _buildFormDescription(),
                _buildApplicationForms(screenWidth),
                _buildSubmitButton(screenWidth)
              ],
            ),
          ),
        ),
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

  Widget _buildSubmitButton(double screenWidth) {
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth,
      child: ElevatedButton(
        onPressed: isFormsFilled ? () {} : null,
        child: Text("申請"),
      ),
    );
  }

  Widget _buildApplicationForms(double screenWidth) {
    return Column(
      children: [
        _buildTextFieldWithBorderline(
          fullnameController,
          TextInputType.name,
          "お名前",
          screenWidth,
        ),
        SizedBox(height: 16),
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
            onChanged: (_) => _updateContext(),
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
      height: 32,
      child: TextField(
        onChanged: (_) => _updateContext(),
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
