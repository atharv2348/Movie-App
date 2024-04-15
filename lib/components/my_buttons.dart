import 'package:flutter/material.dart';

class MyFilledButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyFilledButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
        )
      )
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyOutlinedButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
          // backgroundColor: Colors.black,
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black),
          )),
      child: Center(
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
    );
  }
}
