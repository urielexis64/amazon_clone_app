import 'package:flutter/material.dart';

class AmazonTextField extends StatelessWidget {
  const AmazonTextField(
      {Key? key, required this.hintText, this.validator, this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38)),
          hintText: hintText),
    );
  }
}
