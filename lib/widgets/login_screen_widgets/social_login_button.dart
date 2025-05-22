import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final String? imagePath;

  const SocialLoginButton({
    super.key,
    this.icon,
    required this.text,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: imagePath != null
          ? Image.asset(
        imagePath!,
        width: 24,
        height: 24,
      )
          : Icon(icon),
      label: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
