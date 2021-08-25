import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText, BuildContext context) {
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
