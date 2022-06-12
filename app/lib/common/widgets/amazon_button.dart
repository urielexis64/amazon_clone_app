import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';

class AmazonButton extends StatelessWidget {
  const AmazonButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: GlobalVariables.secondaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16)),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
