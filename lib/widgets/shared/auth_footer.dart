import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthFooter({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText, style: TextStyle(color: Color(0xFF4C9581),fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
