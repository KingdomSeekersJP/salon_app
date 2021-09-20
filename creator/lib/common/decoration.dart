import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText, BuildContext context) {
  return InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 0.5),
    ),
    counterStyle: TextStyle(
      color: Colors.white,
    ),
    hintText: hintText,
    hintStyle: Theme.of(context).textTheme.bodyText1,
    border: OutlineInputBorder(),
  );
}
