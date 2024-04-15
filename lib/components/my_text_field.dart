import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  String hintText;
  final void Function(String content)? onChanged;
  final bool obsecureText;
  final TextInputType keyboardType;
  final Icon prefixIcon;
  final bool info;
  final String infoData;

  MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText,
      this.keyboardType = TextInputType.text,
      required this.prefixIcon,
      this.onChanged,
      this.info = false,
      this.infoData = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      cursorRadius: const Radius.circular(100),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade500)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        filled: true,
        fillColor: Colors.black,
      ),
    );
  }
}
