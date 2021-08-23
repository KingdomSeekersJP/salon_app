import 'package:flutter/material.dart';

class SalonApplyingScreen extends StatefulWidget {
  const SalonApplyingScreen({Key? key}) : super(key: key);

  @override
  _SalonApplyingScreenState createState() => _SalonApplyingScreenState();
}

class _SalonApplyingScreenState extends State<SalonApplyingScreen> {
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
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFormDescription(),
                _buildApplicationForms(),
                _buildSubmitButton(screenWidth)
              ],
            ),
          ),
        ),
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

  Widget _buildApplicationForms() {
    return Column(
      children: [
        Container(
          child: TextField(
            style: Theme.of(context).textTheme.bodyText1,
            onChanged: (_) => _updateContext(),
            controller: fullnameController,
            decoration: _buildInputDecoration("お名前"),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: emailController,
          onChanged: (_) => _updateContext(),
          style: Theme.of(context).textTheme.bodyText1,
          decoration: _buildInputDecoration(
            "メールアドレス",
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 300,
          child: TextField(
            controller: reasonController,
            onChanged: (_) => _updateContext(),
            style: Theme.of(context).textTheme.bodyText1,
            decoration: _buildInputDecoration("申請理由"),
            maxLength: 300,
            maxLines: 10,
          ),
        )
      ],
    );
  }

  Widget _buildFormDescription() {
    return Column(
      children: [
        Text(
          "オンラインサロン作成申請",
          style: Theme.of(context).textTheme.headline2,
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

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      counterStyle: TextStyle(
        color: Colors.white,
      ),
      hintText: hintText,
      hintStyle: Theme.of(context).textTheme.bodyText1,
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    );
  }
}
