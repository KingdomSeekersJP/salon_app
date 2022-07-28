import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key, this.text, required this.function, this.width, this.height})
      : super(key: key);

  final String? text;
  final VoidCallback? function;
  final width;
  final height;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        child: FittedBox(
          child: Text(widget.text ?? ''),
        ),
        onPressed: widget.function,
      ),
    );
  }
}
